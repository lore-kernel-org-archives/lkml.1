Return-Path: <linux-kernel-owner+w=401wt.eu-S1764514AbXHATGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764514AbXHATGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765829AbXHATGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:06:35 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57165 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765764AbXHATGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:06:33 -0400
Date: Wed, 1 Aug 2007 21:06:11 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rutger Nijlunsing <rutger@nospam.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] ppc .gitignore update
Message-ID: <20070801190611.GQ3972@stusta.de>
References: <20070801133056.GP3972@stusta.de> <fa686aa40708010653v7e1fb909gb03eb1d4754359bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa686aa40708010653v7e1fb909gb03eb1d4754359bf@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 07:53:28AM -0600, Grant Likely wrote:
> On 8/1/07, Adrian Bunk <bunk@stusta.de> wrote:
> > arch/ppc/.gitignore shouldn't exclude arch/ppc/boot/include
> >
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> >
> > ---
> > --- /dev/null   2006-09-19 00:45:31.000000000 +0200
> > +++ linux-2.6.23-rc1-mm2/arch/ppc/boot/.gitignore       2007-08-01 15:18:33.000000000 +0200
> > @@ -0,0 +1 @@
> > +!include
> 
> I don't think this is the best way to go about it; rather,
> arch/ppc/.gitignore should be made more specific like so:
> 
> diff --git a/arch/ppc/.gitignore b/arch/ppc/.gitignore
> index a1a869c..1e79a0a 100644
> --- a/arch/ppc/.gitignore
> +++ b/arch/ppc/.gitignore
> @@ -1 +1 @@
> -include
> +/include

Thanks, that's obviously better than my patch.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

