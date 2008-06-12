Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYFLRjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYFLRjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYFLRjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:39:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:27382 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYFLRjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qHyydjVYErCwMMrvCaPBLx+xpYG1RgS1SQFs2bMoFwqzLYyHDMj1ZUzD/ha/EBQlIp
         gPdj+SyNMm6J/aRwKDYTzzjV00ibPEAlqR36G+qg8wOIzuzvMLS2OWLVouNBt1oylHxo
         WDt3E5i1UoktPrAgVYZXWNYJtn0yT9CleLIR0=
Message-ID: <1ba2fa240806121039o376b0a8sdfaacf3a1f4a9e57@mail.gmail.com>
Date: Thu, 12 Jun 2008 20:39:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Rik van Riel" <riel@redhat.com>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <1213290335.3730.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <1ba2fa240806120935r54a080eci7fa6fafc718eed17@mail.gmail.com>
	 <1213290335.3730.4.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 8:05 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > Probably. it would be safe to use vmalloc for allocating txb anyway.
>> > I'll give it a try.
>>
>> So vmalloc  didn't break anything on the 32bit machine I'm just about
>> to install 64 one so it will take hour or two.. I will issue some
>> official patch after that.
>
> Well, I disagree, and I'll push my patch as soon as somebody confirms
> that it doesn't break anything.

Remember you are not a maintainer of this driver and second we are
open to all suggestions you don't have to use this kind of
statements...

>
>> > There was already discussion on LKML about memory allocation problems
>> > on X86_64, which might explain this regression. This didn't happen
>> > before.
>>
>> This is  the thread title if you are interested.
>> 'x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY'
>
> Like I said, it doesn't matter, there's no need to _waste_
> 18*256*sizeof(void *) bytes memory.

It does matter this is not pci allocation we are saving in your patch.

> johannes
>
