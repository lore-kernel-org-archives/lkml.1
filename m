Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbYIVMFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbYIVMFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 08:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYIVMFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 08:05:33 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53284 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYIVMFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 08:05:33 -0400
X-BigFish: VPS-8(z1039oz98dR936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7LIWU-04-P5C-01
Date: Mon, 22 Sep 2008 14:05:19 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic option
Message-ID: <20080922120519.GX24392@amd.com>
References: <20080920012322R.fujita.tomonori@lab.ntt.co.jp> <20080920060059.GA25713@elte.hu> <20080920225705C.fujita.tomonori@lab.ntt.co.jp> <20080922111730.GF5987@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080922111730.GF5987@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Sep 2008 12:05:19.0715 (UTC) FILETIME=[7BB40330:01C91CAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 01:17:30PM +0200, Ingo Molnar wrote:
> well, i'd like you two to agree on how to proceed. Could you send a 
> patch please that adds back the option that Joerg's patch removed? I 
> certainly dont argue with the point that we should preserve existing 
> options.

I didn't removed any option. I just moved them from GART to the generic
code. I am fine with every solution that keeps iommu=fullflush usable
for AMD IOMMU (except maybe an amd_iommu_parse_options hook in the
generic code like its there for GART).

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

