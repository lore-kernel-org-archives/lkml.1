Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbYHBTXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbYHBTXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYHBTXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:23:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37984 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbYHBTXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:23:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.27-rc1-git4: Reported regressions from 2.6.26
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cbItfVMShGI.A.olC.UMLlIB@albercik>
Date: Sat,  2 Aug 2008 19:59:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Note that all of the suspend/resume regressions seem to result from the same
couple of bugs, or even one bug, but since that has not been confirmed yet,
they are listed separately.

Bug submitters also please note that if you CC your reports to
kernel-testers@vger.kernel.org, they will be _much_ easier to track for me
and pretty much everybody else.]

This message contains a list of some regressions from 2.6.26, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.26, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-08-02       47       31          20


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11233
Subject		: serial/bfin_5xx.c build error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-08-02 11:18 (1 days old)
References	: http://lkml.org/lkml/2008/8/2/116


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11232
Subject		: Console Suspend - Resume Regression
Submitter	: Dionisus Torimens <djtm@gmx.net>
Date		: 2008-08-02 10:56 (1 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11231
Subject		: gspca_zc3xx oops - 2.6.27-rc1
Submitter	: Parag Warudkar <parag.warudkar@gmail.com>
Date		: 2008-08-02 16:22 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121769418920774&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11230
Subject		: Kconfig no longer outputs a .config with freshly updated defconfigs
Submitter	: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date		: 2008-08-02 16:03 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121769306319391&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11229
Subject		: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux, post-2.6.27-rc1
Submitter	: Paul Collins <paul@burly.ondioline.org>
Date		: 2008-08-02 12:03 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121767906702209&w=4
Handled-By	: J. Bruce Fields <bfields@fieldses.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11228
Subject		: p54usb broken by commit b19fa1f
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2008-08-02 3:06 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121764647801783&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
Subject		: Only three cores found on quad-core machine.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-08-01 18:15 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11221
Subject		: 2.6.27-rc1 oops when plugging USB disk
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-08-01 13:35 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121759786223716&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11220
Subject		: Heavy suspend and io problems in 2.6.27-rc1-00156-g94ad374
Submitter	: Nico Schottelius <nico@schottelius.org>
Date		: 2008-07-31 21:05 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121753882422899&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11219
Subject		: KVM modules break emergency reboot
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-08-01 20:25 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121762241105336&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11218
Subject		: drivers/serial/crisv10.c build error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-08-01 14:48 (2 days old)
References	: http://lkml.org/lkml/2008/8/1/431


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11215
Subject		: INFO: possible recursive locking detected ps2_command
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-07-31 9:41 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121749737011637&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11214
Subject		: 2.6.27-rc1: I/O errors after resume
Submitter	: Miklos Szeredi <miklos@szeredi.hu>
Date		: 2008-07-31 13:04 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121750960431966&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11210
Subject		: libata badness
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-07-31 18:53 (3 days old)
References	: http://marc.info/?l=linux-ide&m=121753059307310&w=4
Handled-By	: Ben Dooks <ben-linux@fluff.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11209
Subject		: 2.6.27-rc1 process time accounting
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-07-31 10:43 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121750102917490&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
Subject		: VolanoMark regression with 2.6.27-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-07-31 3:20 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11205
Subject		: x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-07-30 11:02 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121741584608240&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11191
Subject		: 2.6.26-git8: spinlock lockup in c1e_idle()
Submitter	: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Date		: 2008-07-24 03:22 (10 days old)
References	: http://lkml.org/lkml/2008/7/23/317
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11181
Subject		: power-off broken
Submitter	: Mircea Gherzan <mgherzan@anaconda.cs.pub.ro>
Date		: 2008-07-30 13:57 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11141
Subject		: no battery or DC status - Dell i1501
Submitter	: Gu Rui <chaos.proton@gmail.com>
Date		: 2008-07-21 19:43 (13 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11235
Subject		: acer-wmi broken in latest git kernel on TravelMate 6492 (Insufficient arguments - method [WQAA])
Submitter	: Sven Wegener <sven.wegener@stealer.net>
Date		: 2008-08-02 15:50:54 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121769235318600&w=4
Handled-By	: Carlos Corbacho <carlos@strangeworlds.co.uk>
Patch		: http://marc.info/?l=linux-kernel&m=121769591723088&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11227
Subject		: BUG on booting 2.6.27-rc1
Submitter	: Steve Wise <swise@opengridcomputing.com>
Date		: 2008-08-01 20:56 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121762419708424&w=4
Handled-By	: Jeremy Fitzhardinge <jeremy@goop.org>
Patch		: http://marc.info/?l=linux-kernel&m=121762583111470&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11225
Subject		: mtdsuper.c BLOCK=n compile error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-08-01 15:33 (2 days old)
References	: http://lkml.org/lkml/2008/8/1/454
Handled-By	: David Woodhouse <dwmw2@infradead.org>
Patch		: http://lkml.org/lkml/2008/8/1/499


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11223
Subject		: sh: fix LIBGCC
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-08-01 15:16 (2 days old)
References	: http://lkml.org/lkml/2008/8/1/446
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://lkml.org/lkml/2008/8/1/446


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11216
Subject		: sh O= builds broken
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-08-01 14:31 (2 days old)
References	: http://lkml.org/lkml/2008/8/1/426
Handled-By	: Paul Mundt <lethal@linux-sh.org>
Patch		: http://lkml.org/lkml/2008/8/1/437


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11204
Subject		: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks PXA270 (at least)?
Submitter	: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date		: 2008-07-29 22:31 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=121737075314966&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://marc.info/?l=linux-kernel&m=121754090926333&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11201
Subject		: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
Submitter	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Date		: 2008-07-29 16:21 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=121734804508255&w=4
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
		  Eric W. Biederman <ebiederm@xmission.com>
Patch		: http://marc.info/?l=linux-kernel&m=121735924628623&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11197
Subject		: Oops in microcode sysfs registration
Submitter	: Alistair John Strachan <alistair@devzero.co.uk>
Date		: 2008-07-29 13:57 (5 days old)
References	: http://marc.info/?t=121734004900002&r=1&w=4
Handled-By	: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=121741431005777&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11190
Subject		: [USB boot crash, -git] ecm_do_notify(), list_add corruption. prev-&gt;next should be next (ffff88003b8f82f8)
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-07-22 13:40 (12 days old)
References	: http://marc.info/?l=linux-usb&m=121673409124827&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
		  David Brownell <david-b@pacbell.net>
Patch		: http://marc.info/?l=linux-kernel&m=121708481823201&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11189
Subject		: sky2 WOL broken
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-07-20 0:20:10 (14 days old)
References	: http://marc.info/?l=linux-next&m=121651311115104&w=4
Handled-By	: Stephen Hemminger <shemminger@vyatta.com>
Patch		: http://marc.info/?l=linux-netdev&m=121694346401281&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11178
Subject		: Secondary hard drive fails during both hibernation and resume.
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-07-30 04:53 (4 days old)
Handled-By	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17043&action=view


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.26,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=11167

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

