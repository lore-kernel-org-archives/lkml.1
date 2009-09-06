Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbZIFURw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbZIFURw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 16:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758009AbZIFURu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 16:17:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbZIFURr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 16:17:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.31-rc9: Reported regressions from 2.6.30
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
Message-ID: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
Date: Sun,  6 Sep 2009 19:15:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.30, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.30, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2009-09-06      123       34          27
  2009-08-26      108       33          26
  2009-08-20      102       32          29
  2009-08-10       89       27          24
  2009-08-02       76       36          28
  2009-07-27       70       51          43
  2009-07-07       35       25          21
  2009-06-29       22       22          15


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14141
Subject		: order 2 page allocation failures
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-09-06 7:40 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14139
Subject		: Output to external monitor is broken
Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
Date		: 2009-09-06 14:22 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f8aed700c6ec46ddade6570004ce25332283b306
References	: http://marc.info/?l=linux-kernel&m=125224701520738&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14135
Subject		: NULL pointer dereference in ima_counts_put
Submitter	: Ciprian Docan <docan@eden.rutgers.edu>
Date		: 2009-09-02 13:49 (5 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=94e5d714f604d4cb4cb13163f01ede278e69258b
References	: http://marc.info/?l=linux-kernel&m=125190146028116&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14133
Subject		: WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule
Submitter	: Jens Axboe <jens.axboe@oracle.com>
Date		: 2009-08-31 20:43 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=125175143918050&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14114
Subject		: Tuning a saa7134 based card is broken in kernel 2.6.31-rc7
Submitter	: Tsvety Petrov <Tsvetoslav.Petrov@itron.com>
Date		: 2009-09-03 21:06 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14103
Subject		: cdc_acm gives I/O error
Submitter	: Paul Martin <pm@debian.org>
Date		: 2009-09-01 13:30 (6 days old)
Handled-By	: Oliver Neukum <oliver@neukum.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14095
Subject		: Asus EeePC 1005HA-M: Suspend hangs and disables the wireless
Submitter	:  Karsten Jaeger <lists@oss42.com>
Date		: 2009-08-31 10:14 (7 days old)
References	: http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-August/002513.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14070
Subject		: lockdep warning triggered by dup_fd
Submitter	: Bart Van Assche <bart.vanassche@gmail.com>
Date		: 2009-08-23 09:36 (15 days old)
References	: http://lkml.org/lkml/2009/8/23/8


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14058
Subject		: Oops in fsnotify
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-08-20 15:48 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=125078450923133&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14043
Subject		: System sometimes hangs during boot
Submitter	: Bart Van Assche <bart.vanassche@gmail.com>
Date		: 2009-08-23 18:04 (15 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14018
Subject		: kernel freezes, inotify problem
Submitter	: Christoph Thielecke <christoph.thielecke@gmx.de>
Date		: 2009-08-19 12:48 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=125068616818353&w=4
Handled-By	: Eric Paris <eparis@parisplace.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14013
Subject		: hd don't show up
Submitter	: Tim Blechmann <tim@klingt.org>
Date		: 2009-08-14 8:26 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=125023842514480&w=4
Handled-By	: Tejun Heo <tj@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13987
Subject		: Received NMI interrupt at resume
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-08-15 07:55 (23 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13950
Subject		: Oops when USB Serial disconnected while in use
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2009-08-08 17:47 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=124975432900466&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13943
Subject		: WARNING: at net/mac80211/mlme.c:2292 with ath5k
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2009-08-06 20:15 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=124958978600600&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13942
Subject		: Troubles with AoE and uninitialized object
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2009-08-04 10:12 (34 days old)
References	: http://marc.info/?l=linux-kernel&m=124938117104811&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13941
Subject		: x86 Geode issue
Submitter	: Martin-Éric Racine <q-funk@iki.fi>
Date		: 2009-08-03 12:58 (35 days old)
References	: http://marc.info/?l=linux-kernel&m=124930434732481&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13940
Subject		: iwlagn and sky2 stopped working, ACPI-related
Submitter	: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
Date		: 2009-08-07 22:33 (31 days old)
References	: http://marc.info/?l=linux-kernel&m=124968457731107&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13935
Subject		: 2.6.31-rcX breaks Apple MightyMouse (Bluetooth version)
Submitter	: Adrian Ulrich <kernel@blinkenlights.ch>
Date		: 2009-08-08 22:08 (30 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fa047e4f6fa63a6e9d0ae4d7749538830d14a343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13906
Subject		: Huawei E169 GPRS connection causes Ooops
Submitter	: Clemens Eisserer <linuxhippy@gmail.com>
Date		: 2009-08-04 09:02 (34 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13869
Subject		: Radeon framebuffer (w/o KMS) corruption at boot.
Submitter	: Duncan <1i5t5.duncan@cox.net>
Date		: 2009-07-29 16:44 (40 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13836
Subject		: suspend script fails, related to stdout?
Submitter	: Tomas M. <tmezzadra@gmail.com>
Date		: 2009-07-17 21:24 (52 days old)
References	: http://marc.info/?l=linux-kernel&m=124785853811667&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13819
Subject		: system freeze when switching to console
Submitter	: Reinette Chatre <reinette.chatre@intel.com>
Date		: 2009-07-23 17:57 (46 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13809
Subject		: oprofile: possible circular locking dependency detected
Submitter	: Jerome Marchand <jmarchan@redhat.com>
Date		: 2009-07-22 13:35 (47 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13740
Subject		: X server crashes with 2.6.31-rc2 when options are changed
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2009-07-07 15:19 (62 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13733
Subject		: 2.6.31-rc2: irq 16: nobody cared
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-07-06 18:32 (63 days old)
References	: http://marc.info/?l=linux-kernel&m=124690524027166&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13645
Subject		: NULL pointer dereference at (null) (level2_spare_pgt)
Submitter	: poornima nayak <mpnayak@linux.vnet.ibm.com>
Date		: 2009-06-17 17:56 (82 days old)
References	: http://lkml.org/lkml/2009/6/17/194


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14140
Subject		: 2.6.31-rc9 breaks gianfar
Submitter	: Michael Guntsche <mike@it-loops.com>
Date		: 2009-09-06 7:27 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=38bddf04bcfe661fbdab94888c3b72c32f6873b3
References	: http://marc.info/?l=linux-kernel&m=125222206218784&w=4
Handled-By	: David Miller <davem@davemloft.net>
Patch		: http://patchwork.kernel.org/patch/45965/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14138
Subject		: Regression in suspend to ram
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2009-08-31 11:51 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=125171952817851&w=4
Handled-By	: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Patch		: http://patchwork.kernel.org/patch/45945/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14137
Subject		: usb console regressions
Submitter	: Jason Wessel <jason.wessel@windriver.com>
Date		: 2009-09-05 21:08 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=125218501310512&w=4
Handled-By	: Jason Wessel <jason.wessel@windriver.com>
Patch		: http://patchwork.kernel.org/patch/45953/
		  http://patchwork.kernel.org/patch/45952/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14136
Subject		: readcd Oops
Submitter	: Bob Tracy <rct@gherkin.frus.com>
Date		: 2009-09-03 3:39 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=125195043617418&w=4
Handled-By	: Michal Schmidt <mschmidt@redhat.com>
Patch		: http://patchwork.kernel.org/patch/45347/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14017
Subject		: _end symbol missing from Symbol.map
Submitter	: Hannes Reinecke <hare@suse.de>
Date		: 2009-08-13 6:45 (25 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=091e52c3551d3031343df24b573b770b4c6c72b6
References	: http://marc.info/?l=linux-kernel&m=125014649102253&w=4
Handled-By	: Hannes Reinecke <hare@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=125014649102253&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13948
Subject		: ath5k broken after suspend-to-ram
Submitter	: Johannes Stezenbach <js@sig21.net>
Date		: 2009-08-07 21:51 (31 days old)
References	: http://marc.info/?l=linux-kernel&m=124968192727854&w=4
Handled-By	: Nick Kossifidis <mickflemm@gmail.com>
Patch		: http://patchwork.kernel.org/patch/38550/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13947
Subject		: Libertas: Association request to the driver failed
Submitter	: Daniel Mack <daniel@caiaq.de>
Date		: 2009-08-07 19:11 (31 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57921c312e8cef72ba35a4cfe870b376da0b1b87
References	: http://marc.info/?l=linux-kernel&m=124967234311481&w=4
Handled-By	: Roel Kluin <roel.kluin@gmail.com>
		  Dan Williams <dcbw@redhat.com>
Patch		: http://patchwork.kernel.org/patch/43114/


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.30,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=13615

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

