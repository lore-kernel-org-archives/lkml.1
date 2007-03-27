Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbXC0CAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbXC0CAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 22:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933925AbXC0CAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 22:00:00 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35556 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752641AbXC0B7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:59:50 -0400
Date: Tue, 27 Mar 2007 03:59:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?utf-8?B?RnLDqWTDqXJpYw==?= Riss <frederic.riss@gmail.com>,
       Tino Keitel <tino.keitel@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       John Stultz <johnstul@us.ibm.com>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Mike Harris <atarimike@wavecable.com>,
       Stephane Casset <sept@logidee.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Soeren Sonnenburg <kernel@nn7.de>, Tejun Heo <htejun@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [5/5] 2.6.21-rc5: known regressions
Message-ID: <20070327015954.GC16477@stusta.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : MacMini doesn't come out of suspend to ram  (i386 clockevents)
             (CONFIG_HPET_TIMER)
References : http://lkml.org/lkml/2007/3/21/374
Submitter  : Frédéric Riss <frederic.riss@gmail.com>
             Tino Keitel <tino.keitel@gmx.de>
Caused-By  : Thomas Gleixner <tglx@linutronix.de>
             commit e9e2cdb412412326c4827fc78ba27f410d837e6e
Status     : unknown


Subject    : MacBook Core Duo: suspend to disk hangs
References : http://bugzilla.kernel.org/show_bug.cgi?id=8224
Submitter  : Mike Harris <atarimike@wavecable.com>
Status     : unknown


Subject    : Dynticks and High resolution Timer hang boot during IDE detection
             workaround: clocksource=acpi_pm
References : http://lkml.org/lkml/2007/3/7/504
Submitter  : Stephane Casset <sept@logidee.com>
Caused-By  : John Stultz <johnstul@us.ibm.com>
             commit 6bb74df481223731af6c7e0ff3adb31f6442cfcd
Handled-By : John Stultz <johnstul@us.ibm.com>
Patch      : http://lkml.org/lkml/2007/3/22/287
Status     : workaround-patch available


Subject    : after resume: X hangs after drawing a couple of windows
             workaround: clocksource=acpi_pm
References : http://lkml.org/lkml/2007/3/8/117
             http://lkml.org/lkml/2007/3/25/20
             http://lkml.org/lkml/2007/3/26/151
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged


Subject    : first disk access after resume takes several minutes
             resume from RAM broken
             'date' does not advance after resume from RAM  (CONFIG_HPET_TIMER)
References : http://lkml.org/lkml/2007/3/8/117
             http://lkml.org/lkml/2007/3/25/20
             http://lkml.org/lkml/2007/3/26/18
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
             Jeff Chua <jeff.chua.linux@gmail.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
Status     : problem is being debugged


Subject    : system doesn't come out of suspend  (CONFIG_NO_HZ)
References : http://lkml.org/lkml/2007/2/22/391
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
             Soeren Sonnenburg <kernel@nn7.de>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
             Tejun Heo <htejun@gmail.com>
             Rafael J. Wysocki <rjw@sisk.pl>
Status     : unknown


Subject    : suspend to disk hangs  (CONFIG_NO_HZ)
References : http://lkml.org/lkml/2007/3/25/217
Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
Status     : unknown


