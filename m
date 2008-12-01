Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbYLAR22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbYLAR22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 12:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYLAR2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 12:28:19 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:5719 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYLAR2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 12:28:18 -0500
X-BigFish: VPS-32(ze80iz1432R98dR1805M179dR936fO873fnzzzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KB7KIA-03-VS6-01
Date: Mon, 1 Dec 2008 18:27:50 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: avi@redhat.com, kvm@vger.kernel.org, weidong.han@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, amit.shah@redhat.com
Subject: Re: [PATCH 3/9] add frontend implementation for the IOMMU API
Message-ID: <20081201172750.GD12816@amd.com>
References: <20081201231852P.fujita.tomonori@lab.ntt.co.jp> <20081201142727.GL29705@8bytes.org> <4933F5A7.8020408@redhat.com> <20081202005830P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081202005830P.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Dec 2008 17:27:50.0894 (UTC) FILETIME=[22D218E0:01C953DA]
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

Btw, if you use the k8-agp driver the GART space is already partitioned
today. So this concept is not entirely new.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

