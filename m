Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbXHAR2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbXHAR2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbXHAR2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:28:06 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57286 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbXHAR2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:28:04 -0400
Date: Wed, 1 Aug 2007 13:27:51 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       ezk@cs.sunysb.edu, jsipek@cs.sunysb.edu
Subject: Re: unionfs compile error ( Re: 2.6.23-rc1-mm2 )
Message-ID: <20070801172751.GA8565@filer.fsl.cs.sunysb.edu>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <46B0616E.5000704@googlemail.com> <20070801102207.f427a17f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801102207.f427a17f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 10:22:07AM -0700, Andrew Morton wrote:
> On Wed, 01 Aug 2007 12:33:18 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> 
> > ....
> > 
> > fs/unionfs/file.c:147: error: 'file_fsync' undeclared here (not in a function)
> > make[2]: *** [fs/unionfs/file.o] Error 1
> > make[1]: *** [fs/unionfs] Error 2
> > make: *** [fs] Error 2
> > make: *** Waiting for unfinished jobs....
> > 
> > ...
> > 
> > Config can be found there -> http://194.231.229.228/MM/config-auto-3
> > 
> 
> This, I assume:
> 
> --- a/fs/unionfs/file.c~git-unionfs-fix-2
> +++ a/fs/unionfs/file.c
> @@ -17,6 +17,7 @@
>   */
>  
>  #include "union.h"
> +#include <linux/buffer_head.h>
>  
>  /*******************
>   * File Operations *
> _
> 
> (and no, sorry, I will not be complicit in that
> single-header-file-which-includes-the-whole-world junk).

Ouch. I had a fix for this, and it managed to get lost in the pile of
patches.

I'll fix it up and push fix to kernel.org.

Jeff.

-- 
I abhor a system designed for the "user", if that word is a coded pejorative
meaning "stupid and unsophisticated."
		- Ken Thompson
