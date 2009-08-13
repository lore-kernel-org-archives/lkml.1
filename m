Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZHMIvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZHMIvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbZHMIvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:51:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:57652 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbZHMIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uGr2LHstdojtg/TQLvA24ASaGDmgirKIHuWfi0mVwh5fW72yt+SJhwx1EtXqKQlrG4
         RweEmBuvtaxxs8yyvZ9aqip3cTE4glUUgrih2/jw1nHJg4HBFQrMBLatozoQZQXCaNpa
         2bOkLDSwH+Lv453ylfPev3slTlca1OdTmyAeE=
MIME-Version: 1.0
In-Reply-To: <1250151801.29180.192.camel@macbook.infradead.org>
References: <3877989d0908122011n27589ff8wfc6d6b50912496c6@mail.gmail.com>
	 <1250151801.29180.192.camel@macbook.infradead.org>
Date: Thu, 13 Aug 2009 16:51:25 +0800
Message-ID: <3877989d0908130151l58a73c8cy77791e8e466280bf@mail.gmail.com>
Subject: Re: [RFC patch] clean up swiotlb check in intel_iommu_init
From: Luming Yu <luming.yu@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 4:23 PM, David Woodhouse<dwmw2@infradead.org> wrote:
> On Thu, 2009-08-13 at 11:11 +0800, Luming Yu wrote:
>>
>> Since swiotlb is an fall back option that might have
>> initialized. We don't need to stop intel_iommu_init
>> because of swiotlb..
>>
>> Please review. If make sense, please apply.
>
> It doesn't apply to the iommu-2.6.git tree.

The patch is against 31-rc5.

If you were not using the attached patch, then I need to use another
mail client to re-send the patch to you. But it is not as convenient
as web gmail
that I'm current using...

If I must generate patch against iommu-2.6.git tree, please point out
the url of that tree,
I can refresh this patch later.

Please let me know what I should do to push this patch in..
