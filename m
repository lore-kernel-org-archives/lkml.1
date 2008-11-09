Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYKITts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYKITts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYKITtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:49:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44301 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbYKITta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:49:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc3-git6: Reported regressions from 2.6.27
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
Message-ID: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
Date: Sun,  9 Nov 2008 18:53:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
  2008-11-09       73       40          27
  2008-11-02       55       41          29
  2008-10-25       26       25          20


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11996
Subject		: Tracing framework regression in 2.6.28-rc3
Submitter	: Pekka Paalanen <pq@iki.fi>
Date		: 2008-11-09 10:13 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=122624392229317&w=4
Handled-By	: Steven Rostedt <rostedt@goodmis.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11994
Subject		: Computer doesn't power down after commit CPI: EC: do transaction from interrupt context
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-11-09 02:02 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5ceb40417bca2045350e77f740e0c4c94875fff2
Handled-By	: ykzhao <yakui.zhao@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11989
Subject		: Suspend failure on NForce4-based boards due to chanes in stop_machine
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-11-03 0:28 (7 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c9583e55fa2b08a230c549bd1e3c0bde6c50d9cc
References	: http://marc.info/?l=linux-kernel&m=122567187604356&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11987
Subject		: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2008-11-04 17:33 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122582006601658&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11986
Subject		: 2.6.28-rc2-git1: spitz still won't boot
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-11-05 14:23 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=122589528016337&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11984
Subject		: regression when switching TTY-&gt;X, input related?
Submitter	: Bernhard Schmidt <berni@birkenwald.de>
Date		: 2008-11-05 22:04 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=122592278403853&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11970
Subject		: gettimeofday return a old time in mmbench
Submitter	: alexs <alex.shi@intel.com>
Date		: 2008-11-06 23:57 (4 days old)
Handled-By	: Ingo Molnar <mingo@elte.hu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11965
Subject		: regression introduced by - timers: fix itimer/many thread hang
Submitter	: Doug Chapman <doug.chapman@hp.com>
Date		: 2008-11-06 11:03 (4 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f06febc96ba8e0af80bcc3eaec0a109e88275fac
References	: http://marc.info/?l=linux-kernel&m=122596943416648&w=4
Handled-By	: Frank Mayhar <fmayhar@google.com>
		  Peter Zijlstra <peterz@infradead.org>
		  Ingo Molnar <mingo@elte.hu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11958
Subject		: [2.6.27.x =&gt; 2.6.28-rc3] Xorg crash with xf86MapVidMem error
Submitter	: Tomasz Chmielewski <tch@wpkg.org>
Date		: 2008-11-05 05:37 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11947
Subject		: 2.6.28-rc VC switching with Intel graphics broken
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-11-03 12:10 (7 days old)
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11928
Subject		: ath5k gets lost with eeepc-laptop removal
Submitter	: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Date		: 2008-10-31 13:05 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=122545827204957&w=4
Handled-By	: Nick Kossifidis <mickflemm@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11913
Subject		: USB/INPUT: slab error in cache_alloc_debugcheck_after(): double free?
Submitter	: Helge Deller <deller@gmx.de>
Date		: 2008-10-30 23:11 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cb8f488c33539f096580e202f5438a809195008f
References	: http://marc.info/?l=linux-kernel&m=122540833301394&w=4
Handled-By	: Jiri Kosina <jkosina@suse.cz>
		  Jiri Slaby <jirislaby@gmail.com>
		  Jiri Kosina <jkosina@suse.cz>
		  Jiri Slaby <jirislaby@gmail.com>
		  Denys Vlasenko <vda.linux@googlemail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11908
Subject		: linux-2.6.28-rc2 regression : oprofile doesnt work anymore
Submitter	: Eric Dumazet <dada1@cosmosbay.com>
Date		: 2008-10-30 18:01 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c493756e2a8a78bcaae30668317890dcfe86e7c3
References	: http://marc.info/?l=linux-kernel&m=122539004100532&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11906
Subject		: 2.6.28-rc2 seems to fail at powering down the monitor when it should
Submitter	: Gene Heskett <gene.heskett@gmail.com>
Date		: 2008-10-30 6:39 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=122534879721424&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11905
Subject		: lots of extra timer interrupts costing 2W
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2008-10-30 2:18 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fb02fbc14d17837b4b7b02dbb36142c16a7bf208
References	: http://marc.info/?l=linux-kernel&m=122533314305315&w=4
		  http://marc.info/?l=linux-kernel&m=122541849114444&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11899
Subject		: sometime boot failed on T61 laptop
Submitter	: alexs <alex.shi@intel.com>
Date		: 2008-10-30 02:04 (11 days old)
Handled-By	: Tejun Heo <tj@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11896
Subject		: [2.6.28-rc2] EeePC ACPI errors &amp; exceptions
Submitter	: Darren Salt <linux@youmustbejoking.demon.co.uk>
Date		: 2008-10-27 22:52 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=122514911328761&w=4
Handled-By	: Alexey Starikovskiy <aystarik@gmail.com>
		  Zhao Yakui <yakui.zhao@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11891
Subject		: resume from disk broken on hp/compaq nx7000 (DRM problem)
Submitter	: Markus Meier <maekke@gentoo.org>
Date		: 2008-10-29 14:42 (12 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0a3e67a4caac273a3bfc4ced3da364830b1ab241
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11875
Subject		: radeonfb lockup in .28-rc (bisected)
Submitter	: James Cloos <cloos@jhcloos.com>
Date		: 2008-10-28 0:00 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b1ee26bab14886350ba12a5c10cbc0696ac679bf
References	: http://marc.info/?l=linux-kernel&m=122515210200530&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11873
Subject		: unable to mount ext3 root filesystem due to htree_dirblock_to_tree
Submitter	: Jimmy.Jazz@gmx.net
Date		: 2008-10-28 05:09 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4c46501d1659475dc6c89554af6ce7fe6ecf615c
Handled-By	: Tejun Heo <tj@kernel.org>
		  Neil Brown <neilb@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11858
Subject		: Timeout regression introduced by 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Submitter	: Tejun Heo <tj@kernel.org>
Date		: 2008-10-26 9:46 (15 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=242f9dcb8ba6f68fcd217a119a7648a4f69290e9
References	: http://marc.info/?l=linux-kernel&m=122501447326698&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11849
Subject		: default IRQ affinity change in v2.6.27 (breaking several SMP PPC based systems)
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2008-10-24 12:45 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=122485245924125&w=4
Handled-By	: Chris Snook <csnook@redhat.com>
		  Scott Wood <scottwood@freescale.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11834
Subject		: iwl3945: if I leave my machine running overnight, wifi will not work in the morning
Submitter	: Pavel Machek <pavel@suse.cz>
Date		: 2008-10-19 21:40 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=122445440206101&w=4
Handled-By	: reinette chatre <reinette.chatre@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11828
Subject		: Linux 2.6.27-git3: no SD card reader
Submitter	: J.A. Magallón <jamagallon@ono.com>
Date		: 2008-10-14 0:54 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=122394573904699&w=4
Handled-By	: Pierre Ossman <drzeus-list@drzeus.cx>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11826
Subject		: extreme slowness of IO stuff using 2.6.28-rc1
Submitter	: Yves-Alexis Perez <corsac@debian.org>
Date		: 2008-10-25 04:25 (16 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dc4304f7deee29fcdf6a2b62f7146ea7f505fd42
References	: http://marc.info/?l=linux-kernel&m=122521238402963&w=4
Handled-By	: Arjan van de Ven <arjan@linux.intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11822
Subject		: ACPI Warning (nspredef-0858): _SB_.PCI0.LPC_.EC__.BAT0._BIF: Return Package type mismatch at index 9 - found Buffer, expected String [20080926]
Submitter	: Len Brown <len.brown@intel.com>
Date		: 2008-10-25 01:26 (16 days old)
Handled-By	: Robert Moore <Robert.Moore@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11799
Subject		: xorg can not start up with stolen memory
Submitter	: arrow zhang <arrow.ebd@gmail.com>
Date		: 2008-10-21 06:08 (20 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11988
Subject		: Eliminate recursive mutex in compat fb ioctl path
Submitter	: Keith Packard <keithp@keithp.com>
Date		: 2008-11-03 7:06 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=122569604828448&w=4
Handled-By	: Keith Packard <keithp@keithp.com>
		  Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Patch		: http://marc.info/?l=linux-kernel&m=122569604828448&w=4
		  http://lkml.org/lkml/2008/10/31/162


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11985
Subject		: 2.6.28-rc3 truncates nfsd results
Submitter	: Doug Nazar <nazard@dragoninc.ca>
Date		: 2008-11-04 18:27 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122582366509153&w=4
Handled-By	: Doug Nazar <nazard@dragoninc.ca>
		  J. Bruce Fields <bfields@fieldses.org>
Patch		: http://marc.info/?l=linux-kernel&m=122592648119790&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11982
Subject		: Fan level 7 after resume wit 2.6.28-rc3
Submitter	: Tino Keitel <tino.keitel@tikei.de>
Date		: 2008-11-05 7:33 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=122587043409186&w=4
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18744&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11942
Subject		: AMD64 reboot regression
Submitter	: Michael B. Trausch <mike@trausch.us>
Date		: 2008-11-02 20:30 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=122565790519736&w=4
Handled-By	: Len Brown <lenb@kernel.org>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11942#c11


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11937
Subject		: ext3 __log_wait_for_space: no transactions
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2008-10-30 9:49 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=122536026105643&w=4
Handled-By	: Theodore Tso <tytso@mit.edu>
Patch		: http://lkml.org/lkml/2008/11/1/61


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11925
Subject		: cdrom: missing compat ioctls
Submitter	: Andreas Schwab <schwab@suse.de>
Date		: 2008-10-31 14:02 (10 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=33c2dca4957bd0da3e1af7b96d0758d97e708ef6
Handled-By	: Andreas Schwab <schwab@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=122548923531545&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11917
Subject		: Asus Eee PC hotkeys stop working after prolonged usage
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-10-31 03:21 (10 days old)
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://marc.info/?l=linux-acpi&m=122603281422097&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11911
Subject		: new PCMCIA device instance after resume - orinoco can't download firmware
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-10-28 19:19 (13 days old)
References	: http://marc.info/?l=linux-wireless&m=122522165719760&w=4
Handled-By	: Dave <kilroyd@googlemail.com>
Patch		: http://marc.info/?l=linux-wireless&m=122539058601588&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11903
Subject		: regression: vmalloc easily fail
Submitter	: Glauber Costa <glommer@redhat.com>
Date		: 2008-10-28 20:59 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=db64fe02258f1507e13fe5212a989922323685ce
References	: http://marc.info/?l=linux-kernel&m=122522755530998&w=4
Handled-By	: Glauber Costa <glommer@redhat.com>
		  Nick Piggin <npiggin@suse.de>
		  Glauber Costa <glommer@redhat.com>
Patch		: http://marc.info/?l=linux-kernel&m=122609055221549&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11898
Subject		: mke2fs hang on AIC79 device.
Submitter	: alexs <alex.shi@intel.com>
Date		: 2008-10-30 01:17 (11 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f0c0a376d0fcd4c5579ecf5e95f88387cba85211
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11898#c28


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11895
Subject		: 2.6.28-rc2 regression: keyboard dead after reboot on Toshiba Portege 4000
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
Date		: 2008-10-28 19:05 (13 days old)
References	: http://marc.info/?l=linux-acpi&m=122522085418555&w=4
Handled-By	: Andrey Borzenkov <arvidjaar@mail.ru>
Patch		: http://marc.info/?l=linux-kernel&m=122547719810921&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11841
Subject		: plenty of line "ACPI: EC: non-query interrupt received, switching to interrupt mode" in dmesg and system not powering down
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-10-25 10:29 (16 days old)
Handled-By	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Patch		: http://marc.info/?l=linux-acpi&m=122603281922125&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11806
Subject		: iwl3945 fails with microcode error
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2008-10-22 02:36 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=122450235730661&w=4
Handled-By	: Reinette Chatre <reinette.chatre@intel.com>
Patch		: http://marc.info/?l=linux-wireless&m=122583010822172&w=2


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

