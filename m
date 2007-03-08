Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbXCHRFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbXCHRFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXCHRFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:05:10 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:2570 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbXCHRFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:05:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aV/9WzvAYGNFWbv/uzWco4VgCpWcLzAPDQpDvJDQEY3JN1U8pu4KoAjPFLwFT1ky6FQR6R4UPTN1xDCPvUiDcNcogqjcr/X/BSsp+xxxTwNuTxDgo3otAoX01/Q2XnKRN/EnzBn/vkN/tzlw2tH0dO5t3Ki9JZ4AE3rya/3YOVw=
Message-ID: <6bffcb0e0703080905n7395efb0xed62455659fd088d@mail.gmail.com>
Date: Thu, 8 Mar 2007 18:05:05 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: mm snapshot broken-out-2007-03-05-02-22.tar.gz uploaded
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Cushman" <rcushman_linux@earthlink.net>,
       "Jaroslav Kysela" <perex@suse.cz>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <s5hwt1rn0aj.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703051024.l25AOIF3015951@shell0.pdx.osdl.net>
	 <6bffcb0e0703071141j42309702w793e4a76b1b23bfa@mail.gmail.com>
	 <20070307115024.756c848f.akpm@linux-foundation.org>
	 <s5hvehcrdod.wl%tiwai@suse.de> <45EF3B2C.9060801@googlemail.com>
	 <s5hfy8gbrmj.wl%tiwai@suse.de> <45F02EE2.6040606@googlemail.com>
	 <s5h8xe7ognj.wl%tiwai@suse.de>
	 <6bffcb0e0703080852l4a06c0f9qeb51044a7a1a68a@mail.gmail.com>
	 <s5hwt1rn0aj.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/07, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 8 Mar 2007 17:52:43 +0100,
> Michal Piotrowski wrote:
> >
> > On 08/03/07, Takashi Iwai <tiwai@suse.de> wrote:
> > > At Thu, 08 Mar 2007 16:42:26 +0100,
> > > Michal Piotrowski wrote:
> > > >
> > > > > Also, it'd be helpful if you compare
> > > > > /proc/asound/card0/codec97#0/ac97#0-0+regs file before and after the
> > > > > patch.  This reveals which register bits differ actually.
> > > >
> > > > a2.txt is form 2.6.21-rc3 witchout 831466f4ad2b5fe23dff77edbe6a7c244435e973
> > > >
> > > > diff -uprN a2.txt /proc/asound/card0/codec97#0/ac97#0-0+regs
> > > > --- a2.txt      2007-03-08 16:36:47.000000000 +0100
> > > > +++ /proc/asound/card0/codec97#0/ac97#0-0+regs  2007-03-08 16:36:49.447083597 +0100
> > > > @@ -56,8 +56,8 @@
> > > >  0:6e = 0000
> > > >  0:70 = 0000
> > > >  0:72 = 0004
> > > > -0:74 = 1001
> > > > -0:76 = 64a4
> > > > +0:74 = 1201
> > > > +0:76 = 7ca4
> > > >  0:78 = 000c
> > > >  0:7a = 0000
> > > >  0:7c = 4144
> > >
> > > OK, some wrong bits there.  Could you try the patch below?
> >
> > Problem fixed. Thanks!
> >
> > (speaker-test -c6 -Dplug:surround51 is still broken)
>
> Hm, how about turning off "Spread Front To..." control and run
> speaker-test?

Now I've got:
rear left as center
rear right as LFE

:)

>
>
> Takashi
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
