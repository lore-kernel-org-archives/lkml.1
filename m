Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYICHGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYICHGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 03:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbYICHGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 03:06:21 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:22752 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYICHGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 03:06:20 -0400
X-BigFish: VPS-50(zz1432R98dR14ffO148cM1805M179dR936fQ8c8ajzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K6LYED-03-9Z5-01
Date: Wed, 3 Sep 2008 09:06:10 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       mingo@elte.hu
Subject: Re: linux-next: Tree for September 2
Message-ID: <20080903070610.GA17919@amd.com>
References: <20080902190207.7bcd06dc.sfr@canb.auug.org.au> <20080903093011.a5cc6887.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080903093011.a5cc6887.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 03 Sep 2008 07:06:10.0402 (UTC) FILETIME=[8B3AF420:01C90D93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 09:30:11AM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 2 Sep 2008 19:02:07 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi all,
> > 
> > Changes since next-20080901:
> > 
> > The x86 tree gained a conflict against the dwmw2 tree for which I
> > reverted a commit from the dwmw2 tree.
> > 
> > The sound tree lost its conflict.
> > 
> > The block tree gained a conflict against the device-mapper tree but lost
> > its build fix patch.
> > 
> > The ttydev tree lost a conflict but gained a build fix patch.
> > 
> > I have also applied the following patches for known problems:
> > 
> > 	ftrace: protect the definition of ftrace_release
> > 	revert BUILD_BUG_ON change
> > 	Revert "debug: add notifier chain debugging"
> > 	debug: add notifier chain debugging (different version)
> > 	sparc: qlogicpti fallout from sbus removal
> > 	powerpc: make sure all kernel test is before _etext
> > 
> From patch (not tested yet), it seems dma_alloc_coherent() on x86_64
> is still broken as I reported to August 29's linux-next.
> It easily goes down to swiotlb routine, which uses __GFP_DMA, and show
> "page allocation failure" at boot. Old code used __GFP_DMA32 as much as
> possible, I think.

Hmm, SWIOTLB unconditionally allocates from the DMA zone. Thats bad but
should be easy to change. I prepare a patch.

> Just a notification.

Thanks for pointing that out.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

