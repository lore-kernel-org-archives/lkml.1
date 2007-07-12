Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbXGLXfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbXGLXfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbXGLXf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:35:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59636 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754670AbXGLXf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:35:26 -0400
Date: Fri, 13 Jul 2007 01:35:59 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] Start to genericize kconfig for use by other projects.
Message-ID: <20070712233559.GQ3492@stusta.de>
References: <200707111522.14240.rob@landley.net> <20070711195521.GO3492@stusta.de> <200707111718.57652.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200707111718.57652.rob@landley.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 05:18:57PM -0400, Rob Landley wrote:
> On Wednesday 11 July 2007 3:55:21 pm Adrian Bunk wrote:
> > On Wed, Jul 11, 2007 at 03:22:13PM -0400, Rob Landley wrote:
> > >...
> > > --- a/crypto/Makefile	Tue Jul 10 17:51:13 2007 -0700
> > > +++ b/crypto/Makefile	Wed Jul 11 15:07:07 2007 -0400
> > > @@ -50,3 +50,4 @@ obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
> > >  obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
> > >
> > >  obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
> > > +obj-m += randint.o
> > >...
> 
> Oops.  Missed a revert.  Sorry 'bout that.
> 
> > If you'd have included a diffstat as described in
> > Documentation/SubmittingPatches section 1 point 14 you might have
> > noticed this yourself...
>...

To avoid misunderstandings: There should have been a smiley.

> (/me goes to read up on diffstat...  Ah, I see, it's a program you install.  I
> thought it was a diff option.  So possibly you could make SubmittingPatches
> longer by mentioning that.)
>...


And we might make SubmittingPatches even longer by additionally 
mentioning
  git-diff --stat


> Rob

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

