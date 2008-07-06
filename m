Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbYGFP7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbYGFP7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 11:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbYGFP7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 11:59:12 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51280 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818AbYGFP7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 11:59:10 -0400
Date: Sun, 6 Jul 2008 18:58:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Message-ID: <20080706155825.GB21669@cs181140183.pp.htv.fi>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 08:46:09AM -0700, Linus Torvalds wrote:
> On Sun, 6 Jul 2008, Rafael J. Wysocki wrote:
>...
> Fixed by commit 494de90098784b8e2797598cefdd34188884ec2e: "Do not 
> overwrite nr_zones on !NUMA when initialising zlcache_ptr" by Mel.
>...
> This patch got merged: commit 1236edf1c70107a0d31b3fba0b2a8783615d0d24 
> ("USB: don't lose disconnections during suspend").
>...
> Ditto: commit 7cd95f56cb61f5348d062527c9d3653196f6e629 ("ide: fix 
> hwif->gendev refcounting")
>...
> Fixed in commit 70a3143af87c6ca188107cbd49ab5eec2c86c456 ("sata_uli: 
> hardreset is broken")
>...
> Fixed in commit efac41894df57d32b483ac622d03541b5b2692c0 ("x86: fix 
> NODES_SHIFT Kconfig range").
>...

Thanks, all closed.

(I do try to close fixed regression bugs immediately after a fix enters
 your tree, but espicially for commits without a reference to a Bugzilla
 entry I sometimes miss it.)

> 				Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

