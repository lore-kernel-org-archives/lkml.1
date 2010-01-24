Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114Ab0AXWGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0AXWGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062Ab0AXWG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:06:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab0AXWG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:06:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.33-rc5: Reported regressions from 2.6.32
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
Message-ID: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
Date: Sun, 24 Jan 2010 22:54:30 +0100 (CET)
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
  2010-01-24       75       29          23
  2010-01-10       55       33          21
  2009-12-29       36       34          27


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15139
Subject		: e1000: transmit queue 0 timed out
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2010-01-23 15:37 (2 days old)
References	: http://marc.info/?l=linux-netdev&m=126426149306083&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15138
Subject		: evdev regression on macbook
Submitter	: Guillaume Chazarain <guichaz@gmail.com>
Date		: 2010-01-23 18:53 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=126427286219235&w=4
Handled-By	: Dmitry Torokhov <dmitry.torokhov@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15133
Subject		: Wake on LAN doesn't work in sky2
Submitter	: Tino Keitel <tino.keitel@tikei.de>
Date		: 2010-01-15 9:10 (10 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=166a0fd4c788ec7f10ca8194ec6d526afa12db75
References	: http://marc.info/?l=linux-kernel&m=126354704815848&w=4
Handled-By	: Stephen Hemminger <shemminger@vyatta.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15132
Subject		: OOPS's with large initramfs
Submitter	: Nigel Kukard <nkukard@lbsd.net>
Date		: 2010-01-16 11:12 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=126364100321603&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15129
Subject		: [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-01-14 23:18 (11 days old)
References	: http://lkml.org/lkml/2010/1/14/570
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15126
Subject		: REGRESSION for RT2561/RT61 in 2.6.33
Submitter	: Alan Stern <stern@rowland.harvard.edu>
Date		: 2010-01-11 14:54 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=126322167427159&w=4
Handled-By	: Johannes Berg <johannes@sipsolutions.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15125
Subject		: hung task - jbd2/dm-1-8 (during raid rebuild)
Submitter	: Michael Breuer <mbreuer@majjas.com>
Date		: 2010-01-10 21:47 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=126316012025978&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15124
Subject		: PCI host bridge windows ignored (works with pci=use_crs)
Submitter	: Jeff Garrett <jeff@jgarrett.org>
Date		: 2010-01-13 5:37 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=126336296600307&w=4
Handled-By	: Yinghai Lu <yinghai@kernel.org>
		  Bjorn Helgaas <bjorn.helgaas@hp.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15076
Subject		: System panic under load with clockevents_program_event
Submitter	: okias <d.okias@gmail.com>
Date		: 2010-01-17 13:03 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15043
Subject		: Display goes off with i915.powersave=1
Submitter	: Soeren Sonnenburg <sonne@debian.org>
Date		: 2010-01-10 20:09 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=126315457519505&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15038
Subject		: drm/ksm: fbdev blanking regression
Submitter	: Johan Hovold <jhovold@gmail.com>
Date		: 2010-01-06 17:00 (19 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=731b5a15a3b1474a41c2ca29b4c32b0f21bc852e
References	: http://marc.info/?l=linux-kernel&m=126279726418748&w=4
Handled-By	: James Simmons <jsimmons@infradead.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15036
Subject		: soft lockup in dmesg after suspend/resume
Submitter	: ykzhao <yakui.zhao@intel.com>
Date		: 2010-01-04 5:36 (21 days old)
References	: http://marc.info/?l=linux-kernel&m=126258356202722&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15032
Subject		: Oops in uart_resume_port() on resume
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2010-01-04 15:47 (21 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ba15ab0e8de0d4439a91342ad52d55ca9e313f3d
References	: http://marc.info/?l=linux-kernel&m=126262008815689&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15025
Subject		: Oops in ext4 driver
Submitter	: Steinar H. Gunderson <sgunderson@bigfoot.com>
Date		: 2010-01-10 13:09 (15 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15017
Subject		: kexec regression, radeon/kms irq related (bisected)
Submitter	: Markus Trippelsdorf <markus@trippelsdorf.de>
Date		: 2010-01-09 18:49 (16 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d8f60cfc93452d0554f6a701aa8e3236cbee4636


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15000
Subject		: Thinkpad dock button no longer works
Submitter	: Paul Martin <pm@debian.org>
Date		: 2010-01-07 02:11 (18 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14999
Subject		: possible circular locking dependency detected in rfkill at suspend
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-01-06 21:52 (19 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14950
Subject		: tbench regression with 2.6.33-rc1
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2009-12-25 11:11 (31 days old)
References	: http://marc.info/?l=linux-kernel&m=126174044213172&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14946
Subject		: All kernels after 2.6.32-git10  show only 1 CPU
Submitter	: Sid Boyce <sboyce@blueyonder.co.uk>
Date		: 2009-12-23 16:55 (33 days old)
References	: http://marc.info/?l=linux-kernel&m=126158734326801&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14937
Subject		: WARNING: at kernel/lockdep.c:2830
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-12-27 13:35 (29 days old)
References	: http://marc.info/?l=linux-kernel&m=126192220404829&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14924
Subject		: Weird hard hangs when rendering 'some' web-sites in Firefox
Submitter	: David <david@unsolicited.net>
Date		: 2009-12-21 21:53 (35 days old)
References	: http://marc.info/?l=linux-kernel&m=126143375823340&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14859
Subject		: System timer firing too much without cause
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2009-12-21 19:16 (35 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14792
Subject		: Misdetection of the TV output
Submitter	: Santi <santi@agolina.net>
Date		: 2009-12-12 13:28 (44 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15137
Subject		: NULL pointer dereference in vlan_skb_recv
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2010-01-23 15:56 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=126426286507497&w=4
Handled-By	: Eric Dumazet <eric.dumazet@gmail.com>
Patch		: http://patchwork.kernel.org/patch/74999/
		  http://patchwork.kernel.org/patch/75002/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15131
Subject		: [OOPS] radeon kms
Submitter	: John Kacur <jkacur@redhat.com>
Date		: 2010-01-15 15:45 (10 days old)
References	: http://lkml.org/lkml/2010/1/15/129
Handled-By	: Jerome Glisse <glisse@freedesktop.org>
Patch		: http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=patch;h=30d2d9a54d48e4fefede0389ded1b6fc2d44a522


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15128
Subject		: Boot regression on AMD
Submitter	: Gene Heskett <gene.heskett@verizon.net>
Date		: 2010-01-13 20:21 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=126341413213017&w=4
Handled-By	: Andreas Herrmann <andreas.herrmann3@amd.com>
Patch		: http://patchwork.kernel.org/patch/74883/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15039
Subject		: leds_alix2: can't allocate I/O for GPIO
Submitter	: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Date		: 2010-01-07 10:26 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=126286001106257&w=4
Handled-By	: Daniel Mack <daniel@caiaq.de>
Patch		: http://patchwork.kernel.org/patch/72006/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14949
Subject		: drm_vm.c:drm_mmap: possible circular locking dependency detected
Submitter	: Borislav Petkov <petkovbb@googlemail.com>
Date		: 2009-12-26 9:45 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=126182073616279&w=4
Handled-By	: Eric W. Biederman <ebiederm@aristanetworks.com>
Patch		: http://patchwork.kernel.org/patch/70461/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14791
Subject		: Something has been broken in the network stack this week
Submitter	: Delete This Account <speedyboyinovator@hotmail.com>
Date		: 2009-12-12 13:06 (44 days old)
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

