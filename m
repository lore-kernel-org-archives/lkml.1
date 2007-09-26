Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbXIZLbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbXIZLbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbXIZLbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:31:35 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:33321 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070AbXIZLbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:31:34 -0400
Message-ID: <46FA4313.1060201@Arcor.de>
Date: Wed, 26 Sep 2007 13:31:31 +0200
From: Henry Nestler <Henry.Ne@Arcor.de>
User-Agent: Thunderbird 1.5.0.13 (X11/20070809)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: kbuild: LDFLAGS_MODULE unusable for external module builds (2.6.23-rc2)
References: <46F8D9B8.3090806@Arcor.de> <20070925192250.GA14689@uranus.ravnborg.org> <46FA2CC0.2000204@Arcor.de> <20070926110130.GA20950@uranus.ravnborg.org>
In-Reply-To: <20070926110130.GA20950@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

Sam Ravnborg wrote:
>>>> What macro should set for linker parameters of foo.o ? I'm not shure.
>>> Have you read:
>>> Documentation/kbuild/makfilefiles.txt?
>> Yes. This was a *very* helpfull. And many examples spokes about 
>> LDFLAGS_$@ there. Not directly described for modules.
> 
> Took a deeper look.
> I saw one reference to LDFLAGS_$@ that is wrong:
>     LDFLAGS             Generic $(LD) options
> 
>         Flags used for all invocations of the linker.
>         Often specifying the emulation is sufficient.
> 
>         Example:
>                 #arch/s390/Makefile
>                 LDFLAGS         := -m elf_s390
>         Note: EXTRA_LDFLAGS and LDFLAGS_$@ can be used to further customise
>         the flags used. See chapter 7.
> 
> The chapter reference is also bad...
> The other references to the LDFLAGS_$@ are in other situations - it is
> used in several places.
> 
> If your example requires the LDFALGS_$@ I wil introduce it - for now
> it has not been required (except for vdso support where it was hacked).

I will check EXTRA_LDFLAGS compatibilities with older kernel versions. 
Than I come back with results. Currently I no need LDFLAGS_$@.

-- 
Henry

