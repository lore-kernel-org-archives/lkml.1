Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYFTKTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYFTKTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYFTKTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:19:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39670 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYFTKTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:19:09 -0400
Date: Fri, 20 Jun 2008 11:19:07 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Johannes Weiner <hannes@saeurebad.de>
cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: [git pull] drm patches for 2.6.26-final
In-Reply-To: <87bq1wpjtk.fsf@skyscraper.fehenstaub.lan>
Message-ID: <alpine.DEB.0.82.0806201117280.13650@skynet.skynet.ie>
References: <alpine.DEB.0.82.0806200402030.12492@skynet.skynet.ie>
 <alpine.DEB.0.82.0806200645470.12492@skynet.skynet.ie>
 <87bq1wpjtk.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> Author: Johannes Weiner <hannes@saeurebad.de>

I did report the author here ^^, I didn't see a reported by credit on the 
original email.

and I suggested this was the patch, and I was wrong, and I've rewritten 
it, and not I realise the drm ioctls are as ever a really big mess, the 
driver ioctls on the kernel side don't have direction bits which is really 
bad.

Dave.



> >> Date:   Fri Jun 13 15:04:40 2008 +1000
> >> 
> >>     drm: use drms ioctl cmd not what we get passed from userspace.
> >>     
> >>     This enforces us to use the drm ioctl types so read/write works correctly and not believe
> >>     what userspace tells us.
> >>     
> >>     It does this hopefully without breaking the drm api.
> >>     
> >>     Fixes bug from thread: BUG: unable to handle kernel NULL pointer dereference (drm_getunique)
> >>     
> >>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
>        Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
>        Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> 
> That was only a proposal, to which you did not reply at all [1] and just
> silently picked it (without the credits).  Not very polite.
> 
> 	Hannes
> 
> [1] http://lkml.org/lkml/2008/6/5/250
> 
> -------------------------------------------------------------------------
> Check out the new SourceForge.net Marketplace.
> It's the best place to buy or sell services for
> just about anything Open Source.
> http://sourceforge.net/services/buy/index.php
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
> 
> 
