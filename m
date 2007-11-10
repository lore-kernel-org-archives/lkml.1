Return-Path: <linux-kernel-owner+w=401wt.eu-S1763568AbXKJDu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763568AbXKJDu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 22:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbXKJDuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 22:50:50 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36134 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750813AbXKJDut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 22:50:49 -0500
Date: Sat, 10 Nov 2007 04:50:25 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Message-ID: <20071110035025.GI26163@stusta.de>
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4735242B.1010801@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 10:23:23PM -0500, Jeff Garzik wrote:
> Sam Ravnborg wrote:
>> This is the patch that get rid of ARCH=i386 and ARCH=x86_64
>> and introduce ARCH=x86.
>> It touches several files but the changes are all one or two-liners.
>>
>>       x86: drop backward compatibility symlinks to i386/boot and x86_64/boot
>>       kbuild: sanity check the specified arch
>
>
> IMO it negatives impacts the workflow when you -remove- the ability to set 
> 32/64-bit on the make command line.
>
> Building and testing for both architectures now requires the additional 
> step of editing .config, which is a clear workflow negative impact at least 
> for me.
>
> I switch between other cross-compiled arches (alpha, usually) on the 
> makefile command line
>
> Yes, I know other 32/64-bit arches require .config editing.  That doesn't 
> change the basic fact that this is a workflow regression.

With KCONFIG_ALLCONFIG you can avoid the editing of the .config and set 
32/64-bit on the make command line - and it's not limited to the 
32/64-bit choice:

$ cat /home/jeff/myi386config
CONFIG_HIGHMEM64G=y
CONFIG_X86_32=y 
CONFIG_SMP=n
CONFIG_PCI=n
CONFIG_IPV6=m
$ make allyesconfig KCONFIG_ALLCONFIG=/home/jeff/myi386config

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

