Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZFDFOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZFDFOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZFDFOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:14:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34468 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZFDFO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:14:29 -0400
Date: Thu, 4 Jun 2009 07:21:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [9/16] HWPOISON: Handle hardware poisoned pages in try_to_unmap
Message-ID: <20090604052147.GP1065@one.firstfloor.org>
References: <20090603846.816684333@firstfloor.org> <20090603184642.BD4B91D0291@basil.firstfloor.org> <20090604043541.GC15682@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604043541.GC15682@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Index: linux/include/linux/rmap.h
> > ===================================================================
> > --- linux.orig/include/linux/rmap.h	2009-06-03 19:36:23.000000000 +0200
> > +++ linux/include/linux/rmap.h	2009-06-03 19:36:23.000000000 +0200
> > @@ -93,6 +93,7 @@
> >  
> >  	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
> >  	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
> > +	TTU_IGNORE_HWPOISON = (1 << 10),/* corrupted page is recoverable */
> 
> Or more precisely comment it as "corrupted data is recoverable"?

I think the original comment is clear enough, not changing that for now.

Thanks,
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
