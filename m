Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYGYOPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYGYOPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYGYOPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:15:35 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:46065 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYGYOPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:15:34 -0400
X-BigFish: VPS-29(zz1503M1432R98dR1805M936fQ873fnzz10d3izzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K4KFKV-03-LNP-01
Date: Fri, 25 Jul 2008 16:14:25 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-ID: <20080725141425.GB7493@amd.com>
References: <20080725132121.GZ7493@amd.com> <20080725223533A.fujita.tomonori@lab.ntt.co.jp> <20080725134159.GA7493@amd.com> <20080725225724J.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080725225724J.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 25 Jul 2008 14:14:25.0925 (UTC) FILETIME=[BE6E9B50:01C8EE60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 10:57:24PM +0900, FUJITA Tomonori wrote:
> On Fri, 25 Jul 2008 15:41:59 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > Is there any other architecture independent way to find out the page
> > size the IOMMU is using? If yes I can rework that patchset.
> 
> There isn't now, I think.
>

Ok.

> 
> > If not, I suggest that we (you?) introduce one in a follow-on patch
> > series and fix the iommu_num_pages function then.
> 
> That's fine by me. Or I could try to find a solution and submit new
> patchset with your AMD and GART patches.

Thats also possible. But I prefer to fix that incrementally and merge
this first step.

> BTW, I prefer to push this patchset via -mm rather than x86 since
> after all we need to clean up all the IOMMUs.

Push it through -mm would make sense since it touches generic code in
lib/. On the other side in x86 we would avoid merge conflicts with
updates in AMD IOMMU and GART code.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

