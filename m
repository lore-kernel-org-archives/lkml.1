Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbXCEBvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbXCEBvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbXCEBvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:51:10 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:50035 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783AbXCEBuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:50:39 -0500
Date: Mon, 5 Mar 2007 02:50:41 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Soeren Sonnenburg <kernel@nn7.de>, Daniel Walker <dwalker@mvista.com>
Subject: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070305015040.GJ3441@stusta.de>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.21-rc2 compared to 2.6.20
that are not yet fixed in Linus' tree.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : soft lockup detected on CPU#0
References : http://lkml.org/lkml/2007/3/3/152
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : unknown


Subject    : dynticks makes ksoftirqd1 use unreasonable amount of cpu time
References : http://bugzilla.kernel.org/show_bug.cgi?id=8100
Submitter  : Emil Karlson <jkarlson@cc.hut.fi>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged


Subject    : ThinkPad T60: system doesn't come out of suspend to RAM
             (CONFIG_NO_HZ)
References : http://lkml.org/lkml/2007/2/22/391
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
Status     : unknown


Subject    : macbook pro suspend to ram broken  (clockevents)
References : http://lkml.org/lkml/2007/3/4/110
Submitter  : Soeren Sonnenburg <kernel@nn7.de>
Caused-By  : Thomas Gleixner <tglx@linutronix.de>
             commit e9e2cdb412412326c4827fc78ba27f410d837e6e
Status     : unknown


Subject    : i386: no boot with nmi_watchdog=1  (clockevents)
References : http://lkml.org/lkml/2007/2/21/208
Submitter  : Daniel Walker <dwalker@mvista.com>
Caused-By  : Thomas Gleixner <tglx@linutronix.de>
             commit e9e2cdb412412326c4827fc78ba27f410d837e6e
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged

