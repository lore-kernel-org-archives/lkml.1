Return-Path: <linux-kernel-owner+w=401wt.eu-S933618AbZHDXwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbZHDXwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 19:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932449AbZHDXwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 19:52:40 -0400
Received: from claw.goop.org ([74.207.240.146]:37206 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435AbZHDXwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 19:52:39 -0400
Message-ID: <4A78C9C6.6010103@goop.org>
Date: Tue, 04 Aug 2009 16:52:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Dave Airlie <airlied@gmail.com>, Keir Fraser <kier.fraser@eu.citrix.com>,
       xen-devel@lists.xensource.com, Joerg Roedel <joerg.roedel@amd.com>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Zhenyu Wang <zhenyu.z.wang@intel.com>
Subject: Re: [Xen-devel] Re: [RFC] Make AGP work with IOMMU
References: <1248707041.6100.35.camel@macbook.infradead.org>	<21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>	<1248851712.19733.214.camel@macbook.infradead.org>	<21d7e9970907290143q6778511cvda1c6b915f61654a@mail.gmail.com> <1248860205.19733.238.camel@macbook.infradead.org>
In-Reply-To: <1248860205.19733.238.camel@macbook.infradead.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/09 02:36, David Woodhouse wrote:
> On Wed, 2009-07-29 at 18:43 +1000, Dave Airlie wrote:
>   
>>>> don't suppose we want page_to_gart or is the double function nicer?
>>>>         
>>> I pondered that briefly. But then observed that phys_to_gart() and
>>> gart_to_phys() _always_ describe an identity mapping, so perhaps they
>>> could just be ditched completely?
>>>       
>> Yeah that could work too, no idea why they were introduced, well before my time.
>>     
>
> http://git.infradead.org/users/dwmw2/iommu-agp.git?a=commitdiff;h=8bf2f3a9
>
> It was introduced by Keir in 2005 for Xen (commit 07eee78e). I suspect
> it can die though, and that the right answer there is also to use the
> DMA API correctly.
>   

And just when I have patches to use them for their original purpose...

Looking back over the thread, are you saying that most users are already
using the DMA API correctly for AGP accesses?  If that's true then we
should be just fine.

    J
