Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbZH2Q2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbZH2Q2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 12:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZH2Q2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 12:28:52 -0400
Received: from mail.lang.hm ([64.81.33.126]:33329 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbZH2Q2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 12:28:51 -0400
Date: Sat, 29 Aug 2009 09:27:32 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: David Woodhouse <dwmw2@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Ric Wheeler <rwheeler@redhat.com>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
In-Reply-To: <20090829100909.GI1634@ucw.cz>
Message-ID: <alpine.DEB.2.00.0908290923130.6822@asgard.lang.hm>
References: <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz>
 <20090825000842.GM17684@mit.edu> <1251362787.4354.373.camel@macbook.infradead.org> <alpine.DEB.2.00.0908280738140.6822@asgard.lang.hm> <20090829100909.GI1634@ucw.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Aug 2009, Pavel Machek wrote:

> On Fri 2009-08-28 07:46:42, david@lang.hm wrote:
>>
>>
>> so what sort of test would be needed to identify if a device has this
>> problem?
>>
>> people can do ad-hoc tests by pulling the devices in use and then
>> checking the entire device, but something better should be available.
>>
>> it seems to me that there are two things needed to define the tests.
>>
>> 1. a predictable write load so that it's easy to detect data getting lose
>>
>> 2. some statistical analysis to decide how many device pulls are needed
>> (under the write load defined in #1) to make the odds high that the
>> problem will be revealed.
>
> Its simpler than that. It usually breaks after third unplug or so.
>
>> for USB devices there may be a way to use the power management functions
>> to cut power to the device without requiring it to physically be pulled,
>> if this is the case (even if this only works on some specific chipsets),
>> it would drasticly speed up the testing
>
> This is really so easy to reproduce, that such speedup is not
> neccessary. Just try the scripts :-).

so if it doesn't get corrupted after 5 unplugs does that mean that that 
particular device doesn't have a problem? or does it just mean you got 
lucky?

would 10 sucessful unplugs mean that it's safe?

what about 20?

we need to get this beyond anecdotal evidence mode, to something that 
(even if not perfect, as you can get 100 'heads' in a row with an honest 
coin) gives you pretty good assurances that a particular device is either 
good or bad.

David Lang
