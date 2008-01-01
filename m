Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbYAAVBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbYAAVBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYAAVBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:01:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbYAAVBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:01:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc6-git7: Reported regressions from 2.6.23
Date: Tue, 1 Jan 2008 22:02:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801012202.57851.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.23 reported since
2.6.24-rc1 was released, for which there are no fixes in the mainline I know
of.  If any of them have been fixed already, please let me know.

If you know of any other unresolved regressions from 2.6.23, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  Today           139       38          23
  2007-12-21      118       21          13
  2007-12-18      115       29          15
  2007-12-12      106       31          17
  2007-12-08       98       29          19
  2007-12-01       85       29          18
  2007-11-24       75       25          21
  2007-11-19       68       26          21
  2007-11-17       65       25          20


Unresolved regressions
----------------------

Subject		: EHCI causes system to resume instantly from S4
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
Date		: 2007-10-28 14:56
References	: http://lkml.org/lkml/2007/10/27/66
		  http://bugzilla.kernel.org/show_bug.cgi?id=9258
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
		  David Brownell <david-b@pacbell.net>
		  Alan Stern <stern@rowland.harvard.edu>
Patch		: 
Workaround	: http://bugzilla.kernel.org/show_bug.cgi?id=9258#c30


Subject		: v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of device
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2007-11-13 13:11
References	: http://lkml.org/lkml/2007/11/13/250
		  http://bugzilla.kernel.org/show_bug.cgi?id=9370
Handled-By	: Matthew Wilcox <matthew@wil.cx>
Patch		: 


Subject		: SError: { DevExch } occuring and causing disruption
Submitter	: Avuton Olrich <avuton@gmail.com>
Date		: 2007-11-15 22:39
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9393
Handled-By	: Tejun Heo <htejun@gmail.com>
		  Mark Lord <mlord@pobox.com>
Patch		: 


Subject		: 20000+ wake-ups/second in 2.6.24
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2007-12-02 04:23
References	: http://lkml.org/lkml/2007/12/1/141
		  http://bugzilla.kernel.org/show_bug.cgi?id=9489
Handled-By	: Arjan van de Ven <arjan@infradead.org>
Patch		: 


Subject		: 2.6.24: false double-clicks from USB mouse
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2007-12-02 12:05
References	: http://lkml.org/lkml/2007/12/2/86
		  http://bugzilla.kernel.org/show_bug.cgi?id=9492
Handled-By	: Jiri Kosina <jkosina@suse.cz>
		  Dmitry Torokhov <dmitry.torokhov@gmail.com>
Patch		: 


Subject		: kobject ->k_name memory leak
Submitter	: Alexey Dobriyan <adobriyan@sw.ru>
Date		: 2007-12-03 13:42
References	: http://lkml.org/lkml/2007/12/3/20
		  http://bugzilla.kernel.org/show_bug.cgi?id=9496
Handled-By	: Greg KH <gregkh@suse.de>
Patch		: 


Subject		: 2.6.24-rc4 hwmon it87 probe fails
Submitter	: Mike Houston <mikeserv@bmts.com>
Date		: 2007-12-06 17:10
References	: http://lkml.org/lkml/2007/12/4/466
		  http://bugzilla.kernel.org/show_bug.cgi?id=9514
Handled-By	: Shaohua Li <shaohua.li@intel.com>
Patch		: 


Subject		: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Submitter	: "Parag Warudkar" <parag.warudkar@gmail.com>
Date		: 2007-12-07 18:14
References	: http://lkml.org/lkml/2007/12/7/299
		  http://bugzilla.kernel.org/show_bug.cgi?id=9525
Handled-By	: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
		  Thomas Gleixner <tglx@linutronix.de>
		  Ingo Molnar <mingo@elte.hu>
Patch		: 


Subject		: BUG: bad unlock balance detected!
Submitter	: Krzysztof Oledzki <olel@ans.pl>
Date		: 2007-12-11 03:17
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9542
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Herbert Xu <herbert@gondor.apana.org.au>
Patch		: 


Subject		: PATA_HPT37X embezzles two ports
Submitter	: "Bjoern Olausson" <lkmlist@gmail.com>
Date		: 2007-12-12 11:05
References	: http://lkml.org/lkml/2007/12/12/161
		  http://bugzilla.kernel.org/show_bug.cgi?id=9551
Handled-By	: 
Patch		: 


