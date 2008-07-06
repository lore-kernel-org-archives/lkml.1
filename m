Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbYGFRES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbYGFRES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbYGFREH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:04:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55473 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817AbYGFREG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:04:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Date: Sun, 6 Jul 2008 19:05:49 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org> <20080706155825.GB21669@cs181140183.pp.htv.fi>
In-Reply-To: <20080706155825.GB21669@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807061905.50261.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of July 2008, Adrian Bunk wrote:
> On Sun, Jul 06, 2008 at 08:46:09AM -0700, Linus Torvalds wrote:
> > On Sun, 6 Jul 2008, Rafael J. Wysocki wrote:
> >...
> > Fixed by commit 494de90098784b8e2797598cefdd34188884ec2e: "Do not 
> > overwrite nr_zones on !NUMA when initialising zlcache_ptr" by Mel.
> >...
> > This patch got merged: commit 1236edf1c70107a0d31b3fba0b2a8783615d0d24 
> > ("USB: don't lose disconnections during suspend").
> >...
> > Ditto: commit 7cd95f56cb61f5348d062527c9d3653196f6e629 ("ide: fix 
> > hwif->gendev refcounting")
> >...
> > Fixed in commit 70a3143af87c6ca188107cbd49ab5eec2c86c456 ("sata_uli: 
> > hardreset is broken")
> >...
> > Fixed in commit efac41894df57d32b483ac622d03541b5b2692c0 ("x86: fix 
> > NODES_SHIFT Kconfig range").
> >...
> 
> Thanks, all closed.
> 
> (I do try to close fixed regression bugs immediately after a fix enters
>  your tree, but espicially for commits without a reference to a Bugzilla
>  entry I sometimes miss it.)

Also, in the next couple of days I'll be closing the bugs the reporters of
which have been totally unresponsive.

I'll post an updated report after that.

Thanks,
Rafael
