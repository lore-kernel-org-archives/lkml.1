Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbYJZWGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYJZWGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 18:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYJZWGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 18:06:43 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48257 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbYJZWGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 18:06:42 -0400
Date: Mon, 27 Oct 2008 00:05:39 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "J.R. Mauro" <jrm8005@gmail.com>
Cc: Greg KH <greg@kroah.com>, Huang Weiyi <weiyi.huang@gmail.com>,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: staging: me4000: remove duplicated #include's
Message-ID: <20081026220539.GC1586@cs181140183.pp.htv.fi>
References: <20081018113833.61B4.WEIYI.HUANG@gmail.com> <20081020211822.GA30320@kroah.com> <20081026213335.GB1586@cs181140183.pp.htv.fi> <3aaafc130810261440q1f801a3bv8b74d5629aa1edfc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3aaafc130810261440q1f801a3bv8b74d5629aa1edfc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 05:40:04PM -0400, J.R. Mauro wrote:
> On Sun, Oct 26, 2008 at 5:33 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Mon, Oct 20, 2008 at 02:18:22PM -0700, Greg KH wrote:
> >> On Sat, Oct 18, 2008 at 11:52:15AM +0800, Huang Weiyi wrote:
> >> > Removed duplicated #include's in drivers/staging/me4000/me4000.c
> >> >    asm/uaccess.h
> >> >    linux/fs.h
> >> >
> >> > Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> >> >
> >> > diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
> >> > index 862dd7f..90de6f0 100644
> >> > --- a/drivers/staging/me4000/me4000.c
> >> > +++ b/drivers/staging/me4000/me4000.c
> >> > @@ -30,7 +30,6 @@
> >> >  #include <asm/uaccess.h>
> >> >  #include <linux/errno.h>
> >> >  #include <linux/delay.h>
> >> > -#include <linux/fs.h>
> >> >  #include <linux/mm.h>
> >> >  #include <linux/unistd.h>
> >> >  #include <linux/list.h>
> >> > @@ -39,7 +38,6 @@
> >> >  #include <linux/poll.h>
> >> >  #include <linux/vmalloc.h>
> >> >  #include <asm/pgtable.h>
> >> > -#include <asm/uaccess.h>
> >> >  #include <linux/types.h>
> >> >
> >> >  #include <linux/slab.h>
> >>
> >> Hm, this doesn't apply anymore as some cleanups went in that should have
> >> just made this not needed.
> >>
> >> But if you have a script I can run somewhere to verify it, I'd
> >> appreciate it.
> >
> > linux-2.6$ make help | grep include
> >  includecheck    - Check for duplicate included header files
> > linux-2.6$
> 
> Is there a way to get this to just check in a user-specified
> directory? I didn't see any options for that and adding
> M=drivers/staging didn't help.

Pipe the output through grep.

Or if you really want to limit what gets checked, setting the path in 
the Makefile is trivial.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

