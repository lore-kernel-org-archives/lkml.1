Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbZHES1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbZHES1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZHES1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:27:00 -0400
Received: from claw.goop.org ([74.207.240.146]:45381 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbZHES07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:26:59 -0400
Message-ID: <4A79CEEC.9030008@goop.org>
Date: Wed, 05 Aug 2009 11:26:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
       Keir Fraser <kier.fraser@eu.citrix.com>, xen-devel@lists.xensource.com,
       Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>
Subject: Re: [Xen-devel] Re: [RFC] Make AGP work with IOMMU
References: <1248707041.6100.35.camel@macbook.infradead.org>	 <21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>	 <1248851712.19733.214.camel@macbook.infradead.org>	 <21d7e9970907290143q6778511cvda1c6b915f61654a@mail.gmail.com>	 <1248860205.19733.238.camel@macbook.infradead.org>	 <4A78C9C6.6010103@goop.org>	 <1249454696.9324.325.camel@macbook.infradead.org> <21d7e9970908042357m6080e88fyeaaad171888766f2@mail.gmail.com>
In-Reply-To: <21d7e9970908042357m6080e88fyeaaad171888766f2@mail.gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/09 23:57, Dave Airlie wrote:
>> All we've done so far is make intel-agp use the DMA API correctly. And
>> that's conditional on CONFIG_DMAR. But we could make it unconditional,
>> and make the other drivers do it too. The code is all fairly generic.
>>
>> Without an IOMMU, the overhead would be fairly minimal.
>>
>>     
>
> I'm not sure how prevalent Xen is on AGP systems, I'm going to guess
> not enough that anyone cares.

What do you mean by AGP here?  Do you mean "machine with physical AGP
port", or "machine with graphics using the AGP aperature"?  There's an
increasing interest in putting Xen on desktop machines, so the former is
debatable, but the latter (I think?) definitely isn't true.

>  Intel integrated chips are the only AGP
> codebase user that are made any more, and they don't really use AGP
> its just a legacy of the previous designs.
>
>   

Plenty of people are using older machines for testing, etc, so I
wouldn't want to exclude them too lightly.  I've got bug reports from
people using older Radeons, etc.

    J
