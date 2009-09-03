Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZICNvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZICNvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZICNvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:51:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbZICNvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:51:52 -0400
Message-ID: <4A9FC9B3.1080809@redhat.com>
Date: Thu, 03 Sep 2009 09:50:43 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
       Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
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
References: <20090828064449.GA27528@elf.ucw.cz>	<20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>	<alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>	<4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru>	<20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>	<20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca>	<20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com>	<m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com> <m3ljkwnoct.fsf@intrepid.localdomain>
In-Reply-To: <m3ljkwnoct.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2009 09:34 AM, Krzysztof Halasa wrote:
> Ric Wheeler<rwheeler@redhat.com>  writes:
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

Storage vendors have a wide range of options, but what you get today is a 
collection of s-ata (not much any more), sas or fc.

Some times they will have different firmware, other times it is the same.


>
> Are they SATA (or PATA) at all? SCSI etc. are usually different
> animals, though there are SCSI and SATA models which differ only in
> electronics.
>
> Do you have battery-backed write-back RAID cache (which acknowledges
> flushes before the data is written out to disks)? PC can't do that.

We (red hat) have all kinds of different raid boxes...

ric


