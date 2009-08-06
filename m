Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbZHFTcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbZHFTcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbZHFTcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:32:24 -0400
Received: from claw.goop.org ([74.207.240.146]:52813 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528AbZHFTcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:32:23 -0400
Message-ID: <4A7B2FC6.9070104@goop.org>
Date: Thu, 06 Aug 2009 12:32:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: xen-devel@lists.xensource.com, Zhenyu Wang <zhenyu.z.wang@intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       Keir Fraser <kier.fraser@eu.citrix.com>
Subject: Re: [Xen-devel] Re: [RFC] Make AGP work with IOMMU
References: <1248707041.6100.35.camel@macbook.infradead.org>	<21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>	<1248851712.19733.214.camel@macbook.infradead.org>	<21d7e9970907290143q6778511cvda1c6b915f61654a@mail.gmail.com>	<1248860205.19733.238.camel@macbook.infradead.org>	<4A78C9C6.6010103@goop.org>	<1249454696.9324.325.camel@macbook.infradead.org>	<21d7e9970908042357m6080e88fyeaaad171888766f2@mail.gmail.com>	<4A79CEEC.9030008@goop.org> <21d7e9970908051612v140c2ebfu591e8fe817237889@mail.gmail.com>
In-Reply-To: <21d7e9970908051612v140c2ebfu591e8fe817237889@mail.gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/09 16:12, Dave Airlie wrote:
> My main problem with doing this is getting testing coverage on older
> systems, if we change all the AGP drivers, the time to find we busted
> something is probably not until the next major distro release with this code
> in it. So people can run stuff on 5 year old hardware in 6 months? I'm
> not sure the gains justify the costs, but if you guys really want to do it
> I'll take the patch, just be prepared to have it ripped out the minute
> we get a regression we can't figure out because we haven't got the hw anymore.
>   

Can you point to some changesets/patches to act as an example/template
for the changes needed?

If we come up with someone reporting crashes when using old hardware, we
can then make change then get them to test both native and Xen.

    J
