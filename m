Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbZGFXt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbZGFXt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZGFXtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:49:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57788 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbZGFXtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:49:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.31-rc2: Reported regressions from 2.6.30
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
Message-ID: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
Date: Tue,  7 Jul 2009 01:42:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NOTE: I'll be traveling next week, so there won't be a summary report.]

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
  2009-07-07       35       25          21
  2009-06-29       22       22          15


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13733
Subject		: 2.6.31-rc2: irq 16: nobody cared
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-07-06 18:32 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=124690524027166&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13732
Subject		: tty layer instabilities
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-07-06 13:43 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=124688781732419&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13731
Subject		: Inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-07-06 4:22 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=124685417325348&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13730
Subject		: hitting lockdep limits...
Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
Date		: 2009-07-05 18:19 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=124681799023782&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13729
Subject		: kernel BUG at fs/notify/notification.c:93!
Submitter	: Mikko C. <mikko.cal@gmail.com>
Date		: 2009-06-04 10:16 (33 days old)
References	: http://lkml.org/lkml/2009/7/4/12
Handled-By	: Eric Paris <eparis@redhat.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13728
Subject		: 2.6.31-rc2 soft lockups, RPC-related
Submitter	: Paul Collins <paul@burly.ondioline.org>
Date		: 2009-07-05 7:17 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=124677884816794&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13727
Subject		: Cannot Recognize Empty DVD Media
Submitter	: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Date		: 2009-07-02 16:23 (5 days old)
References	: http://lkml.org/lkml/2009/7/2/178


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13726
Subject		: fio sync read 4k block size 35% regression
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-07-01 11:25 (6 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=51daa88ebd8e0d437289f589af29d4b39379ea76
References	: http://lkml.org/lkml/2009/6/30/679
Handled-By	: Wu Fengguang <fengguang.wu@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13716
Subject		: The AIC-7892P controller does not work any more
Submitter	: Andrej Podzimek <andrej@podzimek.org>
Date		: 2009-07-05 19:23 (2 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13700
Subject		: usb error flood in dmesg, makes kde use plenty of cpu - bisected
Submitter	: jouni susiluoto <jouni.susiluoto@helsinki.fi>
Date		: 2009-07-03 21:13 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13690
Subject		: nodes_clear cause hugepage unusable on non-NUMA machine
Submitter	: alexs <alex.shi@intel.com>
Date		: 2009-07-02 01:22 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13673
Subject		: HIGHMEM64G causes hang in PCI init on 32-bit x86
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-06-26 15:59 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=95ee14e4379c5e19c0897c872350570402014742
References	: http://marc.info/?l=linux-pci&m=124615181602643&w=4
Handled-By	: H. Peter Anvin <hpa@zytor.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13667
Subject		: drm: display arifacts when X.Org is stopped
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-06-27 18:52 (10 days old)
References	: http://lkml.org/lkml/2009/6/27/105


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13666
Subject		: WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2009-06-27 16:15 (10 days old)
References	: http://lkml.org/lkml/2009/6/27/75


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13661
Subject		: warning in smp_call_function_single while S2R
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2009-06-27 17:12 (10 days old)
References	: http://lkml.org/lkml/2009/6/27/80


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13657
Subject		: Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
Submitter	: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Date		: 2009-06-26 10:03 (11 days old)
References	: http://lkml.org/lkml/2009/6/26/34


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13656
Subject		: 2.6.31-rc1 crashes randomly on my Machine.
Submitter	: Zeno Davatz <zdavatz@gmail.com>
Date		: 2009-06-26 08:56 (11 days old)
References	: http://lkml.org/lkml/2009/6/26/27


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13652
Subject		: scheduling while atomic: pptpgw
Submitter	: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Date		: 2009-06-19 21:15 (18 days old)
References	: http://lkml.org/lkml/2009/6/19/237


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13650
Subject		: Problem with alloc_arch_preferred_bootmem() on powerpc
Submitter	: Sean MacLennan <smaclennan@pikatech.com>
Date		: 2009-06-20 19:48 (17 days old)
References	: http://marc.info/?l=linuxppc-embedded&m=124552732411775&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13645
Subject		: NULL pointer dereference at (null) (level2_spare_pgt)
Submitter	: poornima nayak <mpnayak@linux.vnet.ibm.com>
Date		: 2009-06-17 17:56 (20 days old)
References	: http://lkml.org/lkml/2009/6/17/194


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13522
Subject		: BUG: scheduling while atomic
Submitter	: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Date		: 2009-06-12 19:29 (25 days old)
References	: http://lkml.org/lkml/2009/6/29/237


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13734
Subject		: regression in 2.6.31-rcX since commit a1091aa
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2009-07-06 19:07 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=124690725130645&w=4
Handled-By	: David Miller <davem@davemloft.net>
Patch		: http://patchwork.kernel.org/patch/34292/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13665
Subject		: commit 69c854817566 causes OOMs
Submitter	: David Howells <dhowells@redhat.com>
Date		: 2009-06-27 08:12 (10 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69c854817566db82c362797b4a6521d0b00fe1d8
References	: http://lkml.org/lkml/2009/6/27/28
Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
Patch		: http://patchwork.kernel.org/patch/32740/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13659
Subject		: iwlagn (4965): no wireless due to RFKILL problem
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-06-26 13:36 (11 days old)
References	: http://lkml.org/lkml/2009/6/26/127
Handled-By	: Johannes Berg <johannes@sipsolutions.net>
Patch		: http://lkml.org/lkml/2009/6/27/35


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13643
Subject		: Touchpad lost synchronization after resume from suspend to RAM
Submitter	: Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
Date		: 2009-06-28 10:42 (9 days old)
References	: http://lkml.org/lkml/2009/6/23/365
		  2.6.30-rc1: touchpad disabled
		  http://lkml.org/lkml/2009/6/25/256
Handled-By	: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Patch		: http://patchwork.kernel.org/patch/34075/


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

