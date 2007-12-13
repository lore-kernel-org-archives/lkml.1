Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbXLMPGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbXLMPGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbXLMPFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:05:55 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47543 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbXLMPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:05:54 -0500
Date: Thu, 13 Dec 2007 10:05:13 -0500
Message-Id: <200712131505.lBDF5DVS031168@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, hch@infradead.org, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 33/42] MM: extern for drop_pagecache_sb 
In-reply-to: Your message of "Mon, 10 Dec 2007 15:04:26 +0100."
             <20071210140426.GL20441@stusta.de> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071210140426.GL20441@stusta.de>, Adrian Bunk writes:
> On Sun, Dec 09, 2007 at 09:42:06PM -0500, Erez Zadok wrote:
> > Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> > ---
> >  include/linux/mm.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1b7b95c..fc61bd3 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> >...
> > @@ -1135,6 +1136,7 @@ int drop_caches_sysctl_handler(struct ctl_table *, int, struct file *,
> >  					void __user *, size_t *, loff_t *);
> >  unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
> >  			unsigned long lru_pages);
> > +extern void drop_pagecache_sb(struct super_block *);
> >  void drop_pagecache(void);
> >  void drop_slab(void);
> 
> This breaks compilation (and therefore bisecting) until the function 
> becomes non-static in patch #36.
> 
> Please merge patches #33 and #36 into one patch.
> 
> That's not terribly important now that you've sent the patches for 
> review, but keep in mind that the tree should compile at all stages for 
> making bisecting possible when preparing the final submission.
> 
> cu
> Adrian

Adrian, having used git-bisect successfully before, I agree with you.  I've
reorganized my patches now, and merged a few small ones, so they all build
incrementally.

Cheers,
Erez.
