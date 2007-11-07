Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbXKGD3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbXKGD3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbXKGD24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:28:56 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53084 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754232AbXKGD2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:28:55 -0500
Date: Wed, 7 Nov 2007 04:28:31 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Bryan Wu <cooloney.lkml@gmail.com>
Cc: bryan.wu@analog.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] blackfin: remove dump_thread()
Message-ID: <20071107032831.GW26163@stusta.de>
References: <20071105170750.GW12045@stusta.de> <386072610711061907q7809db9ct51d00fe2d6ec6c6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <386072610711061907q7809db9ct51d00fe2d6ec6c6b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 11:07:06AM +0800, Bryan Wu wrote:
> On 11/6/07, Adrian Bunk <bunk@kernel.org> wrote:
> > This patch removes the unused dump_thread().
> >
> 
> Why only remove it from Blackfin? any more reason?

The only user is the a.out support.

It was therefore removed prior to the blackfin merge from all 
architectures not supporting a.out.

> I found this in latest 2.6.24-rc2:
> 
> --
> Cscope tag: dump_thread
>    #   line  filename / context / line
>    1    324  arch/alpha/kernel/process.c <<dump_thread>>
>              dump_thread(struct pt_regs * pt, struct user * dump)
>    2    373  arch/arm/kernel/process.c <<dump_thread>>
>              void dump_thread(struct pt_regs * regs, struct user * dump)
>    3    244  arch/blackfin/kernel/process.c <<dump_thread>>
>              void dump_thread(struct pt_regs *regs, struct user *dump)
>    4    321  arch/m68k/kernel/process.c <<dump_thread>>
>              void dump_thread(struct pt_regs * regs, struct user * dump)
>    5    572  arch/sparc/kernel/process.c <<dump_thread>>
>              void dump_thread(struct pt_regs * regs, struct user * dump)
>    6    731  arch/sparc64/kernel/process.c <<dump_thread>>
>              void dump_thread(struct pt_regs * regs, struct user * dump)
>    7    306  arch/um/kernel/process.c <<dump_thread>>
>              void dump_thread(struct pt_regs *regs, struct user *u)
>    8    519  arch/x86/kernel/process_32.c <<dump_thread>>
>              void dump_thread(struct pt_regs * regs, struct user * dump)
> --
> 
> Regards,
> -Bryan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

