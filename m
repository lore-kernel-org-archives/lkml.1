Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYBRIsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYBRIsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbYBRIsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:48:47 -0500
Received: from hs-out-0708.google.com ([64.233.178.249]:15570 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbYBRIsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:48:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xuFsOjjfHXTXBs/DREfOaZp6s58FihYOlAbsEaD9AxCMfspphS/plosP8SmUXOQ1i05OvW63tTUvptyAabWwQ38ScbtZgxHGtfE8jsH/A58bP6Bc0/TpK/+H1I4BEYUc+A3+1GNGGsNpKjoWDQMv3ufoQAw4hCbnltnW55YfpU8=
Message-ID: <4d8e3fd30802180048o39790aedwde2ef1cbb009363e@mail.gmail.com>
Date: Mon, 18 Feb 2008 09:48:44 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: Coding style fixes for arch/x86/kernel/cpu/centaur.c
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080218025645.GB30201@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080217233023.26764dc9@paolo-desktop>
	 <20080218025645.GB30201@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18, 2008 3:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
> > [PATCH] x86: Coding style fixes for arch/x86/kernel/cpu/centaur.c
> >
> > Kills more than 150 errors/warnings
>
> thanks Paolo, applied. This file was _really_ unclean.

You are welcome. Kudos to your quality script ;-)

> btw., there were more style inconsistencies in this file, some of which
> were reported by checkpatch.pl - the patch below (ontop of yours) fixes
> them. Feel free to do such type of changes in future cleanup patches.
> Some of them are real CodingStyle problems, some of them are just
> arbitrary taste details. Now the file looks very clean in all of its
> details, and is completely checkpatch.pl --file clean as well. (If any
> of the changes i did is unclear, please ask.)

>  /*
> - *     Set up an actual MCR
> + * Set up an actual MCR
>   */

This was not highlighted by checkpatch.pl, right?
The same applies for a few other "fix" you did on some comments.

[...]
>  {
> -       u32 mem = ramtop();
>         u32 root = power2(mem);
> +       u32 mem = ramtop();

Can you please explain the rationale behind this change?

[...]
>
> +enum {
> +               ECX8            = 1<<1,
> +               EIERRINT        = 1<<2,
> +               DPM             = 1<<3,
> +               DMCE            = 1<<4,
> +               DSTPCLK         = 1<<5,
> +               ELINEAR         = 1<<6,
> +               DSMC            = 1<<7,
> +               DTLOCK          = 1<<8,
> +               EDCTLB          = 1<<8,
> +               EMMX            = 1<<9,
> +               DPDC            = 1<<11,
> +               EBRPRED         = 1<<12,
> +               DIC             = 1<<13,
> +               DDC             = 1<<14,
> +               DNA             = 1<<15,
> +               ERETSTK         = 1<<16,
> +               E2MMX           = 1<<19,
> +               EAMD3D          = 1<<20,
> +};
> +
>  static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
>  {
> -       enum {
> -               ECX8 = 1<<1,
> -               EIERRINT = 1<<2,
> -               DPM = 1<<3,
> -               DMCE = 1<<4,
> -               DSTPCLK = 1<<5,
> -               ELINEAR = 1<<6,
> -               DSMC = 1<<7,
> -               DTLOCK = 1<<8,
> -               EDCTLB = 1<<8,
> -               EMMX = 1<<9,
> -               DPDC = 1<<11,
> -               EBRPRED = 1<<12,
> -               DIC = 1<<13,
> -               DDC = 1<<14,
> -               DNA = 1<<15,
> -               ERETSTK = 1<<16,
> -               E2MMX = 1<<19,
> -               EAMD3D = 1<<20,
> -       };

I see why you did the cleanup but I think even this part was not
catched by checkpatch.pl

>

Ok, I got all your cleanup. I just need to compare your work with the relative
checkpatch.pl output, in the past it happened that the error/warning
messages were not
very clear so I agreed with Andy about a couple of changes.

Thanks.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
