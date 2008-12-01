Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYLAQ7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYLAQ7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYLAQ70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:59:26 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:7434 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbYLAQ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:59:24 -0500
X-BigFish: VPS-32(ze80iz1432R98dR1805M179dR936fO873fnzzzzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KB7J6G-04-CAF-01
Date: Mon, 1 Dec 2008 17:59:08 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: avi@redhat.com, kvm@vger.kernel.org, weidong.han@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, amit.shah@redhat.com
Subject: Re: [PATCH 3/9] add frontend implementation for the IOMMU API
Message-ID: <20081201165908.GC12816@amd.com>
References: <20081201231852P.fujita.tomonori@lab.ntt.co.jp> <20081201142727.GL29705@8bytes.org> <4933F5A7.8020408@redhat.com> <20081202005830P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081202005830P.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Dec 2008 16:59:08.0344 (UTC) FILETIME=[2019D380:01C953D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 12:58:29AM +0900, FUJITA Tomonori wrote:
> On Mon, 01 Dec 2008 16:33:11 +0200
> Avi Kivity <avi@redhat.com> wrote:
> 
> > Joerg Roedel wrote:
> > > Hmm, is there any hardware IOMMU with which we can't emulate domains by
> > > partitioning the IO address space? This concept works for GART and
> > > Calgary.
> > >
> > >   
> > 
> > Is partitioning secure?  Domain X's user could program its hardware to 
> > dma to domain Y's addresses, zapping away Domain Y's user's memory.
> 
> It can't be secure. So what's the point to emulate the domain
> partitioning in many traditional hardware IOMMUs that doesn't support
> it.

Its a generic way to make non-contiguous host memory io-contiguous. I
already pointed out some potential users for this.

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

