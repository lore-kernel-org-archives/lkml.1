Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0BAAdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 19:33:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50310 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab0BAAdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:33:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.33-rc6: Reported regressions from 2.6.32
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
Message-ID: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
Date: Mon,  1 Feb 2010 01:18:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.32, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.32, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2010-02-01       85       26          21
  2010-01-24       75       29          23
  2010-01-10       55       33          21
  2009-12-29       36       34          27


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15202
Subject		: lockdep warning during elevator_switch
Submitter	: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Date		: 2010-01-31 23:55 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=126498212613051&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15200
Subject		: NFS problems in 2.6.33-rc6: Unknown error 526
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2010-01-31 22:46 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=126497800408928&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15199
Subject		: sata_nv and no /dev files
Submitter	: Bartłomiej Zimoń <uzi18@o2.pl>
Date		: 2010-01-31 23:45 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=126498153112488&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15196
Subject		: kmem_cache_create: duplicate cache ccid2_h
Submitter	: Heinz Diehl <htd@fancy-poultry.org>
Date		: 2010-01-30 18:33 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=126487640324942&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15192
Subject		: netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2010-01-25 10:03 (7 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1b9508f6831e10d53256825de8904caa22d1ca2c
References	: http://marc.info/?l=linux-kernel&m=126441481427331&w=4
Handled-By	: Mike Galbraith <efault@gmx.de>
		  Peter Zijlstra <peterz@infradead.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15144
Subject		: HDA Intel Audio hang on boot
Submitter	: Sid Boyce <sboyce@blueyonder.co.uk>
Date		: 2010-01-15 1:24 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=126351866722507&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15142
Subject		: "INFO: possible circular locking dependency detected"
Submitter	: Matti Aarnio <matti.aarnio--kernel-bugzilla@zmailer.org>
Date		: 2010-01-25 13:38 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15139
Subject		: e1000: transmit queue 0 timed out
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2010-01-23 15:37 (9 days old)
References	: http://marc.info/?l=linux-netdev&m=126426149306083&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15138
Subject		: evdev regression on macbook
Submitter	: Guillaume Chazarain <guichaz@gmail.com>
Date		: 2010-01-23 18:53 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=126427286219235&w=4
Handled-By	: Dmitry Torokhov <dmitry.torokhov@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15125
Subject		: hung task - jbd2/dm-1-8 (during raid rebuild)
Submitter	: Michael Breuer <mbreuer@majjas.com>
Date		: 2010-01-10 21:47 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=126316012025978&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15124
Subject		: PCI host bridge windows ignored (works with pci=use_crs)
Submitter	: Jeff Garrett <jeff@jgarrett.org>
Date		: 2010-01-13 5:37 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=126336296600307&w=4
Handled-By	: Yinghai Lu <yinghai@kernel.org>
		  Bjorn Helgaas <bjorn.helgaas@hp.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15119
Subject		: iwl_bg_scan_completed: WARN on scan complete
Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
Date		: 2010-01-24 12:27 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15114
Subject		: X.org hang with [drm:i915_gem_do_execbuffer] *ERROR* in dmesg
Submitter	: Matej Laitl <strohel@gmail.com>
Date		: 2010-01-23 19:54 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15076
Subject		: System panic under load with clockevents_program_event
Submitter	: okias <d.okias@gmail.com>
Date		: 2010-01-17 13:03 (15 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15043
Subject		: Display goes off with i915.powersave=1 after suspend-resume
Submitter	: Soeren Sonnenburg <sonne@debian.org>
Date		: 2010-01-10 20:09 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=126315457519505&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15036
Subject		: soft lockup in dmesg after suspend/resume
Submitter	: ykzhao <yakui.zhao@intel.com>
Date		: 2010-01-04 5:36 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=126258356202722&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15025
Subject		: Oops in ext4 driver
Submitter	: Steinar H. Gunderson <sgunderson@bigfoot.com>
Date		: 2010-01-10 13:09 (22 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14999
Subject		: possible circular locking dependency detected in rfkill at suspend
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-01-06 21:52 (26 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14950
Subject		: tbench regression with 2.6.33-rc1
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2009-12-25 11:11 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=126174044213172&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14937
Subject		: WARNING: at kernel/lockdep.c:2830
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-12-27 13:35 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=126192220404829&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14792
Subject		: Misdetection of the TV output
Submitter	: Santi <santi@agolina.net>
Date		: 2009-12-12 13:28 (51 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=27dfaf4f5825a119305db1bc63bef30ed400e376
Handled-By	: Zhao Yakui <yakui.zhao@intel.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15198
Subject		: Radeon KMS regression
Submitter	: Kevin Winchester <kjwinchester@gmail.com>
Date		: 2010-01-30 17:18 (2 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=42590a75019a50012f25a962246498dead428433
References	: http://marc.info/?l=linux-kernel&m=126487191019612&w=4
Handled-By	: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Patch		: http://patchwork.kernel.org/patch/75023/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15195
Subject		: kernel BUG at include/net/netns/generic.h:41, pfkey_create+0x36/0x18b [af_key]
Submitter	: Luca Tettamanti <kronos.it@gmail.com>
Date		: 2010-01-30 13:23 (2 days old)
References	: http://marc.info/?l=linux-netdev&m=126485785004775&w=4
Handled-By	: Alexey Dobriyan <adobriyan@gmail.com>
Patch		: http://patchwork.kernel.org/patch/75891/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15039
Subject		: leds_alix2: can't allocate I/O for GPIO
Submitter	: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Date		: 2010-01-07 10:26 (25 days old)
References	: http://marc.info/?l=linux-kernel&m=126286001106257&w=4
Handled-By	: Daniel Mack <daniel@caiaq.de>
Patch		: http://patchwork.kernel.org/patch/72006/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14949
Subject		: drm_vm.c:drm_mmap: possible circular locking dependency detected
Submitter	: Borislav Petkov <petkovbb@googlemail.com>
Date		: 2009-12-26 9:45 (37 days old)
References	: http://marc.info/?l=linux-kernel&m=126182073616279&w=4
Handled-By	: Eric W. Biederman <ebiederm@aristanetworks.com>
Patch		: http://patchwork.kernel.org/patch/70461/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14791
Subject		: Something has been broken in the network stack this week
Submitter	: Delete This Account <speedyboyinovator@hotmail.com>
Date		: 2009-12-12 13:06 (51 days old)
Handled-By	: Ben Hutchings <ben@decadent.org.uk>
Patch		: http://patchwork.kernel.org/patch/72073/


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.32,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=14885

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

