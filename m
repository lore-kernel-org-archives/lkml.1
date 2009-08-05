Return-Path: <linux-kernel-owner+w=401wt.eu-S933577AbZHEG5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577AbZHEG5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933070AbZHEG5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:57:51 -0400
Received: from mail-yw0-f177.google.com ([209.85.211.177]:46789 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966AbZHEG5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:57:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dAN36slg6zE6GChHr1Gn+0JX/fdEiHV6AFh9BGa2Taftq13Ftyoqv3c1PlyRRDsVr3
         8RWA+152Z6WNVeGapqjE3zBhlZFsXymS2CbkzxoWrvL+JhvCCtX3CviTAMh0gWOGAABj
         JSpV+ZLJ3gE8jAptFt3UOIq8dOT1B6BEUXVgE=
MIME-Version: 1.0
In-Reply-To: <1249454696.9324.325.camel@macbook.infradead.org>
References: <1248707041.6100.35.camel@macbook.infradead.org>
	 <21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>
	 <1248851712.19733.214.camel@macbook.infradead.org>
	 <21d7e9970907290143q6778511cvda1c6b915f61654a@mail.gmail.com>
	 <1248860205.19733.238.camel@macbook.infradead.org>
	 <4A78C9C6.6010103@goop.org>
	 <1249454696.9324.325.camel@macbook.infradead.org>
Date: Wed, 5 Aug 2009 16:57:51 +1000
Message-ID: <21d7e9970908042357m6080e88fyeaaad171888766f2@mail.gmail.com>
Subject: Re: [Xen-devel] Re: [RFC] Make AGP work with IOMMU
From: Dave Airlie <airlied@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Keir Fraser <kier.fraser@eu.citrix.com>, xen-devel@lists.xensource.com,
       Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 5, 2009 at 4:44 PM, David Woodhouse<dwmw2@infradead.org> wrote:
> On Tue, 2009-08-04 at 16:52 -0700, Jeremy Fitzhardinge wrote:
>> And just when I have patches to use them for their original purpose...
>>
>> Looking back over the thread, are you saying that most users are already
>> using the DMA API correctly for AGP accesses?  If that's true then we
>> should be just fine.
>
> No, not 'most users'. But perhaps we should.
>
> All we've done so far is make intel-agp use the DMA API correctly. And
> that's conditional on CONFIG_DMAR. But we could make it unconditional,
> and make the other drivers do it too. The code is all fairly generic.
>
> Without an IOMMU, the overhead would be fairly minimal.
>

I'm not sure how prevalent Xen is on AGP systems, I'm going to guess
not enough that anyone cares. Intel integrated chips are the only AGP
codebase user that are made any more, and they don't really use AGP
its just a legacy of the previous designs.

Dave.
