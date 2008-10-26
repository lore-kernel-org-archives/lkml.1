Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbYJZVer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbYJZVer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 17:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYJZVei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 17:34:38 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:39057 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbYJZVeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 17:34:37 -0400
Date: Sun, 26 Oct 2008 23:33:35 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Huang Weiyi <weiyi.huang@gmail.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: staging: me4000: remove duplicated #include's
Message-ID: <20081026213335.GB1586@cs181140183.pp.htv.fi>
References: <20081018113833.61B4.WEIYI.HUANG@gmail.com> <20081020211822.GA30320@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081020211822.GA30320@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 02:18:22PM -0700, Greg KH wrote:
> On Sat, Oct 18, 2008 at 11:52:15AM +0800, Huang Weiyi wrote:
> > Removed duplicated #include's in drivers/staging/me4000/me4000.c
> >    asm/uaccess.h
> >    linux/fs.h
> > 
> > Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> > 
> > diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
> > index 862dd7f..90de6f0 100644
> > --- a/drivers/staging/me4000/me4000.c
> > +++ b/drivers/staging/me4000/me4000.c
> > @@ -30,7 +30,6 @@
> >  #include <asm/uaccess.h>
> >  #include <linux/errno.h>
> >  #include <linux/delay.h>
> > -#include <linux/fs.h>
> >  #include <linux/mm.h>
> >  #include <linux/unistd.h>
> >  #include <linux/list.h>
> > @@ -39,7 +38,6 @@
> >  #include <linux/poll.h>
> >  #include <linux/vmalloc.h>
> >  #include <asm/pgtable.h>
> > -#include <asm/uaccess.h>
> >  #include <linux/types.h>
> > 
> >  #include <linux/slab.h>
> 
> Hm, this doesn't apply anymore as some cleanups went in that should have
> just made this not needed.
> 
> But if you have a script I can run somewhere to verify it, I'd
> appreciate it.

linux-2.6$ make help | grep include
  includecheck    - Check for duplicate included header files
linux-2.6$ 

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

