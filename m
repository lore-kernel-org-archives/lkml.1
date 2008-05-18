Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbYERUpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbYERUpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 16:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYERUo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 16:44:59 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48994 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbYERUo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 16:44:59 -0400
Date: Sun, 18 May 2008 23:42:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       Gordon Farquharson <gordonfarquharson@gmail.com>
Subject: Re: crossbuild fails in modpost
Message-ID: <20080518204258.GL8140@cs181133002.pp.htv.fi>
References: <482C3E3E.9090204@gmail.com> <482C6F02.1000205@gmail.com> <20080515173539.GA23959@uranus.ravnborg.org> <20080515174015.GA24024@uranus.ravnborg.org> <482C8CBE.2060101@gmail.com> <20080515204632.GG1936@cs181133002.pp.htv.fi> <alpine.LNX.1.10.0805182155011.15590@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0805182155011.15590@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 09:55:58PM +0200, Jan Engelhardt wrote:
> 
> On Thursday 2008-05-15 22:46, Adrian Bunk wrote:
> >>
> >> Well, the compiler is the same, but it's told to compile the kernel with  
> >> -m64. It runs on x86_64 kernel and i386 userspace. It's debian i386 gcc  
> >> package which understands x86_64 objects too. No SUBARCH option, it seems 
> >> to default to x86_64.
> >>...
> >
> >Unless you manually fiddle with ARCH you can only build a kernel with 
> >the same 32<->64bit setting as your currently running kernel (no matter 
> >which userspace you use)...
> 
> echo -en '#!/bin/bash\nexec gcc -m32 "$@"\n' >/usr/local/bin/i386-linux-gcc
> make CC=i386-linux-gcc
> then the if($(CC),$(HOSTCC)) check should get true.

No doubt that you can work around the problem.

But that's not a solution.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

