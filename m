Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbXFTQmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbXFTQmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 12:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXFTQlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 12:41:53 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49977 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbXFTQlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 12:41:52 -0400
Date: Wed, 20 Jun 2007 18:42:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Mike Frysinger <vapier@gentoo.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] remove usage of memmem from scripts/kallsyms.c
Message-ID: <20070620164255.GA11519@uranus.ravnborg.org>
References: <4678013C.5090402@grupopie.com> <a781481a0706191147x72be6357vf0c83808b13174b8@mail.gmail.com> <200706200033.16708.vapier@gentoo.org> <467915DD.7020906@grupopie.com> <c8d2863984d16e31de2aaed038b7367a@kernel.crashing.org> <46794D6B.9050301@grupopie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46794D6B.9050301@grupopie.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 04:53:15PM +0100, Paulo Marques wrote:
> Segher Boessenkool wrote:
> >>>>So we could remove the "#define _GNU_SOURCE" at the top
> >>>>of scripts/kallsyms.c too, presumably? If not (i.e. if there are
> >>>>more GNUisms left in that file anyway), then I'm not sure if we
> >>>>really gain by the change.
> >>>yes, i believe this is true
> >>
> >>I only tried in on x86 with my toolchain and it works, but I don't 
> >>know if it is worth the risk of breaking someone's setup for virtually 
> >>no gain...
> >
> >With the memmem() removed, the code builds (and works)
> >fine on several non-GNU systems.  It should be perfectly
> >safe to remove the _GNU_SOURCE. 
> 
> You're right. I went back in history and it was me who introduced the 
> _GNU_SOURCE when I added the memmem too (shame on me). So, if it worked 
> fine before, there is no reason to not work now that memmem is removed.
> 
> So I can:
> 
>  - send an incremental patch with just that line removed
> 
>  - send a replacement patch
> 
>  - just leave it for now and wait until I work on kallsyms again to 
> silently remove that line together with other changes
> 
> Andrew, what would you prefer?
Please send a replacement patch to me.
I will carry it in the kbuild tree.

	Sam
