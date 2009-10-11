Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZJKWon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZJKWon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZJKWom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:44:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58010 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbZJKWoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:44:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.32-rc4: Reported regressions 2.6.30 -> 2.6.31
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
Date: Mon, 12 Oct 2009 00:41:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Note:
  10 new reports in the last 10 days, but fortunately we're fixing them faster
  than they're being reported.]

This message contains a list of some regressions introduced between 2.6.30 and
2.6.31, for which there are no fixes in the mainline I know of.  If any of them
have been fixed already, please let me know.

If you know of any other unresolved regressions introduced between 2.6.30
and 2.6.31, please let me know either and I'll add them to the list.
Also, please let me know if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2009-10-12      161       45          35
  2009-10-02      151       49          42
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

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14391
Subject		: use after free of struct powernow_k8_data
Submitter	: Michal Schmidt <mschmidt@redhat.com>
Date		: 2009-09-24 14:51 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=125380383515615&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14388
Subject		: keyboard under X with 2.6.31
Submitter	: Frédéric L. W. Meunier <fredlwm@gmail.com>
Date		: 2009-10-07 20:19 (5 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
References	: http://marc.info/?l=linux-kernel&m=125494753228217&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14385
Subject		: DMAR regression in 2.6.31 leads to ext4 corruption?
Submitter	: Andy Isaacson <adi@hexapodia.org>
Date		: 2009-10-08 23:56 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=125504643703877&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14377
Subject		: "conservative" cpufreq governor broken
Submitter	: Steven Noonan <steven@uplinklabs.net>
Date		: 2009-10-05 16:32 (7 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f2e21c9610991e95621a81407cdbab881226419b
References	: http://marc.info/?l=linux-kernel&m=125476067108252&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14329
Subject		: Sata disk doesn't wake up after S3 suspend
Submitter	:  <frodone@gmail.com>
Date		: 2009-10-05 22:58 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14309
Subject		: MCA on hp rx8640
Submitter	: Andrew Patterson <andrew.patterson@hp.com>
Date		: 2009-09-29 17:20 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=db8be50c4307dac2b37305fc59c8dc0f978d09ea
References	: http://www.spinics.net/lists/linux-usb/msg22799.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14294
Subject		: kernel BUG at drivers/ide/ide-disk.c:187
Submitter	: Santiago Garcia Mantinan <manty@manty.net>
Date		: 2009-09-30 11:05 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=125430926311466&w=4
Handled-By	: David Miller <davem@davemloft.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14267
Subject		: Disassociating atheros wlan
Submitter	: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Date		: 2009-09-24 10:16 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=125378723723384&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14266
Subject		: regression in page writeback
Submitter	: Shaohua Li <shaohua.li@intel.com>
Date		: 2009-09-22 5:49 (20 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d7831a0bdf06b9f722b947bb0c205ff7d77cebd8
References	: http://marc.info/?l=linux-kernel&m=125359858117176&w=4
Handled-By	: Wu Fengguang <fengguang.wu@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14265
Subject		: ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
Submitter	: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Date		: 2009-09-15 12:05 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=125301636509517&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14264
Subject		: ehci problem - mouse dead on scroll
Submitter	: Volker Armin Hemmann <volkerarmin@googlemail.com>
Date		: 2009-09-12 7:46 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=125274202707893&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14257
Subject		: Not able to boot on 32 bit System
Submitter	: Rishikesh <risrajak@linux.vnet.ibm.com>
Date		: 2009-09-21 15:25 (21 days old)
References	: http://marc.info/?l=linux-kernel&m=125354604314412&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14256
Subject		: kernel BUG at fs/ext3/super.c:435
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-09-21 7:29 (21 days old)
References	: http://marc.info/?l=linux-kernel&m=125351816109264&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14252
Subject		: WARNING: at include/linux/skbuff.h:1382 w/ e1000
Submitter	: Stephan von Krawczynski <skraw@ithnet.com>
Date		: 2009-09-20 11:26 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=125344599006033&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14249
Subject		: BUG: oops in gss_validate on 2.6.31
Submitter	: Bastian Blank <bastian@waldi.eu.org>
Date		: 2009-09-16 10:29 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=125309700417283&w=4
Handled-By	: Trond Myklebust <trond.myklebust@fys.uio.no>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14248
Subject		: 2.6.31 wireless: WARNING: at net/wireless/ibss.c:34
Submitter	: Jurriaan <thunder8@xs4all.nl>
Date		: 2009-09-13 7:32 (29 days old)
References	: http://marc.info/?l=linux-kernel&m=125282721113553&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14204
Subject		: MCE prevent booting on my computer(pentium iii @500Mhz)
Submitter	: GNUtoo <GNUtoo@no-log.org>
Date		: 2009-09-21 20:36 (21 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14185
Subject		: Oops in driversbasefirmware_class
Submitter	:  <lars_ericsson@telia.com>
Date		: 2009-09-17 05:09 (25 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6e03a201bbe8137487f340d26aa662110e324b20


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14181
Subject		: b43 causes panic at ifconfig down / shutdown
Submitter	: Jeremy Huddleston <jeremyhu@freedesktop.org>
Date		: 2009-09-15 18:34 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14157
Subject		: end_request: I/O error, dev cciss/cXdX, sector 0
Submitter	:  <jiri.harcarik@gmail.com>
Date		: 2009-09-11 07:42 (31 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14143
Subject		: OOPS when setting nr_requests for md devices
Submitter	: aCaB <acab@clamav.net>
Date		: 2009-09-08 08:48 (34 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14141
Subject		: order 2 page allocation failures in iwlagn
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-09-06 7:40 (36 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ff05b2b4eac2e63d345fc731ea151a060247f53
References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
		  http://lkml.org/lkml/2009/10/2/86
		  http://lkml.org/lkml/2009/10/5/24
Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14114
Subject		: Tuning a saa7134 based card is broken in kernel 2.6.31-rc7
Submitter	: Tsvety Petrov <Tsvetoslav.Petrov@itron.com>
Date		: 2009-09-03 21:06 (39 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14090
Subject		: WARNING: at fs/notify/inotify/inotify_user.c:394
Submitter	: Joerg Platte <bugzilla@jako.ping.de>
Date		: 2009-08-30 15:21 (43 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14070
Subject		: lockdep warning triggered by dup_fd
Submitter	: Bart Van Assche <bart.vanassche@gmail.com>
Date		: 2009-08-23 09:36 (50 days old)
References	: http://lkml.org/lkml/2009/8/23/8


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14058
Subject		: Oops in fsnotify
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-08-20 15:48 (53 days old)
References	: http://marc.info/?l=linux-kernel&m=125078450923133&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14013
Subject		: hd don't show up
Submitter	: Tim Blechmann <tim@klingt.org>
Date		: 2009-08-14 8:26 (59 days old)
References	: http://marc.info/?l=linux-kernel&m=125023842514480&w=4
Handled-By	: Tejun Heo <tj@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13987
Subject		: Received NMI interrupt at resume
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-08-15 07:55 (58 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13943
Subject		: WARNING: at net/mac80211/mlme.c:2292 with ath5k
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2009-08-06 20:15 (67 days old)
References	: http://marc.info/?l=linux-kernel&m=124958978600600&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13941
Subject		: x86 Geode issue
Submitter	: Martin-Éric Racine <q-funk@iki.fi>
Date		: 2009-08-03 12:58 (70 days old)
References	: http://marc.info/?l=linux-kernel&m=124930434732481&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13906
Subject		: Huawei E169 GPRS connection causes Ooops
Submitter	: Clemens Eisserer <linuxhippy@gmail.com>
Date		: 2009-08-04 09:02 (69 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13836
Subject		: suspend script fails, related to stdout?
Submitter	: Tomas M. <tmezzadra@gmail.com>
Date		: 2009-07-17 21:24 (87 days old)
References	: http://marc.info/?l=linux-kernel&m=124785853811667&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13809
Subject		: oprofile: possible circular locking dependency detected
Submitter	: Jerome Marchand <jmarchan@redhat.com>
Date		: 2009-07-22 13:35 (82 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13733
Subject		: 2.6.31-rc2: irq 16: nobody cared
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-07-06 18:32 (98 days old)
References	: http://marc.info/?l=linux-kernel&m=124690524027166&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13645
Subject		: NULL pointer dereference at (null) (level2_spare_pgt)
Submitter	: poornima nayak <mpnayak@linux.vnet.ibm.com>
Date		: 2009-06-17 17:56 (117 days old)
References	: http://lkml.org/lkml/2009/6/17/194


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14301
Subject		: WARNING: at net/ipv4/af_inet.c:154
Submitter	: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Date		: 2009-09-30 12:24 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=125431350218137&w=4
Handled-By	: Eric Dumazet <eric.dumazet@gmail.com>
Patch		: http://patchwork.kernel.org/patch/52743/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14275
Subject		: kernel>=2.6.31: ahci.c: do not force unconditionally sb600 to 32bit dma any more?
Submitter	: gabriele balducci <balducci@units.it>
Date		: 2009-09-30 15:02 (12 days old)
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=14275#c0


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14261
Subject		: e1000e jumbo frames no longer work: 'Unsupported MTU setting'
Submitter	: Nix <nix@esperi.org.uk>
Date		: 2009-09-26 11:16 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=125396433321342&w=4
Handled-By	: Alexander Duyck <alexander.duyck@gmail.com>
Patch		: http://patchwork.kernel.org/patch/50277/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14258
Subject		: Memory leak in SCSI initialization
Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date		: 2009-09-22 4:18 (20 days old)
References	: http://marc.info/?l=linux-kernel&m=125359311312243&w=4
Handled-By	: Michael Ellerman <michael@ellerman.id.au>
		  James Bottomley <James.Bottomley@suse.de>
Patch		: http://patchwork.kernel.org/patch/51412/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14253
Subject		: Oops in driversbasefirmware_class
Submitter	: Lars Ericsson <Lars_Ericsson@telia.com>
Date		: 2009-09-16 20:44 (26 days old)
References	: http://lkml.org/lkml/2009/9/16/461
Handled-By	: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Patch		: http://patchwork.kernel.org/patch/49914/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14137
Subject		: usb console regressions
Submitter	: Jason Wessel <jason.wessel@windriver.com>
Date		: 2009-09-05 21:08 (37 days old)
References	: http://marc.info/?l=linux-kernel&m=125218501310512&w=4
Handled-By	: Jason Wessel <jason.wessel@windriver.com>
Patch		: http://patchwork.kernel.org/patch/45953/
		  http://patchwork.kernel.org/patch/45952/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14129
Subject		: 2.6.31 regression - pci_get_slot oops, udev boot hang - toshiba X200
Submitter	: chepioq <chepioq@gmail.com>
Date		: 2009-09-06 07:01 (36 days old)
Handled-By	: Alex Chiang <achiang@hp.com>
		  Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://patchwork.kernel.org/patch/51834/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14017
Subject		: _end symbol missing from Symbol.map
Submitter	: Hannes Reinecke <hare@suse.de>
Date		: 2009-08-13 6:45 (60 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=091e52c3551d3031343df24b573b770b4c6c72b6
References	: http://marc.info/?l=linux-kernel&m=125014649102253&w=4
Handled-By	: Hannes Reinecke <hare@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=125014649102253&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13948
Subject		: ath5k broken after suspend-to-ram
Submitter	: Johannes Stezenbach <js@sig21.net>
Date		: 2009-08-07 21:51 (66 days old)
References	: http://marc.info/?l=linux-kernel&m=124968192727854&w=4
Handled-By	: Nick Kossifidis <mickflemm@gmail.com>
Patch		: http://patchwork.kernel.org/patch/38550/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13940
Subject		: 2.6.31-rc1 - iwlagn and sky2 stopped working when ACPI enabled - Toshiba U400-17b, Acer Aspire 8935G
Submitter	: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
Date		: 2009-08-07 22:33 (66 days old)
References	: http://marc.info/?l=linux-kernel&m=124968457731107&w=4
Handled-By	: Len Brown <lenb@kernel.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23280


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.30 and 2.6.31, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=13615

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

