Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbZAXUKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbZAXUKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 15:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZAXUKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 15:10:45 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:4639 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbZAXUKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 15:10:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ky+F15KylOTKuvG1mknGPbIeaRRPjxHDg08DceaZP5sIqnuPmlXIUfo9wVC99iErQX
         UmHkLzGfqhPmgfDh2DzwFroSv5h4dkzmLgdu+/7isnSI5YoqulJKYHGjYmk2xniv6Io6
         e3baZ7J9887dPSRnyH+bv/n22kdaipc88A858=
Subject: Re: [PATCH 1/2] cris: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <3f9a31f40901240410r44451621n3dfaf808dfa9b01d@mail.gmail.com>
References: <1231903597.5756.4.camel@brick>
	 <3f9a31f40901240410r44451621n3dfaf808dfa9b01d@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 12:10:42 -0800
Message-Id: <1232827843.5516.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-24 at 17:40 +0530, Jaswinder Singh Rajput wrote:
> On Wed, Jan 14, 2009 at 8:56 AM, Harvey Harrison
> <harvey.harrison@gmail.com> wrote:
> > Adjust the arch overrides to the new names as well.
> >
> > --- /dev/null
> > +++ b/arch/cris/include/arch-v10/arch/swab.h
> > @@ -0,0 +1,30 @@
> > +#ifndef _CRIS_ARCH_SWAB_H
> > +#define _CRIS_ARCH_SWAB_H
> > +
> > +#include <asm/types.h>
> 
> Please replace #include <asm/types.h> with #include <linux/types.h>
> otherwise you will get following 'make headers_check' warnings:
>   usr/include/asm/swab.h:4: include of <linux/types.h> is preferred
> over <asm/types.h>
>   usr/include/asm/swab.h:14: found __[us]{8,16,32,64} type without
> #include <linux/types.h>
> 

1) I sent this patch bypassing the arch maintainer, so I made it as
simple as possible, just moved the byteorder.h's and changed the
names of the arch-overrides.

2) If you'd care to check, this file is not exported to userspace, so
I can't possible trigger that warning.

3) It's already in Linus' tree, so it's a bit hard for me to change it
now ;-)

Harvey

