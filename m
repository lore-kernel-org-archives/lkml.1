Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbZHMCYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbZHMCYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 22:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZHMCYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 22:24:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:7678 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZHMCYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 22:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ny9tscZm/WFNJvI/QsnuqBJjSanBliHi7wVB2NGVDX5DD2erxqCoDXy3JruYnmtwMH
         D4TLQzZT0HaoBpx/SBItuGYSntbMtQcjXWpUg7X4NVR+KiWShiRprbDxpub6rGgbBi9z
         XBbPLzj+MkxQfsp2dOflpELvbA7FCaZlyr16c=
MIME-Version: 1.0
In-Reply-To: <20090813110948V.fujita.tomonori@lab.ntt.co.jp>
References: <3877989d0908120220q5104d2e7rd272ececbc45e377@mail.gmail.com>
	 <20090813110948V.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 13 Aug 2009 10:24:20 +0800
Message-ID: <3877989d0908121924t1589941fmcd45d3669b78bba4@mail.gmail.com>
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
	failure
From: Luming Yu <luming.yu@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dwmw2@infradead.org, fenghua.yu@intel.com, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 10:11 AM, FUJITA
Tomonori<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Wed, 12 Aug 2009 17:20:11 +0800
> Luming Yu <luming.yu@gmail.com> wrote:
>
>> Hi there,
>>
>> On ia64 platform with dmar table and new upstream
>> kernel(config_dmar_default_on enabled),
>> if intel_iommu_init ends up without dma_ops initialized or other iommu
>> failures.
>> We got nothing to fall back. The following patch fixes it.
>
> Hmm, I think that the current code should work.

Without the patch, I encounters boot failure with the following .config

162-CONFIG_IA64_GENERIC=y
163-# CONFIG_IA64_DIG is not set
164:# CONFIG_IA64_DIG_VTD is not set

> Note that IA64_DIG_VTD doesn't enable SWIOTLB so there is fall
> back. That's kinda the IA64 policy about non IA64_GENERIC kernel.
>
how comes?
