Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbXCWSub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbXCWSub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbXCWSua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:50:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32899 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753339AbXCWSuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:50:25 -0400
Date: Fri, 23 Mar 2007 19:50:28 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Stephane Casset <sept@logidee.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       David L <idht4n@hotmail.com>, Bob Tracy <rct@gherkin.frus.com>,
       John Stultz <johnstul@us.ibm.com>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, Emil Karlson <jkarlson@cc.hut.fi>
Subject: [4/5] 2.6.21-rc4: known regressions (v2)
Message-ID: <20070323185028.GR752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : system doesn't come out of suspend  (CONFIG_NO_HZ)
References : http://lkml.org/lkml/2007/2/22/391
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
             Soeren Sonnenburg <kernel@nn7.de>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
             Tejun Heo <htejun@gmail.com>
             Rafael J. Wysocki <rjw@sisk.pl>
Status     : problem is being debugged


Subject    : first disk access after resume takes several minutes
             ('date' does not advance after resume from RAM, CONFIG_NO_HZ=n)
References : http://lkml.org/lkml/2007/3/8/117
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
Status     : problem is being debugged


Subject    : Dynticks and High resolution Timer hanging the system
             workaround: clocksource=acpi_pm
References : http://lkml.org/lkml/2007/3/7/504
Submitter  : Stephane Casset <sept@logidee.com>
Caused-By  : Thomas Gleixner <tglx@linutronix.de>
Status     : unknown


Subject    : soft lockup detected on CPU#0
References : http://lkml.org/lkml/2007/3/3/152
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
Status     : unknown


Subject    : gettimeofday increments too slowly
References : http://bugzilla.kernel.org/show_bug.cgi?id=8027
Submitter  : David L <idht4n@hotmail.com>
Caused-By  : Thomas Gleixner <tglx@linutronix.de>
             commit 92c7e00254b2d0efc1e36ac3e45474ce1871b6b2
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged


Subject    : boot hangs during IDE detection  (clocksource)
References : http://lkml.org/lkml/2007/3/19/465
Submitter  : Bob Tracy <rct@gherkin.frus.com>
Caused-By  : John Stultz <johnstul@us.ibm.com>
             commit 6bb74df481223731af6c7e0ff3adb31f6442cfcd
Handled-By : John Stultz <johnstul@us.ibm.com>
Status     : problem is being debugged


Subject    : dynticks makes ksoftirqd1 use unreasonable amount of cpu time
References : http://bugzilla.kernel.org/show_bug.cgi?id=8100
Submitter  : Emil Karlson <jkarlson@cc.hut.fi>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged


