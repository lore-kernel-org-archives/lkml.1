Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbZKKOGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbZKKOGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbZKKOGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:06:17 -0500
Received: from www.tglx.de ([62.245.132.106]:47128 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500AbZKKOGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:06:16 -0500
Message-Id: <20091111134018.393422332@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Nov 2009 14:05:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Ralf Baechle <ralf@linux-mips.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/3] Provide generic function to calc mult/shift factors for
	clocks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MIPS tree has functions to calculate the mult/shift factors for
clock events and clock sources. ARM needs such functions as well. 

This patch set provides a generic function which replaces the MIPS
implementation.

Thanks,

	tglx


