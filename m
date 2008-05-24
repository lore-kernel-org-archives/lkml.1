Return-Path: <linux-kernel-owner+w=401wt.eu-S1762344AbYEXVA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762344AbYEXVA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761653AbYEXVAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:00:08 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:45386 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761613AbYEXVAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:00:06 -0400
Date: Sat, 24 May 2008 23:57:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
Message-ID: <20080524205733.GC2308@cs181133002.pp.htv.fi>
References: <20080524192540.GA28067@uranus.ravnborg.org> <20080524200523.GB2308@cs181133002.pp.htv.fi> <20080524204438.GA3136@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080524204438.GA3136@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 10:44:38PM +0200, Sam Ravnborg wrote:
> > 
> > If you really want to be able to transform all #if's in .c files to 
> > if()'s you also have to offer a variant of our MODULE #define.
> 1) I have no pland to replace the current CONFIG_ use.
> 2) I do not follow whay you try to say about our "MODULE #define"
>...

I'm talking about the one set with
  MODFLAGS        = -DMODULE

But looking through the kernel I have to take my statement back since 
there don't seem to be many usages that could (if wanted) be transformed 
to if()'s at all (and similarily there wouldn't be many use cases in 
the future).

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

