Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbYHLNpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbYHLNpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYHLNpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:45:23 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51370 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbYHLNpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:45:23 -0400
Date: Tue, 12 Aug 2008 16:43:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, fritz@isdn4linux.de, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] ISDN: make ICN not auto-grab port 0x320
Message-ID: <20080812134337.GG13910@cs181140183.pp.htv.fi>
References: <489DD669.2090207@keyaccess.nl> <20080809215020.1bb602e7@lxorguk.ukuu.org.uk> <20080811164814.db41c20b.akpm@linux-foundation.org> <48A11952.6090203@keyaccess.nl> <20080811223043.9ad55c51.akpm@linux-foundation.org> <20080812130823.GD13910@cs181140183.pp.htv.fi> <48A18F7B.6040809@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48A18F7B.6040809@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 03:26:19PM +0200, Rene Herman wrote:
> On 12-08-08 15:08, Adrian Bunk wrote:
>
>> On Mon, Aug 11, 2008 at 10:30:43PM -0700, Andrew Morton wrote:
>
>>> I think the boot option is the way, if at all.
>>>
>>> Because the config option isn't very usable.  What's to stop someone
>>> from doing `make allyesconfig' and then menually editing the .config so
>>> it's no longer truly an allyesconfig .config?
>>>
>>> otoh, if is't purely a manual setting rather than some automagic thing
>>> then it might be workable.  CONFIG_INGO :)
>>
>> Write the required settings into a file and use KCONFIG_ALLCONFIG.
>
> Found those, but seems unable to express the "depends on BROKEN_BOOT if  
> FOO=y" method that's currently used.
>
> Yes, might admittedly not be considered a huge problem and perhaps we  
> could just ship an allyes.config (and same allrandom.config) but it's  
> not nice to spread information about a single symbol over various files  
> like that.

The dependencies we express in kconfig are already pretty complicated, 
and that is continuously causing problems.

Stuffing more stuff into kconfig for such an exotic developer-only use 
case is not a good idea.

And as already said, tomorrow someone might want to boot an allyesconfig 
kernel on a Pentium-MMX...

> Currently, we have a tristate that turns into a y/n bool if !MODULES.  
> What would be real nice here is a tristate that turns into a m/n bool if  
> !RANDOM, where allyesconfig and randconfig would pre-select RANDOM.

allyesconfig is not random.

> If I'm not mistaken, that's currently not possible...
> 
> Rene

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

