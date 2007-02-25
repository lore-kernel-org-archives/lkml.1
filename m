Return-Path: <linux-kernel-owner+w=401wt.eu-S965046AbXBYR4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046AbXBYR4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 12:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965064AbXBYR4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 12:56:00 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43908 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965046AbXBYRz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 12:55:59 -0500
Date: Sun, 25 Feb 2007 18:55:59 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       pavel@suse.cz, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070225175559.GC12392@stusta.de>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.21-rc1 compared to 2.6.20
that are not yet fixed in Linus' tree.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way possibly
involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : ThinkPad T60: system doesn't come out of suspend to RAM
             (CONFIG_NO_HZ)
References : http://lkml.org/lkml/2007/2/22/391
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
             Thomas Gleixner <tglx@linutronix.de>
Handled-By : Ingo Molnar <mingo@elte.hu>
Status     : unknown


Subject    : kernel BUG at kernel/time/tick-sched.c:168  (CONFIG_NO_HZ)
References : http://lkml.org/lkml/2007/2/16/346
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged


Subject    : BUG: soft lockup detected on CPU#0
             NOHZ: local_softirq_pending 20
References : http://lkml.org/lkml/2007/2/20/257
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
Status     : problem is being debugged


Subject    : i386: no boot with nmi_watchdog=1  (clockevents)
References : http://lkml.org/lkml/2007/2/21/208
Submitter  : Daniel Walker <dwalker@mvista.com>
Caused-By  : Thomas Gleixner <tglx@linutronix.de>
             commit e9e2cdb412412326c4827fc78ba27f410d837e6e
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged


