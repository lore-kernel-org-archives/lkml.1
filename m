Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbYG3SxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbYG3SxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYG3Sw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:52:58 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:62687 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYG3Sw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:52:57 -0400
X-BigFish: VPS-24(zz1432R98dR1805M936fQ873fnzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4U1RS-03-36P-01
Date: Wed, 30 Jul 2008 20:52:44 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: davem@davemloft.net, sfr@canb.auug.org.au, mingo@elte.hu, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-ID: <20080730185244.GP4851@amd.com>
References: <20080729095027.GA4851@amd.com> <20080729.031005.203132019.davem@davemloft.net> <20080730121805.GM4851@amd.com> <20080730221540S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080730221540S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 30 Jul 2008 18:52:44.0730 (UTC) FILETIME=[73C2C9A0:01C8F275]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 10:16:05PM +0900, FUJITA Tomonori wrote:
> On Wed, 30 Jul 2008 14:18:05 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > Ok, after setting up cross compile environments for sparc64 and
> > powerpc64 I wrote a patch which adds the io_page_size argument to the
> > iommu_num pages function and moves the function back to
> > lib/iommu-helper.c.
> 
> You need ia64, parisc, and alpha too. :) 

Ok, I looked into the different IOMMU drivers for pa-risc and ia64. The
changes needed there are non-trival and I can't test them on real
hardware (I only have an pa-risc 1.1). So I think I skip these 2
architectures for now. They can be changed by somebody who has the
hardware :)
(Alpha instead was trival. I changed this driver)

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

