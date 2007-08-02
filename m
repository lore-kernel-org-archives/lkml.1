Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbXHBQae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbXHBQae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759108AbXHBQaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:30:13 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35522 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759257AbXHBQaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:30:11 -0400
Date: Thu, 2 Aug 2007 12:29:59 -0400
Message-Id: <200708021629.l72GTxFE007558@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       ezk@cs.sunysb.edu, jsipek@cs.sunysb.edu
Subject: Re: unionfs compile error ( Re: 2.6.23-rc1-mm2 ) 
In-reply-to: Your message of "Wed, 01 Aug 2007 13:27:51 EDT."
             <20070801172751.GA8565@filer.fsl.cs.sunysb.edu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20070801172751.GA8565@filer.fsl.cs.sunysb.edu>, Josef Sipek writes:
> On Wed, Aug 01, 2007 at 10:22:07AM -0700, Andrew Morton wrote:
> > On Wed, 01 Aug 2007 12:33:18 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> > 
> > > ....
> > > 
> > > fs/unionfs/file.c:147: error: 'file_fsync' undeclared here (not in a function)
> > > make[2]: *** [fs/unionfs/file.o] Error 1
> > > make[1]: *** [fs/unionfs] Error 2
> > > make: *** [fs] Error 2
> > > make: *** Waiting for unfinished jobs....
> > > 
> > > ...
> > > 
> > > Config can be found there -> http://194.231.229.228/MM/config-auto-3
> > > 
> > 
> > This, I assume:
> > 
> > --- a/fs/unionfs/file.c~git-unionfs-fix-2
> > +++ a/fs/unionfs/file.c
> > @@ -17,6 +17,7 @@
> >   */
> >  
> >  #include "union.h"
> > +#include <linux/buffer_head.h>
> >  
> >  /*******************
> >   * File Operations *
> > _
> > 
> > (and no, sorry, I will not be complicit in that
> > single-header-file-which-includes-the-whole-world junk).
> 
> Ouch. I had a fix for this, and it managed to get lost in the pile of
> patches.
> 
> I'll fix it up and push fix to kernel.org.

Jeff, make sure you push my fix which will work even if CONFIG_BLOCK=n is
set.

> Jeff.

Erez.
