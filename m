Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbZICOgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbZICOgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZICOgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:36:15 -0400
Received: from mail.lang.hm ([64.81.33.126]:59470 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZICOgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:36:14 -0400
Date: Thu, 3 Sep 2009 07:35:14 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Mark Lord <lkml@rtr.ca>, Michael Tokarev <mjt@tls.msk.ru>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
In-Reply-To: <m3ljkwnoct.fsf@intrepid.localdomain>
Message-ID: <alpine.DEB.2.00.0909030732560.6822@asgard.lang.hm>
References: <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm> <4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru> <20090830163513.GA25899@infradead.org>
 <4A9BCCEF.7010402@redhat.com> <20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca> <20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com> <m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com>
 <m3ljkwnoct.fsf@intrepid.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Sep 2009, Krzysztof Halasa wrote:

> Ric Wheeler <rwheeler@redhat.com> writes:
>
>>>> Just to add some support to this, all of the external RAID arrays that
>>>> I know of normally run with write cache disabled on the component
>>>> drives.
>>>
>>> Do they use "off the shelf" SATA (or PATA) disks, and if so, which ones?
>>
>> Which drives various vendors ships changes with specific products.
>> Usually, they ship drives that have carefully vetted firmware, etc.
>> but they are close to the same drives you buy on the open market.
>
> But they aren't the same, are they? If they are not, the fact they can
> run well with the write-through cache doesn't mean the off-the-shelf
> ones can do as well.

frequently they are exactly the same drives, with exactly the same 
firmware.

you disable the write caches on the drives themselves, but you add a large 
write cache (with battery backup) in the raid card/chassis

> Are they SATA (or PATA) at all? SCSI etc. are usually different
> animals, though there are SCSI and SATA models which differ only in
> electronics.

it depends on what raid array you use, some use SATA, some use SAS/SCSI

David Lang
