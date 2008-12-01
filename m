Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbYLAPqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbYLAPqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 10:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYLAPq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 10:46:26 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:51351 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYLAPq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 10:46:26 -0500
X-BigFish: VPS-38(ze80iz1432R98dR1805M179dR936fOzzzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KB7FSP-03-PSK-01
Date: Mon, 1 Dec 2008 16:46:03 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org, weidong.han@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, amit.shah@redhat.com
Subject: Re: [PATCH 3/9] add frontend implementation for the IOMMU API
Message-ID: <20081201154603.GB12816@amd.com>
References: <20081201173830B.fujita.tomonori@lab.ntt.co.jp> <20081201120026.GF17719@amd.com> <20081201130209.GA21615@il.ibm.com> <20081201231852P.fujita.tomonori@lab.ntt.co.jp> <20081201142727.GL29705@8bytes.org> <4933F5A7.8020408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4933F5A7.8020408@redhat.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Dec 2008 15:46:03.0341 (UTC) FILETIME=[EA6F77D0:01C953CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 04:33:11PM +0200, Avi Kivity wrote:
> Joerg Roedel wrote:
> > Hmm, is there any hardware IOMMU with which we can't emulate domains by
> > partitioning the IO address space? This concept works for GART and
> > Calgary.
> >
> >   
> 
> Is partitioning secure?  Domain X's user could program its hardware to 
> dma to domain Y's addresses, zapping away Domain Y's user's memory.

No its not secure. But this problem exists with pv-dma without iommu
too.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

