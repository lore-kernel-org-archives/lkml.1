Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbXJYDAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbXJYDAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXJYDAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:00:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:48269 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbXJYDAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:00:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ubb8NJAq4xNvOc9HkGR67OEFwN3+HiEkVPc3cpvCyD8bu+2YtrPszOJ4YJ9x/eFFOKfzQoAPVLXePQS2OnpBd9o3NozsbnSFzOjL1sGR0XyhnWY/PFcJHebF0o1u35/R0jzpHEpfx7sZl30LB3jSoSthpdyu7yEIEkbS/MY3gFI=
Message-ID: <8bd0f97a0710242000h7b6c97e7ia3f461c69b7d5de5@mail.gmail.com>
Date: Wed, 24 Oct 2007 23:00:02 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jie Zhang" <jzhang.linux@gmail.com>
Subject: Re: [2.6 patch] blackfin: "extern inline" -> "static inline"
Cc: "Adrian Bunk" <bunk@kernel.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <40401db90710241947i15e40e78v292e52f5229d9d35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024162643.GP30533@stusta.de>
	 <40401db90710241947i15e40e78v292e52f5229d9d35@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Jie Zhang <jzhang.linux@gmail.com> wrote:
> On 10/25/07, Adrian Bunk <bunk@kernel.org> wrote:
> > "extern inline" will have different semantics with gcc 4.3.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> > --- a/include/asm-blackfin/string.h
> > +++ b/include/asm-blackfin/string.h
> > @@ -4,7 +4,7 @@
> >  #ifdef __KERNEL__              /* only set these up for kernel code */
> >
> >  #define __HAVE_ARCH_STRCPY
> > -extern inline char *strcpy(char *dest, const char *src)
> > +static inline char *strcpy(char *dest, const char *src)
> >  {
> >         char *xdest = dest;
> >         char temp = 0;
>
> What if we compile it with gcc 4.1?

we'll have to either use the gcc attributes to force old inline
behavior or use the gcc flag to force it
-mike
