Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZKLQ7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZKLQ7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZKLQ73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:59:29 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:60226 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbZKLQ72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:59:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19196.16098.198722.829776@pilspetsen.it.uu.se>
Date: Thu, 12 Nov 2009 17:59:14 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Mikael Pettersson <mikpe@it.uu.se>,
       Ralf Baechle <ralf@linux-mips.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/3] Provide generic function to calc mult/shift factors for
	clocks
In-Reply-To: <20091111134018.393422332@linutronix.de>
References: <20091111134018.393422332@linutronix.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner writes:
 > The MIPS tree has functions to calculate the mult/shift factors for
 > clock events and clock sources. ARM needs such functions as well. 
 > 
 > This patch set provides a generic function which replaces the MIPS
 > implementation.

I rebased my ARM IOP clocksource/clockevent patch kit on these
generic functions, and it works fine and results in the exact
same shift/mult values as with my clone of the MIPS code.

Tested-by: Mikael Pettersson <mikpe@it.uu.se>