Subject		: Could not set non-blocking flag with 2.6.24-rc5
Submitter	: Tino Keitel <tino.keitel@gmx.de>
Date		: 2007-12-13 16:27
References	: http://lkml.org/lkml/2007/12/13/392
		  http://bugzilla.kernel.org/show_bug.cgi?id=9557
Handled-By	: 
Patch		: 


Subject		: swapping in 2.6.24-rc5-git3
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2007-12-17 14:04
References	: http://lkml.org/lkml/2007/12/17/98
		  http://bugzilla.kernel.org/show_bug.cgi?id=9592
Handled-By	: Jan Kara <jack@suse.cz>
Patch		: 


Subject		: linux-2.6.24-rcX regression / xserver-xorg-video-intel / Q35
Submitter	: Harald Welte <laforge@gnumonks.org>
Date		: 2007-12-22 04:37
References	: http://lkml.org/lkml/2007/12/21/269
		  http://bugzilla.kernel.org/show_bug.cgi?id=9618
Handled-By	: Zhenyu Wang <zhen78@gmail.com>
Patch		: 


Subject		: list corruption on ib_srp load in v2.6.24-rc5
Submitter	: David Dillow <dillowda@ornl.gov>
Date		: 2007-12-22 04:42
References	: http://lkml.org/lkml/2007/12/21/229
		  http://bugzilla.kernel.org/show_bug.cgi?id=9619
Handled-By	: Roland Dreier <rdreier@cisco.com>
Patch		: 


Subject		: Problems on booting
Submitter	: "werner" <werner@copaya.yi.org>
Date		: 2007-12-22 14:29
References	: http://lkml.org/lkml/2007/12/22/110
		  http://bugzilla.kernel.org/show_bug.cgi?id=9621
Handled-By	: 
Patch		: 


Subject		: ACPI or radeon: spontaneous reboot regression
Submitter	: Matt Mackall <mpm@selenic.com>
Date		: 2007-12-22 16:09
References	: http://lkml.org/lkml/2007/12/22/139
		  http://bugzilla.kernel.org/show_bug.cgi?id=9624
Handled-By	: 
Patch		: 


Subject		: 2.6.24-rc6 2.6.24-rc3 qstor timeouts during probe
Submitter	: Alan Young <ayoung@teleport.com>
Date		: 2007-12-24 15:17
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9631
Handled-By	: 
Patch		: 


Subject		: NULL dereference in fs/nfs/super.c:nfs_xdev_get_sb()
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2007-12-27 12:36
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9647
Handled-By	: 
Patch		: 


Subject		: in 2.6.24-rc6 function keys stopped working - toshiba u300-13m, FSC V5505
Submitter	: Keepa Mihail Sergeevich <msnkipa@mail.ru>
Date		: 2007-12-29 16:07
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9663
Handled-By	: Len Brown <len.brown@intel.com>
Patch		: 


