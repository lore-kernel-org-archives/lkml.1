Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbZHMHhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbZHMHhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZHMHhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:37:54 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:52592 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbZHMHhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VRzUvHV/rAbkzlrAwB/LmPoYs1/0zWoOgflBqCVOI6ZcvIOnT5pFLNqfpbzOlWB69D
         8JyhTY3oEigPaZwifEBgh1Up/gSeNKQ6O/Gbtdc/ah3jd+nqFNKNhU2hg4czRh2+Jf3Z
         z0L8VoqlT1NivGHuHwcMPuqNENAPcu7ZHiOmU=
MIME-Version: 1.0
In-Reply-To: <20090813161407A.fujita.tomonori@lab.ntt.co.jp>
References: <3877989d0908122248s4212ef95w7606a4dca5c7a855@mail.gmail.com>
	 <20090813155118P.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908130003i295cc7f2q343ad2446d0d51ff@mail.gmail.com>
	 <20090813161407A.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 13 Aug 2009 15:37:54 +0800
Message-ID: <3877989d0908130037j5f9b1594q61e51c544a254b68@mail.gmail.com>
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
	failure
From: Luming Yu <luming.yu@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: fenghua.yu@intel.com, dwmw2@infradead.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 3:14 PM, FUJITA
Tomonori<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Thu, 13 Aug 2009 15:03:20 +0800
> Luming Yu <luming.yu@gmail.com> wrote:
>
>> Thanks for another workaround, we should be working on deleting wrong
>> assumption of"iommu_deteced == iommu working", Not just workaround. My
>> patch could break something.. but it is just a start towards right
>> goal..
>
> As I explained, your patch doesn't go toward the right goal.

The goal is to decouple dma_ops init and iommu_detect.
In that sense, my patch is right.

>
> And if you want to fix this problem right now, my workaround patch is
> much better than yours; it doesn't waste 64MB.

My patch needs some fixes to get something back when
assigning intel_dma_ops to dma_ops, since we don't want resource
associated with old dma_ops get lost as you and David pointed out.
Please note just pursuing workaround will end up with more pain
than that being relieved
