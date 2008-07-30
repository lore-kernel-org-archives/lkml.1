Return-Path: <linux-kernel-owner+w=401wt.eu-S1761769AbYG3OEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761769AbYG3OEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYG3OD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:03:59 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:15728 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYG3OD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:03:58 -0400
X-BigFish: VPS-33(zz1102L1432R98dR4015M1805M936fQ873fnzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4TOE2-03-LBM-01
Date: Wed, 30 Jul 2008 16:03:39 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: davem@davemloft.net, sfr@canb.auug.org.au, mingo@elte.hu, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-ID: <20080730140339.GN4851@amd.com>
References: <20080729095027.GA4851@amd.com> <20080729.031005.203132019.davem@davemloft.net> <20080730121805.GM4851@amd.com> <20080730221540S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080730221540S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 30 Jul 2008 14:03:39.0876 (UTC) FILETIME=[116C1A40:01C8F24D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 10:16:05PM +0900, FUJITA Tomonori wrote:
> On Wed, 30 Jul 2008 14:18:05 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:

> > Ok, after setting up cross compile environments for sparc64 and
> > powerpc64 I wrote a patch which adds the io_page_size argument to the
> > iommu_num pages function and moves the function back to
> > lib/iommu-helper.c.
> 
> You need ia64, parisc, and alpha too. :) 
> 
> I have cross compile environments for them so I can take care of them
> if you like.

Ok, so you suggest to create a patchset to convert the other IOMMU
implementations too. Thats fine for me, I will try to do it :)
Do you have hardware to do runtime tests of the code? I have hardware
only for x86, sparc64 and alpha.

> 
> > The patch touches all 3 architectures and can not be
> > split in a bisectable way.
> 
> How about naming a new helper function iommu_nr_pages (or something)?
> 
> Then you can do the conversion independently. If we like, we use
> iommu_num_pages name after the conversion.

Ok, this would mean only 3 renaming patches to keep the patch series
bisectable. This should be acceptable.

> 
> > Who is the best person to send this patch to?
> 
> The -mm is an appropriate tree, I think.

Ok, then I submit it to Andrew once its tested.

Thanks,

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

