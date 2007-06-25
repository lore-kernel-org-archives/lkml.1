Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbXFYMth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbXFYMth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXFYMta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:49:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:40173 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbXFYMt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=YlKSJ+8ZVjk7fLJZN7iGHpTbQXFiZ9Laa4NEMkkV/pHPthpRwKp76rklB2hY+Q7KwDzpuw43IXBmvvf+lIoiimrtbWs87RG75p4kH261ieuaOgbn3hxCyFIs3/aQ74vH7pIdKgQ8hyeHPbaDgGq7iSzhLgeySCZ255ealIjFonw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tomasz =?utf-8?q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Date: Mon, 25 Jun 2007 15:04:55 +0200
User-Agent: KMail/1.9.6
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <s5h4pkwi9u0.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251337180.25800@rudy.mif.pg.gda.pl>
In-Reply-To: <Pine.BSO.4.63.0706251337180.25800@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706251504.55808.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 25 June 2007, Tomasz Kłoczko wrote:
> On Mon, 25 Jun 2007, Takashi Iwai wrote:
> [..]
> >> Any plans for doing this ?
> >
> > Did you count the number of devices that tree supports?
> 
> What is harder ? Bring ALSA API to the same level of functionalities as 
> OSS provides or port (FOSS) ALSA device drivers to OSS ?

This is impossible to answer unless somebody does the both
(as usual with the software).

> > You'll loose the support of all new laptops and mobos sold in the last
> > year :)
> 
> You are loosing point lack of will ALSA developers to make this useable, 
> and well documented. OSS it is stabkle API specyfication with good 
> reputation. ALSA still is in development stage.

Talking ALSA developers into adapting OSS seems to be a dead end road.

> > Honestly, I'm not fully against changing the current code base (or
> > crap, whatever, any childish name).  There are indeed many misdesigns.
> > But, replacing with the above is no option, IMO.  The OSS have also
> > many misdesigns, so the same argument would start again.  One should
> > learn something from history...
> 
> OSS is at all misdesigned ? or in some points ? if partialy it was bad (in 
> time start work on ALSA) why was not improved ?

Probably because of "two steps forward and one step back" rule. :)

Learning from history would mean moving forward and creating next generation
sound subsystem better than both ALSA and OSS.  This of course would require
cooperation between ALSA and OSS developers which may be the biggest problem.

> For me it looks like ALSA developers don't know "don't move - improve" 
> sentence.
> kloczek
> PS. /me still waiting for simple yes or no answer on my qustion from 
> responsible people.
> For example: if Hannu or other OSS developer will bring some patches it 
> will be integrated or not in main tree ?

Depends on patches, just bring them on!

Having some competition would be a good thing for both ALSA and OSS.

Thanks,
Bart
