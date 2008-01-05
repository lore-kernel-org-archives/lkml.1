Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYAETkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYAETkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYAETkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:40:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57457 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152AbYAETkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:40:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Date: Sat, 5 Jan 2008 20:42:55 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801052042.56042.rjw@sisk.pl>
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
  Today           139       28          15
  2008-01-01      139       38          23
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
Workaround	: http://bugzilla.kernel.org/show_bug.cgi?id=9258#c30


Subject		: SError: { DevExch } occuring and causing disruption
Submitter	: Avuton Olrich <avuton@gmail.com>
Date		: 2007-11-15 22:39
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9393
Handled-By	: Tejun Heo <htejun@gmail.com>
		  Mark Lord <mlord@pobox.com>


Subject		: 20000+ wake-ups/second in 2.6.24
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2007-12-02 04:23
References	: http://lkml.org/lkml/2007/12/1/141
		  http://bugzilla.kernel.org/show_bug.cgi?id=9489
Handled-By	: Arjan van de Ven <arjan@infradead.org>


Subject		: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Submitter	: "Parag Warudkar" <parag.warudkar@gmail.com>
Date		: 2007-12-07 18:14
References	: http://lkml.org/lkml/2007/12/7/299
		  http://bugzilla.kernel.org/show_bug.cgi?id=9525
Handled-By	: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
		  Thomas Gleixner <tglx@linutronix.de>
		  Ingo Molnar <mingo@elte.hu>


Subject		: BUG: bad unlock balance detected!
Submitter	: Krzysztof Oledzki <olel@ans.pl>
Date		: 2007-12-11 03:17
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9542
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Herbert Xu <herbert@gondor.apana.org.au>


Subject		: PATA_HPT37X embezzles two ports
Submitter	: "Bjoern Olausson" <lkmlist@gmail.com>
Date		: 2007-12-12 11:05
References	: http://lkml.org/lkml/2007/12/12/161
		  http://bugzilla.kernel.org/show_bug.cgi?id=9551
Handled-By	: 


Subject		: Could not set non-blocking flag with 2.6.24-rc5
Submitter	: Tino Keitel <tino.keitel@gmx.de>
Date		: 2007-12-13 16:27
References	: http://lkml.org/lkml/2007/12/13/392
		  http://bugzilla.kernel.org/show_bug.cgi?id=9557
Handled-By	: 


Subject		: swapping in 2.6.24-rc5-git3
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2007-12-17 14:04
References	: http://lkml.org/lkml/2007/12/17/98
		  http://bugzilla.kernel.org/show_bug.cgi?id=9592
Handled-By	: Jan Kara <jack@suse.cz>


Subject		: Problems on booting
Submitter	: "werner" <werner@copaya.yi.org>
Date		: 2007-12-22 14:29
References	: http://lkml.org/lkml/2007/12/22/110
		  http://bugzilla.kernel.org/show_bug.cgi?id=9621
Handled-By	: 


Subject		: ACPI or radeon: spontaneous reboot regression
Submitter	: Matt Mackall <mpm@selenic.com>
Date		: 2007-12-22 16:09
References	: http://lkml.org/lkml/2007/12/22/139
		  http://bugzilla.kernel.org/show_bug.cgi?id=9624
Handled-By	: 


Subject		: iptables won't work
Submitter	: Kristoffer Malmström <malmis@malmis.com>
Date		: 2007-12-28
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9657
Handled-By	: Patrick McHardy <kaber@trash.net>


Subject		: in 2.6.24-rc6 function keys stopped working - toshiba u300-13m, FSC V5505
Submitter	: Keepa Mihail Sergeevich <msnkipa@mail.ru>
Date		: 2007-12-29 16:07
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9663
Handled-By	: Len Brown <len.brown@intel.com>


Subject		: lockdep warning with LTP dio test (v2.6.24-rc6-125-g5356f66)
Submitter	: Erez Zadok <ezk@cs.sunysb.edu>
Date		: 2007-12-24 18:02
References	: http://lkml.org/lkml/2007/12/24/107
		  http://bugzilla.kernel.org/show_bug.cgi?id=9670
Handled-By	: 


Subject		: IDE/ACPI related hibernation regression: Second attempt fails
Submitter	: Mikko Vinni <mmvinni@yahoo.com>
Date		: 2007-12-31 13:27
References	: http://lkml.org/lkml/2007/12/31/135
		  http://bugzilla.kernel.org/show_bug.cgi?id=9673
Handled-By	: Andreas Mohr <andi@lisas.de>


Subject		: kexec buffer error
Submitter	: Randy Dunlap <rdunlap@xenotime.net>
Date		: 2008-01-04 22:54
References	: http://lkml.org/lkml/2008/1/4/255
		  http://bugzilla.kernel.org/show_bug.cgi?id=9693
Handled-By	: 


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


Subject		: 2.6.24-rc4 hwmon it87 probe fails
Submitter	: Mike Houston <mikeserv@bmts.com>
Date		: 2007-12-06 17:10
References	: http://lkml.org/lkml/2007/12/4/466
		  http://bugzilla.kernel.org/show_bug.cgi?id=9514
Handled-By	: Shaohua Li <shaohua.li@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14267&action=view


Subject		: RTNL: assertion failed at net/ipv6/addrconf.c (2164)/RTNL: assertion failed at net/ipv4/devinet.c (1055)
Submitter	: Krzysztof Oledzki <olel@ans.pl>
Date		: 2007-12-11 03:20
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9543
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Herbert Xu <herbert@gondor.apana.org.au>
		  Jay Vosburgh <fubar@us.ibm.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=9543#c6


Subject		: Regression: Battery method parse error
Submitter	: Bruce Duncan <B.W.Duncan@sms.ed.ac.uk>
Date		: 2007-12-23 13:00
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9627
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14181&action=view


Subject		: 2.6.24-rc6 2.6.24-rc3 qstor timeouts during probe
Submitter	: Alan Young <ayoung@teleport.com>
Date		: 2007-12-24 15:17
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9631
Handled-By	: Tejun Heo <htejun@gmail.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14259&action=view


Subject		: Unaligned accesses in xfs_file_readdir
Submitter	: Dustin Marquess <jailbird@alcatraz.fdf.net>
Date		: 2007-12-25 17:47
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9635
Handled-By	: Christoph Hellwig <hch@lst.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14255&action=view


Subject		: restore ARMv6 OProfile support
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2007-12-28 11:39
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9653
		  http://lkml.org/lkml/2007/12/28/99
Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Patch		: http://lkml.org/lkml/2007/12/29/111


Subject		: restore blackfin HARDWARE_PM support
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2007-12-28 11:40
References	: http://lkml.org/lkml/2007/12/28/100
		  http://bugzilla.kernel.org/show_bug.cgi?id=9654
Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Patch		: http://lkml.org/lkml/2007/12/29/75


Subject		: Booting from nfsroot fails
Submitter	: Puzin, Dimitri <bugs@psycast.de>
Date		: 2007-12-29 11:54
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9661
Handled-By	: "David S. Miller" <davem@davemloft.net>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14224&action=view


Subject		: max_cstate VMware regression
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2008-01-03 14:54
References	: http://lkml.org/lkml/2008/1/2/328
		  http://bugzilla.kernel.org/show_bug.cgi?id=9683
Handled-By	: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Patch		: http://lkml.org/lkml/2008/1/3/399


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.23,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9243

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
