Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbXKFB3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbXKFB3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 20:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbXKFB3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 20:29:41 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39844 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754507AbXKFB3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 20:29:41 -0500
Date: Tue, 6 Nov 2007 02:29:16 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roland Dreier <rdreier@cisco.com>,
       Christoph Hellwig <hch@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] replace "make ARCH=i386/x86_64 with make ARCH=x86"
Message-ID: <20071106012916.GE3444@stusta.de>
References: <20071103234826.GA26654@uranus.ravnborg.org> <20071105104129.GB3662@infradead.org> <20071105171740.GA29481@uranus.ravnborg.org> <adafxzkbcid.fsf@cisco.com> <20071105214937.GA31496@uranus.ravnborg.org> <472FAB4C.9040303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <472FAB4C.9040303@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 03:46:20PM -0800, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
>> On Mon, Nov 05, 2007 at 01:36:42PM -0800, Roland Dreier wrote:
>>>  > Like this:
>>>  > $ make ARCH=foo
>>>  > Makefile:201: *** "ERROR: ARCH (foo) does not exist".  Stop.
>>>
>>> Seems sane, but maybe it would be worth putting in a special case
>>> check for someone using i386 or x86_64 for ARCH, and tell them to
>>> switch to x86?
>>
>> Will do so if my patchset gets applied. Need to redo it but
>> that will be later this week and then I hope for a bit more
>> feedback from the x86 guys.
>
> The patchset has looked good to me, and I believe it would be better to 
> take this particular breakage sooner rather than later.
>
> I haven't spoken up actively mostly because I wanted to look at the user 
> comments as they have been coming in.
>
> The issue with "make allyesconfig" concerns me, although the same situation 
> already exists with any multiple-choice configuration.  What I guess we 
> really want is to be able to specify a few specific choices.

It's already available:

$ cat myconfig
CONFIG_HIGHMEM64G=y
CONFIG_SMP=n
CONFIG_PCI=n
CONFIG_IPV6=m
$ make allyesconfig KCONFIG_ALLCONFIG=myconfig

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

