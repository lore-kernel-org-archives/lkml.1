Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZHZLal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZHZLal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbZHZLak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:30:40 -0400
Received: from mail.lang.hm ([64.81.33.126]:48854 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773AbZHZLaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:30:39 -0400
Date: Wed, 26 Aug 2009 04:29:42 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: Rik van Riel <riel@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
In-Reply-To: <20090826111751.GC26595@elf.ucw.cz>
Message-ID: <alpine.DEB.2.00.0908260428310.30426@asgard.lang.hm>
References: <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz>
 <4A932B18.1020209@redhat.com> <20090825093414.GB15563@elf.ucw.cz> <4A94ACDF.30405@redhat.com> <20090826111751.GC26595@elf.ucw.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Pavel Machek wrote:

> On Tue 2009-08-25 23:32:47, Rik van Riel wrote:
>> Pavel Machek wrote:
>>
>>>> So, would you be happy if ext3 fsck was always run on reboot (at
>>>> least  for flash devices)?
>>>
>>> For flash devices, MD Raid 5 and anything else that needs it; yes that
>>> would make me happy ;-).
>>
>> Sorry, but that just shows your naivete.
>>
>> Metadata takes up such a small part of the disk that fscking
>> it and finding it to be OK is absolutely no guarantee that
>> the data on the filesystem has not been horribly mangled.
>>
>> Personally, what I care about is my data.
>>
>> The metadata is just a way to get to my data, while the data
>> is actually important.
>
> Personally, I care about metadata consistency, and ext3 documentation
> suggests that journal protects its integrity. Except that it does not
> on broken storage devices, and you still need to run fsck there.

as the ext3 authors have stated many times over the years, you still need 
to run fsck periodicly anyway.

what the journal gives you is a reasonable chance of skipping it when the 
system crashes and you want to get it back up ASAP.

David Lang

> How do you protect your data is another question, but ext3
> documentation does not claim journal to protect them, so that's up to
> the user I guess.
> 									Pavel
>
