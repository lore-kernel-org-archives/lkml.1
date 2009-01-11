Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbZAKHCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbZAKHCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 02:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbZAKHCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 02:02:14 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:36982 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZAKHCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 02:02:13 -0500
Message-ID: <49699954.9090505@knaff.lu>
Date: Sun, 11 Jan 2009 08:01:40 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] bzip2/lzma kernel compression
References: <200901091845.n09IjBsT003630@terminus.zytor.com> <4968A737.7040909@knaff.lu> <49693E70.4050303@zytor.com>
In-Reply-To: <49693E70.4050303@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Alain Knaff wrote:
>> But now I am curious how this will evolve from here. I suppose it will
>> soon appear in one of the patch-2.6.28-gitxy.gz under
>> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots , and then in an
>> 2.6.29-rcx etc.
>> Or are there some more other steps involved in between?
>>
> 
> Well, Linus opted not to merge it for 2.6.29-rc1, which means it is dead
> for this merge cycle.

Too bad :(

For when is the next merge window scheduled (approximatively...)?

What impact does this have on procedure for supplying updates to it?
Indeed, I've got a couple of new features in the pipeline that I'd like
to add in the new future:
 - centralizing the switch of kernel compression in a common place (will
make it easier to add new compressions once all architectures support
the new scheme, without the need of touching all of them).
 - support for new LZMA variant with "real" magic numbers
 - support for "no kernel compression" option (people have asked me for
this for the case where they have a boot loader that already handles
decompression)

>  This gives us a couple of options, with the aim
> to get it merged into 2.6.30:
> 
> - We can continue to carry it in the -tip tree, which also means it will
>   be in the linux-next tree.
> - We can push it to Andrew Morton for the -mm tree.
> - Sam could take it in his kbuild tree.

What are the advantages and disadvantages of each of those? Personally,
I'd prefer a choice that:
 - allows the most lightweight procedure for updating it (i.e. allows to
supply incremental changes, rather than do a "full" release)
 - is most visible (so that when people ask me for it, I can for example
tell them "it's already in the -mm tree, download it from xxx". Oh, and
visibility will give it also more test exposure)

> Out of these, I think the kbuild tree is entirely inappropriate.  The
> selection of the other two is mostly a matter of testing, and which way
> will be easier to add the ARM code and other arch support.

Well ease of merging the ARM code in is obviously also a consideration
to take into account.

> 
> 	-hpa
> 

Regards,

Alain
