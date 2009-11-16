Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZKPWrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZKPWrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZKPWrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:47:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60107 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbZKPWrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:47:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.32-rc7-git1: Reported regressions from 2.6.31
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
Date: Mon, 16 Nov 2009 23:33:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.31, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.31, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2009-11-16       84       46          41
  2009-10-26       66       42          37
  2009-10-12       48       31          27
  2009-10-02       22       15           9


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14629
Subject		: Oops on i915 on 8086:a011 pine trail
Submitter	: Luis R. Rodriguez <mcgrof@gmail.com>
Date		: 2009-11-10 23:27 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=125789570519147&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14628
Subject		: drm/ksm -> s2disk -> resume -> [drm:r100_ring_test] *ERROR* radeon: ring test failed
Submitter	: Christian Hartmann <cornogle@googlemail.com>
Date		: 2009-11-06 15:46 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=125752241331067&w=4
Handled-By	: Jerome Glisse <glisse@freedesktop.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14627
Subject		: i915: *ERROR* Execbuf while wedged
Submitter	: Michael <schnitzelkuchen@googlemail.com>
Date		: 2009-11-15 10:48 (2 days old)
References	: http://lkml.org/lkml/2009/11/15/40


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14626
Subject		: oops on boot starting udev
Submitter	: Soeren Sonnenburg <sonne@debian.org>
Date		: 2009-11-14 10:16 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=125819380206800&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14625
Subject		: Commit d451564 breaks ARM
Submitter	: Russell King <rmk+lkml@arm.linux.org.uk>
Date		: 2009-11-13 15:11 (4 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d4515646699b6ad7b1a98ceb871296b957f3ef47
References	: http://marc.info/?l=linux-kernel&m=125812520315835&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14624
Subject		: ath9k: BUG kmalloc-8192: Poison overwritten
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-11-12 4:58 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=125800196520396&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14622
Subject		: Second IDE device not found
Submitter	: Zeno Davatz <zdavatz@gmail.com>
Date		: 2009-11-11 17:31 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=125796105822353&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14621
Subject		: specjbb2005 and aim7 regression with 2.6.32-rc kernels
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-11-06 7:38 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=125749310413174&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14620
Subject		: WARNING: at mm/page_alloc.c:1805 __alloc_pages_nodemask
Submitter	: Rogério Brito <rbrito@ime.usp.br>
Date		: 2009-11-06 23:10 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=125754907413892&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14619
Subject		: ext3/jbd oops in journal_start
Submitter	: Sage Weil <sage@newdream.net>
Date		: 2009-10-31 6:14 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=125696970418300&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14618
Subject		: OOM killer, page fault
Submitter	: Norbert Preining <preining@logic.at>
Date		: 2009-10-30 6:32 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=125688434909582&w=4
Handled-By	: Minchan Kim <minchan.kim@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14616
Subject		: [2.6.32 regression] sata_nv: commit 6489e3262e6b188a1a009b65e8a94b7aa17645b7 slows down system boot
Submitter	: Artem S. Tashkinov <t.artem@mailcity.com>
Date		: 2009-11-16 19:49 (1 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14577
Subject		: Data Corruption with Adaptec 52445, Firmware 5.2-0 (17380)
Submitter	:  <lkolbe@techfak.uni-bielefeld.de>
Date		: 2009-11-10 13:31 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14538
Subject		: Unable to associate with AP after resume since 2.6.32-rc6
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-11-03 22:07 (14 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14504
Subject		: intermittent hibernation problem again
Submitter	: Ferenc Wágner <wferi@niif.hu>
Date		: 2009-10-28 23:49 (20 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
Submitter	: Justin P. Mattock <justinmattock@gmail.com>
Date		: 2009-10-23 16:45 (25 days old)
References	: http://lkml.org/lkml/2009/10/23/252


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14485
Subject		: System lockup running "cat /sys/kernel/debug/dri/0/i915_regs"
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-10-26 4:00 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=125652968117713&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14483
Subject		: Interrupts enabled after irqrouter_resume - iMac9,1
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2009-10-25 19:58 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=125650070420168&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14482
Subject		: kernel BUG at fs/dcache.c:670 +lvm +md +ext3
Submitter	: Alexander Clouter <alex@digriz.org.uk>
Date		: 2009-10-23 10:30 (25 days old)
References	: http://lkml.org/lkml/2009/10/23/50


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14481
Subject		: umount blocked for more than 120 seconds after USB drive removal
Submitter	: Robert Hancock <hancockrwd@gmail.com>
Date		: 2009-10-21 5:26 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=125610280532245&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14472
Subject		: EXT4 corruption
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2009-10-13 2:07 (35 days old)
References	: http://marc.info/?l=linux-kernel&m=125539997508256&w=4
Handled-By	: Theodore Tso <tytso@mit.edu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14467
Subject		: Linker errors on ia64 with NR_CPUS=4096
Submitter	: Jeff Mahoney <jeffm@suse.com>
Date		: 2009-10-18 22:28 (30 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=34d76c41554a05425613d16efebb3069c4c545f0
References	: http://marc.info/?l=linux-kernel&m=125590493116720&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14442
Subject		: resume after hibernate: /dev/sdb drops and returns as /dev/sde
Submitter	: Duncan <1i5t5.duncan@cox.net>
Date		: 2009-10-20 01:52 (28 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14436
Subject		: Computer becomes unusable without any apparent reason
Submitter	: Pitxyoki <Pitxyoki@gmail.com>
Date		: 2009-10-18 18:32 (30 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14430
Subject		: sync() hangs in bdi_sched_wait
Submitter	: Petr Vandrovec <petr@vandrovec.name>
Date		: 2009-10-17 19:14 (31 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14426
Subject		: CE: hpet increasing min_delta_ns flood
Submitter	: Thibault Mondary <thibm@free.fr>
Date		: 2009-10-17 09:29 (31 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14415
Subject		: Reboot on kernel load
Submitter	: Brian Beardall <brian@rapsure.net>
Date		: 2009-10-15 23:57 (33 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14406
Subject		: uvcvideo stopped work on Toshiba
Submitter	: okias <d.okias@gmail.com>
Date		: 2009-10-14 19:08 (34 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14384
Subject		: tbench regression with 2.6.32-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-10-09 9:51 (39 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59abf02644c45f1591e1374ee7bb45dc757fcb88
References	: http://marc.info/?l=linux-kernel&m=125508216713138&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14383
Subject		: hackbench regression with kernel 2.6.32-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-10-09 9:19 (39 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=29cd8bae396583a2ee9a3340db8c5102acf9f6fd
References	: http://marc.info/?l=linux-kernel&m=125508007510274&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14376
Subject		: Kernel NULL pointer dereference/ kvm subsystem
Submitter	: Don Dupuis <dondster@gmail.com>
Date		: 2009-10-06 14:38 (42 days old)
References	: http://marc.info/?l=linux-kernel&m=125484025021737&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14373
Subject		: Task blocked for more than 120 seconds
Submitter	: Zeno Davatz <zdavatz@gmail.com>
Date		: 2009-10-02 10:16 (46 days old)
References	: http://marc.info/?l=linux-kernel&m=125447858618412&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14372
Subject		: ath5k wireless not working after suspend-resume - eeepc
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2009-10-03 15:36 (45 days old)
References	: http://lkml.org/lkml/2009/10/3/91


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14355
Subject		: USB serial regression after 2.6.31.1 with Huawei E169 GSM modem
Submitter	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date		: 2009-10-10 03:07 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=125513456327542&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14354
Subject		: Bad corruption with 2.6.32-rc1 and upwards
Submitter	: Holger Freyther <zecke@selfish.org>
Date		: 2009-10-09 15:42 (39 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14352
Subject		: WARNING: at net/mac80211/scan.c:267
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-10-08 00:30 (40 days old)
References	: http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089#c7


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14331
Subject		: Radeon XPRESS 200M: System hang with radeon DRI and Fedora 10 userspace unless DRI=off
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2009-10-06 00:29 (42 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14298
Subject		: warning at manage.c:361 (set_irq_wake), matrix-keypad related?
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-30 20:07 (48 days old)
References	: http://marc.info/?l=linux-kernel&m=125434130703538&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14297
Subject		: console resume broken since ba15ab0e8d
Submitter	: Sascha Hauer <s.hauer@pengutronix.de>
Date		: 2009-09-30 15:11 (48 days old)
References	: http://marc.info/?l=linux-kernel&m=125432349404060&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14296
Subject		: spitz boots but suspend/resume is broken
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-30 12:06 (48 days old)
References	: http://marc.info/?l=linux-kernel&m=125431244516449&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14277
Subject		: Caught 8-bit read from freed memory in b43 driver at association
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-09-30 18:06 (48 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14630
Subject		: sched_rt_periodic_timer vs cpu hotplug
Submitter	: Heiko Carstens <heiko.carstens@de.ibm.com>
Date		: 2009-11-11 10:18 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=125793470309588&w=4
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://patchwork.kernel.org/patch/60250/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14597
Subject		: thinkpad-acpi: driver fails to load on old BIOS for the A31, T23-T30, X30-X31
Submitter	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date		: 2009-11-13 20:45 (4 days old)
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23770


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14480
Subject		: 2 locks held by cat -- running "find /sys | head -c 4" --> system hang
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-10-20 16:11 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=125605511728088&w=4
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>
Patch		: http://patchwork.kernel.org/patch/54974/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14380
Subject		: Video tearing/glitching with T400 laptops
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2009-10-02 22:40 (46 days old)
References	: http://marc.info/?l=linux-kernel&m=125452324520623&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
Patch		: http://marc.info/?l=linux-kernel&m=125591495325000&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14379
Subject		: ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2009-10-08 21:46 (40 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9adc2e031bd22d5d9607a53a8d3b30e0b675f39
References	: http://marc.info/?l=linux-kernel&m=125504031328941&w=4
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23347


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.31,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=14230

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

