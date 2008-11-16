Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYKPSXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYKPSXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYKPSWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:22:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42836 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbYKPSWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:22:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc5: Reported regressions from 2.6.27
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
Date: Sun, 16 Nov 2008 17:24:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NOTES:
 (1) Due to some recent controversies, in future I will only use 'Handled-By'
     tags for people who actually submit a patch or provide substantial help to
     the reporter (like advising him which commits to revert etc.).
 (2) We have almost as many regressions with patches as unresolved ones and
     the majority of these patches have not been merged for over two weeks
     (for almost three weeks in many cases and for over a _month_ in one case).
     IMO, this is insane.]

This message contains a list of some regressions from 2.6.27, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.27, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-11-16       89       32          18
  2008-11-09       73       40          27
  2008-11-02       55       41          29
  2008-10-25       26       25          20


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12049
Subject		: Oops in acpi_system_wakeup_device_seq_show
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2008-11-16 13:04 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0794469da3f7b2093575cbdfc1108308dd3641ce
References	: http://marc.info/?l=linux-kernel&m=122684070215520&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12041
Subject		: 2.6.28-rc4 mem_cgroup_charge_common panic
Submitter	: Badari Pulavarty <pbadari@us.ibm.com>
Date		: 2008-11-10 21:43 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=122635343008147&w=4
Handled-By	: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12040
Subject		: iwlagn driver segfault in 2.6.28-rc3
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-11-11 14:34 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122641417331593&w=4
Handled-By	: reinette chatre <reinette.chatre@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12034
Subject		: snd-hda-intel on Realtek ALC268 chip shows only Master volume (for playback)
Submitter	: Sergey <azure@fast.net.ua>
Date		: 2008-11-15 04:20 (2 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12031
Subject		: DRM enabled kernel hangs hard on resume on x60
Submitter	: Jens Axboe <jens.axboe@oracle.com>
Date		: 2008-11-12 18:42 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=122651551216820&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12028
Subject		: i915 DRM is broken in 2.6.28-rc4
Submitter	: Adam Tkac <vonsch@gmail.com>
Date		: 2008-11-14 01:50 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12019
Subject		: Major increase in the number of wakeups from C3
Submitter	: Mircea Gherzan <mgherzan@anaconda.cs.pub.ro>
Date		: 2008-11-13 07:02 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11996
Subject		: Tracing framework regression in 2.6.28-rc3
Submitter	: Pekka Paalanen <pq@iki.fi>
Date		: 2008-11-09 10:13 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=122624392229317&w=4
Handled-By	: Steven Rostedt <rostedt@goodmis.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11970
Subject		: gettimeofday return a old time in mmbench
Submitter	: alexs <alex.shi@intel.com>
Date		: 2008-11-06 23:57 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=99ebcf8285df28f32fd2d1c19a7166e70f00309c
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11965
Subject		: regression introduced by - timers: fix itimer/many thread hang
Submitter	: Doug Chapman <doug.chapman@hp.com>
Date		: 2008-11-06 11:03 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f06febc96ba8e0af80bcc3eaec0a109e88275fac
References	: http://marc.info/?l=linux-kernel&m=122596943416648&w=4
Handled-By	: Frank Mayhar <fmayhar@google.com>
		  Peter Zijlstra <peterz@infradead.org>
		  Ingo Molnar <mingo@elte.hu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11958
Subject		: [2.6.27.x =&gt; 2.6.28-rc3] Xorg crash with xf86MapVidMem error
Submitter	: Tomasz Chmielewski <tch@wpkg.org>
Date		: 2008-11-05 05:37 (12 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11947
Subject		: 2.6.28-rc VC switching with Intel graphics broken
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-11-03 12:10 (14 days old)
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11913
Subject		: USB/INPUT: slab error in cache_alloc_debugcheck_after(): double free?
Submitter	: Helge Deller <deller@gmx.de>
Date		: 2008-10-30 23:11 (18 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cb8f488c33539f096580e202f5438a809195008f
References	: http://marc.info/?l=linux-kernel&m=122540833301394&w=4
Handled-By	: Jiri Kosina <jkosina@suse.cz>
		  Jiri Slaby <jirislaby@gmail.com>
		  Jiri Kosina <jkosina@suse.cz>
		  Jiri Slaby <jirislaby@gmail.com>
		  Denys Vlasenko <vda.linux@googlemail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11906
Subject		: 2.6.28-rc2 seems to fail at powering down the monitor when it should
Submitter	: Gene Heskett <gene.heskett@gmail.com>
Date		: 2008-10-30 6:39 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=122534879721424&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11905
Subject		: lots of extra timer interrupts costing 2W
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2008-10-30 2:18 (18 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fb02fbc14d17837b4b7b02dbb36142c16a7bf208
References	: http://marc.info/?l=linux-kernel&m=122533314305315&w=4
		  http://marc.info/?l=linux-kernel&m=122541849114444&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11858
Subject		: Timeout regression introduced by 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Submitter	: Tejun Heo <tj@kernel.org>
Date		: 2008-10-26 9:46 (22 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=242f9dcb8ba6f68fcd217a119a7648a4f69290e9
References	: http://marc.info/?l=linux-kernel&m=122501447326698&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11849
Subject		: default IRQ affinity change in v2.6.27 (breaking several SMP PPC based systems)
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-10-24 12:45 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=122485245924125&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11822
Subject		: ACPI Warning (nspredef-0858): _SB_.PCI0.LPC_.EC__.BAT0._BIF: Return Package type mismatch at index 9 - found Buffer, expected String [20080926]
Submitter	: Len Brown <len.brown@intel.com>
Date		: 2008-10-25 01:26 (23 days old)
Handled-By	: Robert Moore <Robert.Moore@intel.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12047
Subject		: ACPI toshiba: only register rfkill if bt is enabled
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-10-28 19:10 (20 days old)
References	: http://marc.info/?l=linux-kernel&m=122522113619025&w=2
Handled-By	: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=122526843117478&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12042
Subject		: USB hid blocks USB port in 2.6.28rc3
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-11-11 0:31 (6 days old)
References	: http://marc.info/?l=linux-usb&m=122636246522848&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
		  Jiri Slaby <jirislaby@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=122661425620251&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12038
Subject		: Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
Submitter	: Tino Keitel <tino.keitel@gmx.de>
Date		: 2008-11-09 20:28 (8 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=66036f5862883fcc9f7ff8550685a5a3de1a57e4
References	: http://marc.info/?l=linux-kernel&m=122626258429689&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://marc.info/?l=linux-kernel&m=122661443120581&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12020
Subject		: scsi_times_out NULL pointer dereference
Submitter	: Bernd Schubert <bs@q-leap.de>
Date		: 2008-11-13 10:30 (4 days old)
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=12020#c4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11989
Subject		: Suspend failure on NForce4-based boards due to chanes in stop_machine
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-11-03 0:28 (14 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c9583e55fa2b08a230c549bd1e3c0bde6c50d9cc
References	: http://marc.info/?l=linux-kernel&m=122567187604356&w=4
Handled-By	: Rusty Russell <rusty@rustcorp.com.au>
Patch		: http://lkml.org/lkml/2008/11/15/69


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11982
Subject		: Fan level 7 after resume wit 2.6.28-rc3
Submitter	: Tino Keitel <tino.keitel@tikei.de>
Date		: 2008-11-05 7:33 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=122587043409186&w=4
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18744&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11954
Subject		: sysprof tracer ABI regression in 2.6.28rc1
Submitter	: Eric Anholt <eric@anholt.net>
Date		: 2008-11-04 22:14 (13 days old)
Handled-By	: Eric Anholt <eric@anholt.net>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18683&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11925
Subject		: cdrom: missing compat ioctls
Submitter	: Andreas Schwab <schwab@suse.de>
Date		: 2008-10-31 14:02 (17 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=33c2dca4957bd0da3e1af7b96d0758d97e708ef6
Handled-By	: Andreas Schwab <schwab@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=122548923531545&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11911
Subject		: new PCMCIA device instance after resume - orinoco can't download firmware
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-10-28 19:19 (20 days old)
References	: http://marc.info/?l=linux-wireless&m=122522165719760&w=4
Handled-By	: Dave <kilroyd@googlemail.com>
Patch		: http://marc.info/?l=linux-wireless&m=122539058601588&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11903
Subject		: regression: vmalloc easily fail
Submitter	: Glauber Costa <glommer@redhat.com>
Date		: 2008-10-28 20:59 (20 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=db64fe02258f1507e13fe5212a989922323685ce
References	: http://marc.info/?l=linux-kernel&m=122522755530998&w=4
Handled-By	: Glauber Costa <glommer@redhat.com>
		  Nick Piggin <npiggin@suse.de>
		  Glauber Costa <glommer@redhat.com>
Patch		: http://marc.info/?l=linux-kernel&m=122609055221549&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11899
Subject		: sometime boot failed on T61 laptop
Submitter	: alexs <alex.shi@intel.com>
Date		: 2008-10-30 02:04 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=122663989015147&w=4
Handled-By	: Tejun Heo <tj@kernel.org>
		  Yanmin Zhang <yanmin_zhang@linux.intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18860&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11898
Subject		: mke2fs hang on AIC79 device.
Submitter	: alexs <alex.shi@intel.com>
Date		: 2008-10-30 01:17 (18 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f0c0a376d0fcd4c5579ecf5e95f88387cba85211
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
		  Mike Christie <michaelc@cs.wisc.edu>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11898#c28
		  http://bugzilla.kernel.org/show_bug.cgi?id=11898#c36


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11875
Subject		: radeonfb lockup in .28-rc (bisected)
Submitter	: James Cloos <cloos@jhcloos.com>
Date		: 2008-10-28 0:00 (20 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b1ee26bab14886350ba12a5c10cbc0696ac679bf
References	: http://marc.info/?l=linux-kernel&m=122515210200530&w=4
		  http://lkml.org/lkml/2008/11/10/12
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Patch		: http://lkml.org/lkml/2008/11/10/12


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11828
Subject		: Linux 2.6.27-git3: no SD card reader
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2008-10-14 0:54 (34 days old)
References	: http://marc.info/?l=linux-kernel&m=122394573904699&w=4
Handled-By	: Pierre Ossman <drzeus-list@drzeus.cx>
Patch		: http://marc.info/?l=linux-pci&m=122662042229570&w=2


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.27,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=11808

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

