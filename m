Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbXEMBMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbXEMBMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 21:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbXEMBMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 21:12:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755877AbXEMBMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 21:12:12 -0400
Date: Sat, 12 May 2007 18:11:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-Id: <20070512181140.50140334.akpm@linux-foundation.org>
In-Reply-To: <1178999770.22481.211.camel@localhost.localdomain>
References: <20070430102837.748238000@linutronix.de>
	<20070511132846.5ebf4437.akpm@linux-foundation.org>
	<200705112302.47726.rjw@sisk.pl>
	<200705112309.15996.rjw@sisk.pl>
	<20070511235607.83ad0eb5.akpm@linux-foundation.org>
	<1178959563.22481.126.camel@localhost.localdomain>
	<20070512020056.a24cf472.akpm@linux-foundation.org>
	<1178961489.22481.133.camel@localhost.localdomain>
	<20070512030754.90488f79.akpm@linux-foundation.org>
	<1178970253.22481.143.camel@localhost.localdomain>
	<20070512095145.0cf58a57.akpm@linux-foundation.org>
	<1178989302.22481.185.camel@localhost.localdomain>
	<20070512102350.04126320.akpm@linux-foundation.org>
	<1178999770.22481.211.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 21:56:10 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sat, 2007-05-12 at 10:23 -0700, Andrew Morton wrote:
> > The broken-out queue should turn up at
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/
> > in a few minutes.
> 
> Sigh. I can't reproduce your lockdep problem :(

We should write a Vaio emulator.

> Can you send me your .config please ?
> 

http://userweb.kernel.org/~akpm/config-sony.txt
