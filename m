Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbXH3KlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbXH3KlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 06:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbXH3KlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 06:41:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:35625 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbXH3KlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 06:41:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SBMkDekPto+jm2cPP63M7EdVFR7R/ex7gyvEtjak2LdL2q9/EfhA/npl5meDR9qKUODBm9FPY4GWgkFteDeEIKU/xofxIvNwO04Q3v7oxRTfy2+/n7onmV6LvIgVy4AXIKD5FRiisDupGFGB3IkFsl89r1mNkITeLpVVNqDqu8I=
Message-ID: <31e679430708300341k45b1b61dyce72928b3ff9208f@mail.gmail.com>
Date: Thu, 30 Aug 2007 06:41:10 -0400
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Bret Towe" <magnade@gmail.com>
Subject: Re: linux-2.6.23-rc4 ppc build failure
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <dda83e780708291232h6ced720fy437c9ebf6bba2f3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780708290941g1685879bned63a77d6b0fd242@mail.gmail.com>
	 <31e679430708291000n64a4e97aq5e326678a1fe9827@mail.gmail.com>
	 <dda83e780708291232h6ced720fy437c9ebf6bba2f3c@mail.gmail.com>
X-Google-Sender-Auth: 254ac1086fb60ca8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 8/29/07, Bret Towe <magnade@gmail.com> wrote:
> On 8/29/07, Felipe Balbi <felipebalbi@users.sourceforge.net> wrote:
> > Hi,
> >
> > On 8/29/07, Bret Towe <magnade@gmail.com> wrote:
> > > while trying to build a fresh kernel for my mini after upgrading from gutsy
> > > (and forgetting to save my .config) I hit the below build error
> >
> > The .config you can get from /boot/config-`uname -r`
>
> yes I know the one thats attached is based off that
> just slimed down trying to keep the compile time down as much as possable

Well, I don't have ppc cross-compiler... so I can't try this for you.
What I can tell you is that it doesn't seem like there was any change
regarding those functions. But even though, you're selecting the
needed Kconfig Macros.

Maybe someone who uses PPC arch could help better ???

>
> > > 2.6.23-rc3 I did work under feisty but that is with a different .config
> > > so not sure if that makes any difference or not
> > > I've not bisected cause it takes so long on this computer...
> > > attached is the config I'm working off now
> > >
> > > arch/powerpc/platforms/built-in.o: In function `pmac_probe':
> > > setup.c:(.init.text+0xbba): undefined reference to `pmac_ide_get_base'
> > > setup.c:(.init.text+0xbbe): undefined reference to `pmac_ide_init_hwif_ports'
> > > setup.c:(.init.text+0xbc6): undefined reference to `pmac_ide_get_base'
> > > setup.c:(.init.text+0xbca): undefined reference to `pmac_ide_init_hwif_ports'
> > > make[1]: *** [.tmp_vmlinux1] Error 1
> > > make[1]: Leaving directory `/usr/src/linux-2.6'
> > >
> > >
> >
> >
> > --
> > Best Regards,
> >
> > Felipe Balbi
> > felipebalbi@users.sourceforge.net
> >
>


-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
