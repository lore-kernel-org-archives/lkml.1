Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbZJKWK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbZJKWK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZJKWK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:10:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57735 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbZJKWKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:10:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.32-rc4: Reported regressions from 2.6.31
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
Message-ID: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
Date: Mon, 12 Oct 2009 00:07:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Note:
  We started to get more regression reports for 2.6.32-rc (100%+ jump in the
  last 10 days.  Nevertheless, we're still receiving new reports of regressions
  from 2.6.30.]

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
  2009-10-12       48       31          27
  2009-10-02       22       15           9


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14392
Subject		: Touchpad "paste" stops working after suspend to RAM
Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
Date		: 2009-10-11 16:21 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=125527987316493&w=4
Handled-By	: Dmitry Torokhov <dmitry.torokhov@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14390
Subject		: "bind" a device to a driver doesn't not work anymore
Submitter	: Éric Piel <Eric.Piel@tremplin-utc.net>
Date		: 2009-10-11 0:04 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=125521979921241&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14389
Subject		: Build system issue
Submitter	: Peter Zijlstra <peterz@infradead.org>
Date		: 2009-10-09 8:58 (3 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=575543347b5baed0ca927cb90ba8807396fe9cc9
References	: http://marc.info/?l=linux-kernel&m=125507914909152&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14387
Subject		: deadlock with fallocate
Submitter	: Thomas Neumann <tneumann@users.sourceforge.net>
Date		: 2009-10-07 3:00 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=125488495526471&w=4
Handled-By	: Christoph Hellwig <hch@lst.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14386
Subject		: GPF in snd_hda_intel
Submitter	: Luca Tettamanti <kronos.it@gmail.com>
Date		: 2009-10-10 13:01 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=125517999408019&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14384
Subject		: tbench regression with 2.6.32-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-10-09 9:51 (3 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59abf02644c45f1591e1374ee7bb45dc757fcb88
References	: http://marc.info/?l=linux-kernel&m=125508216713138&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14383
Subject		: hackbench regression with kernel 2.6.32-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-10-09 9:19 (3 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=29cd8bae396583a2ee9a3340db8c5102acf9f6fd
References	: http://marc.info/?l=linux-kernel&m=125508007510274&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14381
Subject		: iwlagn lost connection after s2ram (with warnings)
Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
Date		: 2009-10-07 14:20 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=125492569119947&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14380
Subject		: Video tearing/glitching with T400 laptops
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2009-10-02 22:40 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=125452324520623&w=4
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14379
Subject		: ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2009-10-08 21:46 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=125504031328941&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14378
Subject		: Problems with net/core/skbuff.c
Submitter	: Massimo Cetra <mcetra@navynet.it>
Date		: 2009-10-08 14:51 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=125501488220358&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14376
Subject		: Kernel NULL pointer dereference/ kvm subsystem
Submitter	: Don Dupuis <dondster@gmail.com>
Date		: 2009-10-06 14:38 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=125484025021737&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14374
Subject		: MCEs caused by commit db8be50c4307dac2b37305fc59c8dc0f978d09ea
Submitter	: Nick Piggin <npiggin@suse.de>
Date		: 2009-10-02 7:34 (10 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=db8be50c4307dac2b37305fc59c8dc0f978d09ea
References	: http://marc.info/?l=linux-kernel&m=125446885705223&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14373
Subject		: Task blocked for more than 120 seconds
Submitter	: Zeno Davatz <zdavatz@gmail.com>
Date		: 2009-10-02 10:16 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=125447858618412&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14372
Subject		: Wireless not working after suspend-resume
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2009-10-03 15:36 (9 days old)
References	: http://lkml.org/lkml/2009/10/3/91


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14370
Subject		: ext4 corruptions
Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
Date		: 2009-10-09 19:20 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=125511643504864&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14355
Subject		: USB serial regression after 2.6.31.1 with Huawei E169 GSM modem
Submitter	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date		: 2009-10-10 03:07 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=125513456327542&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14354
Subject		: Bad corruption with 2.6.32-rc1 and upwards
Submitter	: Holger Freyther <zecke@selfish.org>
Date		: 2009-10-09 15:42 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14353
Subject		: BUG: sleeping function called from invalid context at kernel/mutex.c:280
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-10-05 3:39 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=125471432208671&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14352
Subject		: WARNING: at net/mac80211/scan.c:267
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-10-08 00:30 (4 days old)
References	: http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089#c7


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14334
Subject		: pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Submitter	: Jose Marino <braket@hotmail.com>
Date		: 2009-10-06 15:44 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14299
Subject		: oops in wireless, iwl3945 related?
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-29 17:12 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=125424439725743&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14298
Subject		: warning at manage.c:361 (set_irq_wake), matrix-keypad related?
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-30 20:07 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=125434130703538&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14297
Subject		: console resume broken since ba15ab0e8d
Submitter	: Sascha Hauer <s.hauer@pengutronix.de>
Date		: 2009-09-30 15:11 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=125432349404060&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14296
Subject		: spitz boots but suspend/resume is broken
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-09-30 12:06 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=125431244516449&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14279
Subject		: Suspend to RAM freeze totally since 2.6.32-rc1 - Acer Aspire 1511Lmi laptop
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-09-30 18:14 (12 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5f68563996e812f9ca35b3939ad2a42e5d254d66


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14277
Subject		: Caught 8-bit read from freed memory in b43 driver at association
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-09-30 18:06 (12 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14382
Subject		: Transmit failure in et131x.
Submitter	: Nick Bowler <nbowler@elliptictech.com>
Date		: 2009-10-08 14:08 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=125501117713744&w=4
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
Patch		: http://patchwork.kernel.org/patch/52698/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14375
Subject		: Intel(R) I/OAT DMA Engine init failed
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-10-02 9:46 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=125447680016160&w=4
Handled-By	: Dan Williams <dan.j.williams@intel.com>
Patch		: http://patchwork.kernel.org/patch/51808/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14302
Subject		: Kernel panic on i386 machine when booting with profile=2
Submitter	: Shi, Alex <alex.shi@intel.com>
Date		: 2009-10-01 3:23 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=125436749607199&w=4
Handled-By	: Alex Shi <alex.shi@intel.com>
Patch		: http://patchwork.kernel.org/patch/50813/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14278
Subject		: New message "NOHZ: local_softirq_pending 08" at each ping request
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-09-30 18:12 (12 days old)
Handled-By	: Michael Buesch <mb@bu3sch.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23220


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

