Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZGFWFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZGFWFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 18:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZGFWF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 18:05:27 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:38156 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbZGFWF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 18:05:26 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2009 18:05:25 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=OioMGb+SFL108klIcjSDGeVu4iQI8uwF40jQ4h5zJ+nY42fBZCV8nBFbuvUfqXdLHu
         +S2yQY83jFmsukmyonh7gWe/23hbxtVN0Nr5HyTwD3Q4h2SzBdpwNO2flhQJ1Z3aR+cC
         MspkyJUBkXXaA/opGG/Xh+e/Qj0H5aIbMFvIQ=
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>  <20090507100114.GF4059@amd.com>  <1241691721.3531.73.camel@macbook.infradead.org>  <20090507.113632.210373283.davem@davemloft.net>  <20090508093526.GB13708@8bytes.org>  <1246883177.2615.33.camel@macbook.infradead.org> <20090706131156.GL5380@amd.com> <1246889932.2615.81.camel@macbook.infradead.org> <alpine.DEB.2.00.0907062232350.5769@skynet.skynet.ie>
Message-Id: <0DDD3FAD-969A-421B-A36A-77AB645E8BCA@gmail.com>
From: Dave Airlie <airlied@gmail.com>
To: Dave Airlie <airlied@linux.ie>
In-Reply-To: <alpine.DEB.2.00.0907062232350.5769@skynet.skynet.ie>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7A341)
Mime-Version: 1.0 (iPhone Mail 7A341)
Subject: Re: IOMMU and graphics cards
Date: Tue, 7 Jul 2009 08:00:01 +1000
Cc: David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joerg.roedel@amd.com>,
       Joerg Roedel <joro@8bytes.org>, Zhenyu Wang <zhenyu.z.wang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       David Miller <davem@davemloft.net>, "eric@anholt.net" <eric@anholt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/07/2009, at 7:35, Dave Airlie <airlied@linux.ie> wrote:

>
>
> On Mon, 6 Jul 2009, David Woodhouse wrote:
>
>> On Mon, 2009-07-06 at 15:11 +0200, Joerg Roedel wrote:
>>> Ok, cool, that sounds good. Which in-kernel DRM drivers break with  
>>> IOMMU
>>> for you? I'll may probably add a similar temporary workaround for  
>>> AMD
>>> IOMMU too...
>>
>> The Intel one definitely broke -- I don't know about the others.  
>> There
>> are some old patches at http://people.freedesktop.org/~zhen/agp-mm-*
>> which make it look like _all_ AGP drivers are broken.
>>
>> I wouldn't bother adding the workaround -- as I said, I'm planning to
>> rip it out of 2.6.32 (and in linux-next as soon as it's reasonable  
>> to do
>> so). Let's just let them fix it.
>
> cc'ing Eric,
>
> My memory of this is graphics becomes totally useless and can be  
> 10x-50x
> slower. I think ripping this out without the person doing the ripping
> taking responsiblity for doing speed regression testing is totally  
> insane.
>
> I personally have no IOMMU hw from Intel or AMD and nobody has seen  
> it fit
> to supply me with any at any point in time, I'm not on the correct  
> gravy
> train. So I suspect the people with the hw will have to do the work  
> and
> the regression testing.

Could you also enumerate any limitations of the IOMMUs on the amount  
of memory they can remap per device if any.

Dave

> Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
