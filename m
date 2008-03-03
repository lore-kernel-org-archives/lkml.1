Return-Path: <linux-kernel-owner+w=401wt.eu-S1763510AbYCCVhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763510AbYCCVhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759997AbYCCVhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:37:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:34174 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759051AbYCCVhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:37:07 -0500
Cc: linuxppc-dev@ozlabs.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 03 Mar 2008 22:37:05 +0100
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <1204577051.21545.12.camel@pasglop>
Message-ID: <20080303213705.312670@gmx.net>
MIME-Version: 1.0
References: <20071125234254.B4405DDE49@ozlabs.org>	
 <20080302110505.175270@gmx.net> <1204490829.15052.482.camel@pasglop>	
 <20080302223012.90210@gmx.net> <1204498569.15052.488.camel@pasglop>	
 <20080303195117.7040@gmx.net> <1204577051.21545.12.camel@pasglop>
Subject: Re: [BUG/RFC/PATCH] drm: Fix for non-coherent DMA PowerPC
To: benh@kernel.crashing.org
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19urq0sFLpufv+WJjDG/JF7FAzLNxbmjrbq8Nn+U5
 x/ky5sTwat48K0jTRqWIZiIjyELz2kIDhn8A== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: tV31fxVPYW0tWEp5PGZpUY58amthc5tD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
> Datum: Tue, 04 Mar 2008 07:44:11 +1100
> Von: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> An: Gerhard Pircher <gerhard_pircher@gmx.net>
> CC: airlied@linux.ie, linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org
> Betreff: Re: [BUG/RFC/PATCH] drm: Fix for non-coherent DMA PowerPC

> On Mon, 2008-03-03 at 20:51 +0100, Gerhard Pircher wrote:
> > > Remove the GFP_HIGHMEM from the above. It looks like our cache
> > > flushing isn't going to work for highmem, it would need some
> > > kmap's for that.
> 
> > Yes, it looks like this was the problem. No kernel oops anymore.
> > The machine locks up anyway (which is a well known hardware problem).
> > It doesn't lock up with CPPIOMode=true, but probably only because the
> > initialization of DRI fails with "BAD cp_mode (f0000000)!".
> 
> Damn, I wonder why you insist trying to make that machine work :-) The
> hardware is just totally busted.
Because it's a challenge! :) Or because the OS4 developers say that
PCIGART works.

Gerhard
-- 
Psst! Geheimtipp: Online Games kostenlos spielen bei den GMX Free Games! 
http://games.entertainment.web.de/de/entertainment/games/free
