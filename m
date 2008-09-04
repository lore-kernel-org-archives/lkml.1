Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYIDXxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYIDXxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYIDXxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:53:23 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:65027 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYIDXxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:53:22 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=UEMkdL0Iya308K3d4MYA:9 a=KGq9vVGknX1UUxlka3rd2b_2PT4A:4 a=qM0ISud-tAQA:10 a=9ewnkyRNkm8A:10 a=zxGsKk2h-DUA:10
Message-ID: <48C074EF.6090209@shaw.ca>
Date: Thu, 04 Sep 2008 17:53:19 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: joro@8bytes.org, linux-kernel@vger.kernel.org, tony.luck@intel.com,
       iommu@lists.linux-foundation.org, mingo@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/3] x86: remove the NULL device hack in dma-mapping.h
References: <fa.Tx5o9n5qXlTiaMQNn2gICqrkVUA@ifi.uio.no> <fa.RE+bYfvoWz/5NCC06intia3OFmo@ifi.uio.no> <fa.kdqbjaJP+Pja+TaKDb/G9J79BTA@ifi.uio.no> <fa.3x55VLi/XqDV2PUAW3SsqCnCKh4@ifi.uio.no>
In-Reply-To: <fa.3x55VLi/XqDV2PUAW3SsqCnCKh4@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 3 Sep 2008 22:01:14 +0200
> Joerg Roedel <joro@8bytes.org> wrote:
> 
>> On Thu, Sep 04, 2008 at 03:04:23AM +0900, FUJITA Tomonori wrote:
>>> +static void *x86_swiotlb_alloc_coherent(struct device *dev, size_t size,
>>> +					dma_addr_t *dma_handle, gfp_t gfp)
>>> +{
>>> +	if (!dev) {
>>> +		dev = &x86_dma_fallback_dev;
>>> +		gfp |= GFP_DMA;
>>> +	}
>> This really should be checked in the generic x86 dma_alloc_coherent
>> function.
> 
> I don't think so. Any motherboards with the recent IOMMUs support ISA?

Probably some LPC devices on those boards..
