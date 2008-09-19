Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYISRae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYISRae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYISRa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:30:26 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:15099 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYISRaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:30:25 -0400
X-BigFish: VPS-37(z1039oz1418M1432R98dR1805M179dR936fQzz10d3izz2f39iz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7GDXY-04-W17-01
Date: Fri, 19 Sep 2008 19:30:04 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic option
Message-ID: <20080919173004.GA9837@amd.com>
References: <20080920012322R.fujita.tomonori@lab.ntt.co.jp> <20080919164541.GS24392@amd.com> <20080920020917O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080920020917O.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Sep 2008 17:30:04.0106 (UTC) FILETIME=[5A10E2A0:01C91A7D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 02:09:21AM +0900, FUJITA Tomonori wrote:
> 
> Please keep it for AMD option for now. Please send a patch to make it
> generic to other IOMMU people and give them a chance to discuss on
> it.
>

Btw, you already agreed with a generic iommu= parameter for lazy IO/TLB
flushing"


 > True. We should merge common parameters across IOMMUs into the
 > iommu= parameter some time in the future, I think. It would also be the
 > place for the IOMMU size parameter.

 Hmm, now is better than the future? I think that now you can add
 something like 'disable_batching_flush' as a common parameter and
 change AMD IOMMU to use it.

in http://lkml.org/lkml/2008/9/17/376

And since we already have a iommu=fullflush parameter it makes sense of
make it generic.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

