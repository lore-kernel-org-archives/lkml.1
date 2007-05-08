Return-Path: <linux-kernel-owner+w=401wt.eu-S965908AbXEHI47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965908AbXEHI47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965805AbXEHI45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:56:57 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41650 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965774AbXEHI4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:56:55 -0400
Date: Tue, 8 May 2007 10:56:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Create a top-level "Space-critical features" menu.
Message-ID: <20070508085654.GG4226@stusta.de>
References: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 04:06:30AM -0400, Robert P. J. Day wrote:
> 
>   i've always hated that lower-level menu under "General setup":
> 
> Configure standard kernel features (for small systems)  --->
> 
> which buries the choice of de-selecting features to save space one
> level down without really explaining what it's all about.  so i just
> shifted all of that up to the top under what i think is a more
> meaningful name.
> 
>   this patch is also why i asked earlier why top-level menu entries
> have no "help" text -- because, in this case, it would be useful for
> someone looking at the config screen to see that choice and be able to
> ask, "hey, i wonder what *that's* all about", and get help along the
> lines of:
> 
>   "these features are normally selected but, if you're strapped for
> space, such as with embedded systems, you might consider turning some
> of them off.  if space isn't an issue, you might as well just leave
> them as they are."  (or something like that.)
>...

I'm against it:

I don't have numbers, but I'd expect the vast majority of people 
building kernels to be people with low kernel knowledge building for an 
i386/x86_64 system.

OTOH, people developing embedded systems are most likely more familiar 
with kernel internals.

Kernel size doesn't matter that much for average desktop or server 
systems, and most things for possible space savings behind hidden behind 
EMBEDDED are things where you _really_ have to know what you are doing 
when playing with these options.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

