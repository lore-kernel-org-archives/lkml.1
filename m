Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbXFOQzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbXFOQzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbXFOQza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:55:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36153 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753607AbXFOQz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:55:29 -0400
Date: Fri, 15 Jun 2007 18:55:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Linux Servers comparison with Windows 2003 servers for Gaming
Message-ID: <20070615165542.GH3588@stusta.de>
References: <8d6898730706150712u182f5af1h2d92030adf16d022@mail.gmail.com> <20070615152313.3638b4d5@the-village.bc.nu> <4672A3AA.6010705@mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4672A3AA.6010705@mandic.com.br>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 11:35:22AM -0300, Renato S. Yamane wrote:
> Alan Cox wrote:
>> On Fri, 15 Jun 2007 19:42:50 +0530
>>> How much better performance i will get?
>> How long is a piece of string. Given you don't give any hardware info,
>> any info on the applications run or on the network and capacity expected
>> its a bit hard to guess really.
>
> Detail: I think that is a good idea if hard-users (as kernel developers) 
> had a local to host yours .config file, specifying hadware.
>
> E.g. I have a laptop Toshiba M45-S355 (with ReiserFS) and don't have 
> experience to choose what I can remove from kernel (or compile as 
> module/built-in).
>
> So, is a great idea use pre-config file to compile a new kernel with best 
> options.
>
> My .config file (2.6.21.1) and lspci is attached.

CONFIG_DEBUG_KERNEL=n (as set in your .config) should be the one setting 
that is important for performance - enabling it offers debug options, 
and some of them can significantly influence the performance.

Other options might influence the size and very slightly the speed of 
the kernel, but not in any noticable way (except when you disable a 
driver required for your hardware).

E.g. it even wouldn't matter if your kernel would be smaller by 1 MB and 
faster by 1%.

The best solution for users like you is to use a distribution kernel and 
the distribution autodetecting all hardware and automatically loading 
all drivers you might need.

> Best regards,
> Renato S. Yamane

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

