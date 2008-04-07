Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbYDGM7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbYDGM7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 08:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYDGM7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 08:59:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54757 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbYDGM73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 08:59:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25-rc8-git5: Reported regressions from 2.6.24
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 7 Apr 2008 14:59:34 +0200
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <200804071459.35628.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This time it's without the accompanying reply messages, because there are
some MIME-related problems with them I have yet to fix and I didn't want to
defer sending the entire report because of them, given that we have some new
regressions caused by very recent commits.

First of all, commit 92c9d07507f0a90b64172bfede7e6fa845e8e66b, for which
there is a patch at http://lkml.org/lkml/2008/4/6/113, refers to undefined
symbols.

Second, http://bugzilla.kernel.org/show_bug.cgi?id=10410 is worrisome.  It
looks like we have not understood the issue well enough, after all.

Apart from this, there seems to be a resume regression related to graphics
that's been causing some headaches to us recently.  It's unrelated to the
recently reverted ACPI commit, but apparently is generic enough to affect
the users of both the ATI and Intel adapters, but only some of them.]

This message contains a list of some regressions from 2.6.24, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.24, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-04-07      188       29          22
  2008-03-31      177       34          31
  2008-03-27      171       38          30
  2008-03-22      159       35          31
  2008-03-17      148       38          30
  2008-03-16      146       42          35
  2008-03-14      145       45          39
  2008-03-12      143       51          41
  2008-03-11      141       58          43
  2008-03-10      138       66          47
  2008-03-03      115       65          49
  2008-02-25       90       51          39
  2008-02-17       61       45          37


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10412
Subject		: BUG: scheduling while atomic: kmail/32546/0x00000003
Submitter	: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
Date		: 2008-04-07 02:33 (1 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10410
Subject		: "x86: tsc prevent time going backwards" broke suspend
Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
Date		: 2008-04-07 02:08 (1 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10393
Subject		: ext4 compile error on m68k
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-04-05 03:30 (3 days old)
References	: http://lkml.org/lkml/2008/4/5/19


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10391
Subject		: 2.6.25-rc7/8: Another resume regression
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2008-04-03 15:06 (5 days old)
References	: http://lkml.org/lkml/2008/4/3/283


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10377
Subject		: Kernel freezes during boot when AC is unplugged
Submitter	: Roman Jarosz <kedgedev@centrum.cz>
Date		: 2008-04-01 16:23 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10369
Subject		: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Submitter	: Chr <chunkeey@web.de>
Date		: 2008-03-30 21:09 (9 days old)
References	: http://lkml.org/lkml/2008/3/30/87


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10365
Subject		: usb-storage, error reading the last 8 sectors, regression in 2.6.25-rc7
Submitter	: Sergey Dolgov <solkaa@gmail.com>
Date		: 2008-03-30 11:49 (9 days old)
References	: http://lkml.org/lkml/2008/3/30/11


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10344
Subject		: [2.6.25-rc6] possible regression: X server dying
Submitter	: Tilman Schmidt <tilman@imap.cc>
Date		: 2008-03-24 23:38 (15 days old)
References	: http://lkml.org/lkml/2008/3/24/260
Handled-By	: Dave Airlie <airlied@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10323
Subject		: panic using bridging on linus kernel 2.6.25-rc6
Submitter	: Andy Gospodarek <andy@greyhouse.net>
Date		: 2008-03-25 11:40 (14 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10320
Subject		: rt2x00 does not associate or give scan results
Submitter	: Marcus Better <marcus@better.se>
Date		: 2008-03-25 06:04 (14 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10319
Subject		: 2.6.25-rc6 regression - hang on resume
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-03-25 04:44 (14 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10302
Subject		: 2.6.25-git regression with snd-hda-intel on Dell XPS M1330, no analog sound
Submitter	: Andre Tomt <andre@tomt.net>
Date		: 2008-03-21 20:03 (18 days old)
References	: http://lkml.org/lkml/2008/3/21/295
Handled-By	: Matthew Ranostay <mranostay@embeddedalley.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10300
Subject		: volume wheel does not work in 2.6.25-rc6
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-03-21 11:42 (18 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10290
Subject		: [BUG] Linux 2.6.25-rc6 - kernel BUG at fs/mpage.c:476! on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-03-20 13:13 (19 days old)
References	: http://lkml.org/lkml/2008/3/20/39


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10235
Subject		: 2.6.25-rc5: Blank Screen with Intel 945
Submitter	: Justin Madru <jdm64@gawab.com>
Date		: 2008-03-12 12:02 (27 days old)
References	: http://lkml.org/lkml/2008/3/12/290
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10172
Subject		: kvm: INFO: inconsistent lock state
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-03-05 03:26 (34 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10156
Subject		: KVM &amp; Qemu crashed with infinite recursive kernel loop in the guest
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-02-28 11:25 (40 days old)
References	: http://lkml.org/lkml/2008/2/28/106


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10133
Subject		: INFO: possible circular locking in the resume
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-02-27 (41 days old)
References	: http://lkml.org/lkml/2008/2/26/479
Handled-By	: Gautham R Shenoy <ego@in.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10117
Subject		: 2.6.25-current-git hangs on boot (pci=nommconf helps)
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-23 18:55 (45 days old)
References	: http://lkml.org/lkml/2008/2/23/263


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10093
Subject		: 2.6.25-current-git blocks for 10-15 secs on boot unless CONFIG_CPU_IDLE=n - Apple
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-23 18:55 (45 days old)
References	: http://lkml.org/lkml/2008/2/23/263
		  http://marc.info/?l=linux-acpi&amp;m=120387537018467&amp;w=4
Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10082
Subject		: 2.6.25-rc2-git4 - Kernel oops while running kernbench and tbench on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-02-20 16:01 (48 days old)
References	: http://lkml.org/lkml/2008/2/20/218
		  http://lkml.org/lkml/2008/1/18/71


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
Subject		: 2.6.25-rc1: volanoMark regression
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-02-13 10:30 (55 days old)
References	: http://lkml.org/lkml/2008/2/13/128
Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


Regressionn with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10414
Subject		: Compilation broken by commit 92c9d07507f0a90b64172bfede7e6fa845e8e66b
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-04-07 04:20 (1 days old)
References	: http://bugzilla.kernel.org/show_bug.cgi?id=10319#c14
Handled-By	: Michael Krufky <mkrufky@linuxtv.org>
Patch		: http://lkml.org/lkml/2008/4/6/113


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10411
Subject		: [PATCH] scsi: fix sense_slab/bio swapping livelock
Submitter	: Hugh Dickins <hugh@veritas.com>
Date		: 2008-04-06 23:56 (2 days old)
References	: http://lkml.org/lkml/2008/4/6/99
Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
Patch		: http://lkml.org/lkml/2008/4/6/99


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10395
Subject		: DRI is not working with 945GME
Submitter	: Alexander Oltu <alexander@all-2.com>
Date		: 2008-04-05 07:50 (3 days old)
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15627&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10384
Subject		: 2.6.25-rc6-git2: warn_on_slowpath for tcp_simple_retransmit
Submitter	: Alessandro Suardi <alessandro.suardi@gmail.com>
Date		: 2008-04-02 00:28 (6 days old)
References	: http://lkml.org/lkml/2008/4/1/408
Handled-By	: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Patch		: http://marc.info/?l=linux-netdev&amp;m=120756760521961&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10366
Subject		: 2.6.25-rc7: warn_on_slowpath triggered
Submitter	: Bob Tracy <rct@frus.com>
Date		: 2008-03-29 17:29 (10 days old)
References	: http://lkml.org/lkml/2008/3/29/125
Handled-By	: Björn Steinbrink <B.Steinbrink@gmx.de>
Patch		: http://lkml.org/lkml/2008/3/30/245


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10326
Subject		: inconsistent lock state in net_rx_action
Submitter	: Marcus Better <marcus@better.se>
Date		: 2008-03-25 13:21 (14 days old)
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10326#c20


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10153
Subject		: (regression) kernel/timeconst.h bugs with HZ=128
Submitter	: David Brownell <david-b@pacbell.net>
Date		: 2008-02-26 19:32 (42 days old)
References	: http://lkml.org/lkml/2008/2/26/294
Handled-By	: H. Peter Anvin <hpa@zytor.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15114&amp;action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=15115&amp;action=view


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.24,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9832

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
