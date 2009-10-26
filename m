Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbZJZTd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbZJZTd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZJZTd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:33:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59723 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbZJZTd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:33:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.32-rc5-git3: Reported regressions 2.6.30 -> 2.6.31
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
Message-ID: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
Date: Mon, 26 Oct 2009 20:26:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
  2009-10-26      170       37          32
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

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14476
Subject		: Unable to handle kernel paging request in nfs_write_mapping
Submitter	: Stephan von Krawczynski <skraw@ithnet.com>
Date		: 2009-10-14 9:53 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=125551421405656&w=4
Handled-By	: Trond Myklebust <Trond.Myklebust@netapp.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14474
Subject		: restorecond going crazy on 2.6.31.4 - inotify regression?
Submitter	: Robert Hancock <hancockrwd@gmail.com>
Date		: 2009-10-16 0:03 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=125565159520489&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14446
Subject		: battery status info broken/useless in 2.6.32-rc3 - MSI PR200 (possibly others, too)
Submitter	: Eddy Petrișor <eddy.petrisor+linbug@gmail.com>
Date		: 2009-10-20 08:25 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14417
Subject		: [Regression] Wireless driver iwlagn+iwlcore doesn't work after resume (needs reloading)
Submitter	: Eddy Petrișor <eddy.petrisor+linbug@gmail.com>
Date		: 2009-10-16 11:07 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14402
Subject		: Atheros ath9k module is not working with 2.6.31.1 on an Acer Extensa 7630EZ
Submitter	: Bernhard <berndl81@gmx.at>
Date		: 2009-10-14 11:17 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14400
Subject		: disable/enable wlan broken with ath5k
Submitter	: Daniel Bumke <danielbumke@gmail.com>
Date		: 2009-10-13 12:35 (14 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14391
Subject		: use after free of struct powernow_k8_data
Submitter	: Michal Schmidt <mschmidt@redhat.com>
Date		: 2009-09-24 14:51 (33 days old)
References	: http://marc.info/?l=linux-kernel&m=125380383515615&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14388
Subject		: keyboard under X with 2.6.31
Submitter	: Frédéric L. W. Meunier <fredlwm@gmail.com>
Date		: 2009-10-07 20:19 (20 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
References	: http://marc.info/?l=linux-kernel&m=125494753228217&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14385
Subject		: DMAR regression in 2.6.31 leads to ext4 corruption?
Submitter	: Andy Isaacson <adi@hexapodia.org>
Date		: 2009-10-08 23:56 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=125504643703877&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14294
Subject		: kernel BUG at drivers/ide/ide-disk.c:187
Submitter	: Santiago Garcia Mantinan <manty@manty.net>
Date		: 2009-09-30 11:05 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=125430926311466&w=4
Handled-By	: David Miller <davem@davemloft.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14267
Subject		: Disassociating atheros wlan
Submitter	: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Date		: 2009-09-24 10:16 (33 days old)
References	: http://marc.info/?l=linux-kernel&m=125378723723384&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14265
Subject		: ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
Submitter	: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Date		: 2009-09-15 12:05 (42 days old)
References	: http://marc.info/?l=linux-kernel&m=125301636509517&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14257
Subject		: Not able to boot on 32 bit System
Submitter	: Rishikesh <risrajak@linux.vnet.ibm.com>
Date		: 2009-09-21 15:25 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=125354604314412&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14256
Subject		: kernel BUG at fs/ext3/super.c:435
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-09-21 7:29 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=125351816109264&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14252
Subject		: WARNING: at include/linux/skbuff.h:1382 w/ e1000
Submitter	: Stephan von Krawczynski <skraw@ithnet.com>
Date		: 2009-09-20 11:26 (37 days old)
References	: http://marc.info/?l=linux-kernel&m=125344599006033&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14249
Subject		: BUG: oops in gss_validate on 2.6.31
Submitter	: Bastian Blank <bastian@waldi.eu.org>
Date		: 2009-09-16 10:29 (41 days old)
References	: http://marc.info/?l=linux-kernel&m=125309700417283&w=4
Handled-By	: Trond Myklebust <trond.myklebust@fys.uio.no>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14248
Subject		: 2.6.31 wireless: WARNING: at net/wireless/ibss.c:34
Submitter	: Jurriaan <thunder8@xs4all.nl>
Date		: 2009-09-13 7:32 (44 days old)
References	: http://marc.info/?l=linux-kernel&m=125282721113553&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14204
Subject		: MCE prevent booting on my computer(pentium iii @500Mhz)
Submitter	: GNUtoo <GNUtoo@no-log.org>
Date		: 2009-09-21 20:36 (36 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14181
Subject		: b43 causes panic at ifconfig down / shutdown
Submitter	: Jeremy Huddleston <jeremyhu@freedesktop.org>
Date		: 2009-09-15 18:34 (42 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14157
Subject		: end_request: I/O error, dev cciss/cXdX, sector 0
Submitter	:  <jiri.harcarik@gmail.com>
Date		: 2009-09-11 07:42 (46 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14141
Subject		: order 2 page allocation failures in iwlagn
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-09-06 7:40 (51 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ff05b2b4eac2e63d345fc731ea151a060247f53
References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
		  http://lkml.org/lkml/2009/10/2/86
		  http://lkml.org/lkml/2009/10/5/24
		  http://lkml.indiana.edu/hypermail/linux/kernel/0910.1/01395.html
Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14114
Subject		: Tuning a saa7134 based card is broken in kernel 2.6.31-rc7
Submitter	: Tsvety Petrov <Tsvetoslav.Petrov@itron.com>
Date		: 2009-09-03 21:06 (54 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14090
Subject		: WARNING: at fs/notify/inotify/inotify_user.c:394
Submitter	: Joerg Platte <bugzilla@jako.ping.de>
Date		: 2009-08-30 15:21 (58 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14058
Subject		: Oops in fsnotify
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-08-20 15:48 (68 days old)
References	: http://marc.info/?l=linux-kernel&m=125078450923133&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13987
Subject		: Received NMI interrupt at resume
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-08-15 07:55 (73 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f41f3f373dd72344c65d801d6381fe83ef3a2c54


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13943
Subject		: WARNING: at net/mac80211/mlme.c:2292 with ath5k
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2009-08-06 20:15 (82 days old)
References	: http://marc.info/?l=linux-kernel&m=124958978600600&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13941
Subject		: x86 Geode issue
Submitter	: Martin-Éric Racine <q-funk@iki.fi>
Date		: 2009-08-03 12:58 (85 days old)
References	: http://marc.info/?l=linux-kernel&m=124930434732481&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13906
Subject		: Huawei E169 GPRS connection causes Ooops
Submitter	: Clemens Eisserer <linuxhippy@gmail.com>
Date		: 2009-08-04 09:02 (84 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13836
Subject		: suspend script fails, related to stdout?
Submitter	: Tomas M. <tmezzadra@gmail.com>
Date		: 2009-07-17 21:24 (102 days old)
References	: http://marc.info/?l=linux-kernel&m=124785853811667&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13809
Subject		: oprofile: possible circular locking dependency detected
Submitter	: Jerome Marchand <jmarchan@redhat.com>
Date		: 2009-07-22 13:35 (97 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13733
Subject		: 2.6.31-rc2: irq 16: nobody cared
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-07-06 18:32 (113 days old)
References	: http://marc.info/?l=linux-kernel&m=124690524027166&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13645
Subject		: NULL pointer dereference at (null) (level2_spare_pgt)
Submitter	: poornima nayak <mpnayak@linux.vnet.ibm.com>
Date		: 2009-06-17 17:56 (132 days old)
References	: http://lkml.org/lkml/2009/6/17/194


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14340
Subject		: speedstep-ich driver not working in 2.6.31
Submitter	:  <dave.mueller@gmx.ch>
Date		: 2009-10-07 08:16 (20 days old)
Handled-By	: Eric Pielbug <e.a.b.piel@tudelft.nl>
		  Rusty Russell <rusty@rustcorp.com.au>
Patch		: http://patchwork.kernel.org/patch/54672/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14258
Subject		: Memory leak in SCSI initialization
Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date		: 2009-09-22 4:18 (35 days old)
References	: http://marc.info/?l=linux-kernel&m=125359311312243&w=4
Handled-By	: Michael Ellerman <michael@ellerman.id.au>
		  James Bottomley <James.Bottomley@suse.de>
Patch		: http://patchwork.kernel.org/patch/51412/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14253
Subject		: Oops in driversbasefirmware_class
Submitter	: Lars Ericsson <Lars_Ericsson@telia.com>
Date		: 2009-09-16 20:44 (41 days old)
References	: http://lkml.org/lkml/2009/9/16/461
Handled-By	: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Patch		: http://patchwork.kernel.org/patch/49914/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14137
Subject		: usb console regressions
Submitter	: Jason Wessel <jason.wessel@windriver.com>
Date		: 2009-09-05 21:08 (52 days old)
References	: http://marc.info/?l=linux-kernel&m=125218501310512&w=4
Handled-By	: Jason Wessel <jason.wessel@windriver.com>
Patch		: http://patchwork.kernel.org/patch/45953/
		  http://patchwork.kernel.org/patch/45952/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14017
Subject		: _end symbol missing from Symbol.map
Submitter	: Hannes Reinecke <hare@suse.de>
Date		: 2009-08-13 6:45 (75 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=091e52c3551d3031343df24b573b770b4c6c72b6
References	: http://marc.info/?l=linux-kernel&m=125014649102253&w=4
Handled-By	: Hannes Reinecke <hare@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=125014649102253&w=4


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