Subject		: powerpc/platforms/cell/spufs/: multiple definition of `notify_spus_active'
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2007-12-31 10:52
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9667
Handled-By	: 
Patch		: 


Subject		: lockdep warning with LTP dio test (v2.6.24-rc6-125-g5356f66)
Submitter	: Erez Zadok <ezk@cs.sunysb.edu>
Date		: 2007-12-24 18:02
References	: http://lkml.org/lkml/2007/12/24/107
		  http://bugzilla.kernel.org/show_bug.cgi?id=9670
Handled-By	: 
Patch		: 


Subject		: build #341 failed for 2.6.24-rc6-g1842c7f in linux/./drivers/media/dvb/ttpci/budget-av.c
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2007-12-29 16:17
References	: http://lkml.org/lkml/2007/12/29/67
		  http://bugzilla.kernel.org/show_bug.cgi?id=9671
Handled-By	: 
Patch		: 


Subject		: IDE/ACPI related hibernation regression: Second attempt fails
Submitter	: Mikko Vinni <mmvinni@yahoo.com>
Date		: 2007-12-31 13:27
References	: http://lkml.org/lkml/2007/12/31/135
		  http://bugzilla.kernel.org/show_bug.cgi?id=9673
Handled-By	: Andreas Mohr <andi@lisas.de>
Patch		: 


Regressions with patches
------------------------

Subject		: [2.6.24-rc6] pdflush still stuck in D state regression
Submitter	: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Date		: 2007-11-02 09:54
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9291
Handled-By	: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14219&action=view


Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
Submitter	: Roland Dreier <rdreier@cisco.com>
Date		: 2007-11-08 14:55
References	: http://lkml.org/lkml/2007/11/8/255
		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
Handled-By	: Takashi Iwai <tiwai@suse.de>
		  Ingo Molnar <mingo@elte.hu>
Patch		: http://lkml.org/lkml/2007/11/16/66


Subject		: jiffies counter leaps in 2.6.24-rc3
Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
Date		: 2007-11-29 08:36
References	: http://lkml.org/lkml/2007/11/24/53
		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://lkml.org/lkml/2007/12/7/132


Subject		: Battery shows up twice in kpowersave
Submitter	: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date		: 2007-12-03 12:06
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9494
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14137&action=view


Subject		: RTNL: assertion failed at net/ipv6/addrconf.c (2164)/RTNL: assertion failed at net/ipv4/devinet.c (1055)
Submitter	: Krzysztof Oledzki <olel@ans.pl>
Date		: 2007-12-11 03:20
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9543
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Herbert Xu <herbert@gondor.apana.org.au>
		  Jay Vosburgh <fubar@us.ibm.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=9543#c6


Subject		: Important regression with XFS update for 2.6.24-rc6
Submitter	: Damien Wyart <damien.wyart@free.fr>
Date		: 2007-12-19 15:35
References	: http://lkml.org/lkml/2007/12/18/126
		  http://bugzilla.kernel.org/show_bug.cgi?id=9607
Handled-By	: David Chinner <dgc@sgi.com>
Patch		: http://lkml.org/lkml/2007/12/19/62


Subject		: [PATCH] slub: /proc/slabinfo ABI compatibility
Submitter	: Pekka J Enberg <penberg@cs.helsinki.fi>
Date		: 2007-12-22 14:51
References	: http://lkml.org/lkml/2007/12/22/58
		  http://bugzilla.kernel.org/show_bug.cgi?id=9623
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://lkml.org/lkml/2007/12/22/58
		  http://lkml.org/lkml/2007/12/22/63
		  http://lkml.org/lkml/2007/12/22/67


Subject		: drivers/usb/serial/pl2303: does not support 4348:5523
Submitter	: Piotr Roszatycki <dexter@debian.org>
Date		: 2007-12-23 12:55
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9626
Handled-By	: Greg Kroah-Hartman <greg@kroah.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=9626#c0


Subject		: Regression: Battery method parse error
Submitter	: Bruce Duncan <B.W.Duncan@sms.ed.ac.uk>
Date		: 2007-12-23 13:00
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9627
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14181&action=view


Subject		: Unaligned accesses in xfs_file_readdir
Submitter	: Dustin Marquess <jailbird@alcatraz.fdf.net>
Date		: 2007-12-25 17:47
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9635
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14249&action=view


Subject		: restore ARMv6 OProfile support
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2007-12-28 11:39
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9653
		  http://lkml.org/lkml/2007/12/28/99
Handled-By	: Adrian Bunk <adrian.bunk@movial.fi>
Patch		: http://lkml.org/lkml/2007/12/28/99


Subject		: restore blackfin HARDWARE_PM support
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2007-12-28 11:40
References	: http://lkml.org/lkml/2007/12/28/100
		  http://bugzilla.kernel.org/show_bug.cgi?id=9654
Handled-By	: Adrian Bunk <adrian.bunk@movial.fi>
Patch		: http://lkml.org/lkml/2007/12/28/100


Subject		: restore Cell OProfile support
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2007-12-28 11:40
References	: http://lkml.org/lkml/2007/12/28/101
		  http://bugzilla.kernel.org/show_bug.cgi?id=9655
Handled-By	: Adrian Bunk <adrian.bunk@movial.fi>
Patch		: http://lkml.org/lkml/2007/12/28/101


Subject		: Booting from nfsroot fails
Submitter	: Puzin, Dimitri <bugs@psycast.de>
Date		: 2007-12-29 11:54
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9661
Handled-By	: "David S. Miller" <davem@davemloft.net>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14224&action=view


Subject		: [usb regression] Re: [PATCH 2.6.24-rc3] Fix /proc/net breakage
Submitter	: Andreas Mohr <andi@lisas.de>
Date		: 2007-12-30 17:14
References	: http://lkml.org/lkml/2007/12/30/144
		  http://bugzilla.kernel.org/show_bug.cgi?id=9672
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
		  Greg KH <greg@kroah.com>
Patch		: http://lkml.org/lkml/2007/12/30/188


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.23,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9243

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
