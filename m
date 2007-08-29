Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbXH2Tca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbXH2Tca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXH2TcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:32:23 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:15307 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbXH2TcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aJVokC2Wnv+oSJmxOtZEGngJQwxRZGf8mZZrJv5ioDwDz9obSa2WNYsyuNgRyvx+xZfrZIB3G/pX5aDmQ+pndXe7MWcjg8gzxcDzhe2/9wBJ0VZ/vzpuflA624bC4okTIH8uc1r0zv5IW6cu5elYsQLYVjwTBF9UVqpFI+WcYPI=
Message-ID: <dda83e780708291232h6ced720fy437c9ebf6bba2f3c@mail.gmail.com>
Date: Wed, 29 Aug 2007 12:32:20 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
Subject: Re: linux-2.6.23-rc4 ppc build failure
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <31e679430708291000n64a4e97aq5e326678a1fe9827@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780708290941g1685879bned63a77d6b0fd242@mail.gmail.com>
	 <31e679430708291000n64a4e97aq5e326678a1fe9827@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/07, Felipe Balbi <felipebalbi@users.sourceforge.net> wrote:
> Hi,
>
> On 8/29/07, Bret Towe <magnade@gmail.com> wrote:
> > while trying to build a fresh kernel for my mini after upgrading from gutsy
> > (and forgetting to save my .config) I hit the below build error
>
> The .config you can get from /boot/config-`uname -r`

yes I know the one thats attached is based off that
just slimed down trying to keep the compile time down as much as possable

> > 2.6.23-rc3 I did work under feisty but that is with a different .config
> > so not sure if that makes any difference or not
> > I've not bisected cause it takes so long on this computer...
> > attached is the config I'm working off now
> >
> > arch/powerpc/platforms/built-in.o: In function `pmac_probe':
> > setup.c:(.init.text+0xbba): undefined reference to `pmac_ide_get_base'
> > setup.c:(.init.text+0xbbe): undefined reference to `pmac_ide_init_hwif_ports'
> > setup.c:(.init.text+0xbc6): undefined reference to `pmac_ide_get_base'
> > setup.c:(.init.text+0xbca): undefined reference to `pmac_ide_init_hwif_ports'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make[1]: Leaving directory `/usr/src/linux-2.6'
> >
> >
>
>
> --
> Best Regards,
>
> Felipe Balbi
> felipebalbi@users.sourceforge.net
>
