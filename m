Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbXCMMvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbXCMMvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXCMMub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:50:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58021 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933295AbXCMMuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:50:22 -0400
Date: Tue, 13 Mar 2007 13:50:25 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephane Casset <sept@logidee.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>, Tejun Heo <htejun@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org
Subject: [6/6] 2.6.21-rc3: known regressions
Message-ID: <20070313125025.GW18731@stusta.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : Dynticks and High resolution Timer hanging the system
References : http://lkml.org/lkml/2007/3/7/504
Submitter  : Stephane Casset <sept@logidee.com>
Caused-By  : Thomas Gleixner <tglx@linutronix.de>
Status     : unknown


Subject    : Clocksource tsc unstable (delta = -154983451 ns)
References : http://lkml.org/lkml/2007/3/9/271
Submitter  : Jiri Slaby <jirislaby@gmail.com>
Status     : unknown


Subject    : hrtimer_switch_to_hres():
             wrong tick_init_highres() return value handling
References : http://lkml.org/lkml/2007/3/6/262
Submitter  : Linus Torvalds <torvalds@linux-foundation.org>
Caused-By  : Thomas Gleixner <tglx@linutronix.de>
             commit 54cdfdb47f73b5af3d1ebb0f1e383efbe70fde9e
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : unknown


Subject    : soft lockup detected on CPU#0
References : http://lkml.org/lkml/2007/3/3/152
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
Status     : unknown


Subject    : dynticks makes ksoftirqd1 use unreasonable amount of cpu time
References : http://bugzilla.kernel.org/show_bug.cgi?id=8100
Submitter  : Emil Karlson <jkarlson@cc.hut.fi>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged


Subject    : system doesn't come out of suspend  (CONFIG_NO_HZ)
References : http://lkml.org/lkml/2007/2/22/391
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
             Soeren Sonnenburg <kernel@nn7.de>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
             Tejun Heo <htejun@gmail.com>
             Rafael J. Wysocki <rjw@sisk.pl>
Status     : problem is being debugged



