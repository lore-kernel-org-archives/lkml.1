Return-Path: <linux-kernel-owner+w=401wt.eu-S1763299AbYENUFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763299AbYENUFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762445AbYENUEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:04:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761755AbYENUEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:04:52 -0400
Date: Wed, 14 May 2008 17:04:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCHES] V4L/DVB fixes for 2.6.26
Message-ID: <20080514170405.330c0d0a@gaivota>
In-Reply-To: <20080514193822.GA21795@cs181133002.pp.htv.fi>
References: <20080514114910.4bcfd220@gaivota>
	<20080514165434.GC22115@cs181133002.pp.htv.fi>
	<20080514145554.10e3385c@gaivota>
	<20080514193822.GA21795@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > I can make a patch for it after this pull went into Linus' tree if it is 
> > > considered an acceptable option.
> > 
> > It would be nice if you could help on fixing those issues.
> > 
> > One dependency that will probably solve is to add "depends on VIDEO_MEDIA &&
> > I2C" to all devices that are hybrid (bttv, saa7134, cx88, pvrusb, em28xx).
> 
> What about converting all dependencies on I2C to select's?

This seems to be a good idea.

> VIDEO_V4L2_COMMON might perhaps need a small trick,

I suspect that this can now be replaced by VIDEO_DEV, on webcam/radio drivers
or VIDEO_MEDIA for hybrid V4L/DVB drivers. Btw, I think we can replace
VIDEO_MEDIA into just MEDIA.

> but otherwise that 
> would be a straightforward solution to solve these problems.

This will solve several troubles. Still, I think that there are still some
other missing dependencies (like INPUT, on drivers that select IR).
> 
> Any problem I miss or should I bake a patch?

I can't see any trouble on this approach. Feel free to work on it.

Thanks,
Mauro
