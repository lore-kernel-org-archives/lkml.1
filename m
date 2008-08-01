Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYHAHDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYHAHDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYHAHDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:03:41 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:5925 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbYHAHDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:03:40 -0400
X-BigFish: VPS-11(zz1432R98dR1805M936fQzz10d3izz3198u327anz32i6bh8ah43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K4WU9V-03-5C2-01
Date: Fri, 1 Aug 2008 09:03:28 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: sfr@canb.auug.org.au, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, mingo@elte.hu, linuxppc-dev@ozlabs.org,
       davem@davemloft.net, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Revert "Merge branch 'x86/iommu' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip into for-linus"
Message-ID: <20080801070328.GA26894@amd.com>
References: <20080801094323.9601d87b.sfr@canb.auug.org.au> <20080801085106E.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080801085106E.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Aug 2008 07:03:28.0248 (UTC) FILETIME=[B2F27780:01C8F3A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 08:51:23AM +0900, FUJITA Tomonori wrote:
> On Fri, 1 Aug 2008 09:43:23 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > This reverts commit 29111f579f4f3f2a07385f931854ab0527ae7ea5.
> > 
> > This undoes the hasty addition of a global version of iommu_num_pages()
> > that broke both the powerpc and sparc builds.  This function can be
> > revisited later.
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  arch/x86/kernel/amd_iommu.c   |   13 ++++++++-----
> >  arch/x86/kernel/pci-gart_64.c |   11 +++++++----
> >  include/linux/iommu-helper.h  |    1 -
> >  lib/iommu-helper.c            |    8 --------
> >  4 files changed, 15 insertions(+), 18 deletions(-)
> > 
> > This patch comes from
> > git revert -m 1 29111f579f4f3f2a07385f931854ab0527ae7ea5
> > 
> > I have test built powerpc ppc64_defconfig and sparc64 defconfig.  The only
> > references to iommu_num_pages() after this is applied are in the powerpc
> > and sparc code.
> > 
> > Linus, please apply.  This is impacting on both powerpc and sparc
> > development and even the author of the patches said that those patches
> > were not urgent.
> 
> Ingo has a patch to fix this problem in the x86 tree:
> 
> http://marc.info/?l=linux-kernel&m=121754062325903&w=2

FUJITA,

can you send your fix directly to Linus again please? Andrew mentioned
that the x86 maintainers are on vacation. That may be the reason that
your fix is not yet upstream.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

