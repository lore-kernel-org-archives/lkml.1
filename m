Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbXDKMT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbXDKMT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 08:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXDKMT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 08:19:29 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:48355 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbXDKMT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 08:19:29 -0400
Date: Wed, 11 Apr 2007 14:19:03 +0200
From: Eduard Bloch <edi@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, debburn-devel@lists.alioth.debian.org
Subject: Re: broken device locking, sg vs. sg_io on block devices
Message-ID: <20070411121903.GA15624@rotes76.wohnheim.uni-kl.de>
References: <200703261811.21448.gerald@itzgrund.net> <20070330111744.GA8889@rotes76.wohnheim.uni-kl.de> <20070330134327.GA24030@infradead.org> <20070330142114.GA31685@rotes76.wohnheim.uni-kl.de> <20070330191038.067c346b@the-village.bc.nu> <20070331170703.GA8179@rotes76.wohnheim.uni-kl.de> <20070331232002.7b478f37@the-village.bc.nu> <20070407112131.GA10487@rotes76.wohnheim.uni-kl.de> <20070411101245.GA32592@rotes76.wohnheim.uni-kl.de> <20070411123102.7dc238d7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070411123102.7dc238d7@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

#include <hallo.h>
* Alan Cox [Wed, Apr 11 2007, 12:31:02PM]:
> > > Can we do following without having side effects:
> > > 
> > > open("/dev/sr0",O_EXCL|O_RDWR); /* no matter what it returns */
> > > fcntl(..., F_SETLK); /* no matter what it returns */
> > > ioctl(f, SCSI_IOCTL_GET_IDLUN, &x);
> > > ioctl(f, SCSI_IOCTL_GET_BUS_NUMBER, &jo);
> > > 
> > > Can you guarantee us that bit? 
> 
> open() has side effects. The CD layer allows you to open with O_NDELAY if
> you want to avoid them.

Okay, thanks.

> > [1] and when we get real critical questions then everything we get is
> > radio silence? Very kindly. NOT.
> 
> Given the attitude that was shown before be glad I'm even bothering to
> reply to this.

My attitude? I hope you realize that our hands are tied if we get that
great kind of support here (like SEP roundtrips, not applicable
exemplary solutions and explanations without relevant details like the
one above) while the problem exists. Meaning sure death to real CDR/DVDR
disks every day.

You don't do the end user support, we do.

Eduard.
-- 
<Salz> jjFux: Ted hieß ja früher auch Walther
<Salz> winkiller: hm... es sind 8... die 7 kandidaten und NOTA
<Madkiss> Ist der jetzt eigentlich eine gespaltene Persönlichkeit, bei der aber
  beide Teile bekloppt sind?
