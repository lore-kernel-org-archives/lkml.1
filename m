Return-Path: <linux-kernel-owner+w=401wt.eu-S933564AbXK2WGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564AbXK2WGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762088AbXK2WGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:06:20 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:55723 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761576AbXK2WGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:06:19 -0500
Date: Thu, 29 Nov 2007 23:06:10 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tobias Powalowski <t.powa@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] x86/paravirt: revert exports to restore old behaviour
Message-ID: <20071129220610.GK29463@stusta.de>
References: <474CA0DA.3010005@goop.org> <20071128204050.GA29463@stusta.de> <474DDA7B.9090802@goop.org> <20071128223909.GE29463@stusta.de> <474E007B.1020405@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <474E007B.1020405@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 03:57:47PM -0800, Jeremy Fitzhardinge wrote:
> Adrian Bunk wrote:
> > This does not apply since we do not have a stable in-kernel API, and 
> > therefore changes to the in-kernel API can by definition not be 
> > regressions.
> >
> > 2.6.24 most likely contains hundreds of changes and removals of 
> > in-kernel APIs that existed in 2.6.23.
> >
> > Are you seriously suggesting that e.g. every single change to any struct 
> > under include/ [1] would require an announcement x kernel releases 
> > before it can be implemented?
> 
> Well, no, but that's not the point.
>...

Sorry if I was a bit harsh, but no change to the in-kernel API [1] 
could ever be called a regression since we do not have a stable 
in-kernel API.

And what annoyed was that this was one of at least 3 ongoing 
linux-kernel threads where people tried to bring the notion that any 
part of the in-kernel API had any kind of stability.

>     J

cu
Adrian

[1] and that includes what is visible to modules

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

