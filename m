Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbXKGDjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbXKGDjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXKGDjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:39:14 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:28908 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbXKGDjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:39:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X6VNTQXbDJDHzwdZzOcwwwGOyvmexK/4kWcXVcH+phA3Gg0xnMtpaJ2BTtYjzIYODVvUOud1SIRTQHBDXdhY0KAgjMmTFXsEDjYodL2DpTu9sEdz5yoykuYJsd61Kik485pEpu4B2B1yh2lyqNTn6xDCapmhwmHrOdb0LI+GJcI=
Message-ID: <386072610711061939j66e89f95s59e4e4ab4cbdbee9@mail.gmail.com>
Date: Wed, 7 Nov 2007 11:39:12 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] blackfin: remove dump_thread()
Cc: bryan.wu@analog.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071107032831.GW26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071105170750.GW12045@stusta.de>
	 <386072610711061907q7809db9ct51d00fe2d6ec6c6b@mail.gmail.com>
	 <20071107032831.GW26163@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 7, 2007 11:28 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Wed, Nov 07, 2007 at 11:07:06AM +0800, Bryan Wu wrote:
> > On 11/6/07, Adrian Bunk <bunk@kernel.org> wrote:
> > > This patch removes the unused dump_thread().
> > >
> >
> > Why only remove it from Blackfin? any more reason?
>
> The only user is the a.out support.
>
> It was therefore removed prior to the blackfin merge from all
> architectures not supporting a.out.
>

OK, make sense. Currently, Blackfin doesn't suppport a.out.

Acked-by: Bryan Wu <bryan.wu@analog.com>



> > I found this in latest 2.6.24-rc2:
> >
> > --
> > Cscope tag: dump_thread
> >    #   line  filename / context / line
> >    1    324  arch/alpha/kernel/process.c <<dump_thread>>
> >              dump_thread(struct pt_regs * pt, struct user * dump)
> >    2    373  arch/arm/kernel/process.c <<dump_thread>>
> >              void dump_thread(struct pt_regs * regs, struct user * dump)
> >    3    244  arch/blackfin/kernel/process.c <<dump_thread>>
> >              void dump_thread(struct pt_regs *regs, struct user *dump)
> >    4    321  arch/m68k/kernel/process.c <<dump_thread>>
> >              void dump_thread(struct pt_regs * regs, struct user * dump)
> >    5    572  arch/sparc/kernel/process.c <<dump_thread>>
> >              void dump_thread(struct pt_regs * regs, struct user * dump)
> >    6    731  arch/sparc64/kernel/process.c <<dump_thread>>
> >              void dump_thread(struct pt_regs * regs, struct user * dump)
> >    7    306  arch/um/kernel/process.c <<dump_thread>>
> >              void dump_thread(struct pt_regs *regs, struct user *u)
> >    8    519  arch/x86/kernel/process_32.c <<dump_thread>>
> >              void dump_thread(struct pt_regs * regs, struct user * dump)
> > --
> >
> > Regards,
> > -Bryan
>
> cu
> Adrian
>
> --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>

Thanks a lot.
-Bryan Wu
