Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYIVQbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYIVQbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYIVQbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:31:34 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:46692 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYIVQbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:31:33 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7LV7T-04-1CR-01
Date: Mon, 22 Sep 2008 18:31:09 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD IOMMU: revert "x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off"
Message-ID: <20080922163109.GD24392@amd.com>
References: <20080922140749.GY24392@amd.com> <20080922231619X.fujita.tomonori@lab.ntt.co.jp> <20080922142713.GA24392@amd.com> <20080922235421A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080922235421A.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Sep 2008 16:31:09.0654 (UTC) FILETIME=[9E9B8F60:01C91CD0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 12:25:23AM +0900, FUJITA Tomonori wrote:
> I don't think that users need to have iommu=calgary parameter to use
> calgary IOMMU by default. If you enable CONFIG_CALGARY_IOMMU,
> CALGARY_IOMMU_ENABLED_BY_DEFAULT is also enabled by default. If a
> kernel finds calgary IOMMU, the kernel uses it by default.
> 
> It's also consistent with how SWIOTLB. Users don't need iommu=soft
> parameter to enable SWIOTLB. A kernel enables SWIOTLB automatically
> when necessary.

Yes. The parameters are usefull if a user wants to enable a specific
IOMMU implementation. The user could be an IOMMU developer testing
changes in a special implementation the kernel would not choose by
default on his machine.
I like Ingo's idea here. Lets do boths, implementing iommu=$type to
force a specific iommu implementation and $(type)_iommu=off to disable
one.

> Well, this is the problem about the IOMMUs parameters. The IOMMUs
> parameters are too complicated for everyone.

Not so complicated that they can't be understood. But if you have a
proposal how the command line parameters for iommus may look like, send
it. I like join that discussion about the interface.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

