Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbXKDBSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbXKDBSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 21:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbXKDBSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 21:18:04 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35767 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754111AbXKDBSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 21:18:01 -0400
Date: Sun, 4 Nov 2007 02:17:37 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] replace "make ARCH=i386/x86_64 with make ARCH=x86"
Message-ID: <20071104011737.GG12045@stusta.de>
References: <20071103234826.GA26654@uranus.ravnborg.org> <20071103165247.3663f518@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071103165247.3663f518@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 04:52:47PM -0700, Arjan van de Ven wrote:
> On Sun, 4 Nov 2007 00:48:26 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > This patchset unify the i386 and x86_64 Kconfig
> > files for x86.
> > In addition it replaces the use of ARCH=i386 and
> > ARCH=x86_64 with the more intuitive ARCH=x86.
> > 
> > The primary purpose of this patch serie is to 
> > enable make ARCH=x86 and let the config decide
> > if we are building for 32 or 64 bit.
> > 
> > But we will break quite a high number of
> > scripts with this change.
> > What is the desired behaviour when specifying:
> > make ARCH=i386
> > and
> > make ARCH=x86_64
> 
> I would say.. just print a very very nasty warning, wait 20 seconds,
> and then pretend it was passed as x86
> and then remove in the next release (assuming the code isn't too ugly)

I'd suggest exit'ing after printing a helpful note.

The user will anyway have to adjust his build environment, so let's make 
a clear cut now.

> other than that.. just break it now in 2.6.24; people at least remember
> .24 as the release that unified, so they expect changes there... they
> won't expect them for .25 or later

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

