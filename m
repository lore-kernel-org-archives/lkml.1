Return-Path: <linux-kernel-owner+w=401wt.eu-S932958AbXBTSmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958AbXBTSmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 13:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932684AbXBTSmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 13:42:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:29477 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958AbXBTSmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 13:42:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=A4eRM4OE2Vcl9g1qFzd5z2uKJTi5tc1YziX1GPQs8yZXOsodpjukcM2xNqCtXjgLIgRTcgjTeenx6NkzOwkSVKvlwDBakXNXjj9MgRwEUfcLXqY3TgRD8Omjln/P+5jmbuUSv0CR0/Bp+o2afv2N2EookCunVcstZpDOlstOIMQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] siimage: DRAC4 note
Date: Tue, 20 Feb 2007 19:48:25 +0100
User-Agent: KMail/1.9.5
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <20070220175600.43476be1@localhost.localdomain> <45DB2855.9010705@garzik.org>
In-Reply-To: <45DB2855.9010705@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702201948.25730.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 20 February 2007 17:56, Jeff Garzik wrote:
> Alan wrote:
> > The Dell DRAC4 has some interesting features including effectively hot
> > unplugging/replugging the virtual CD interface when the DRAC is reset.
> > This often causes drivers/ide/siimage to panic but is ok with the rather
> > smarter code in libata.
> > 
> > Just note this fact in the driver docs.
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> > 
> > diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/pci/siimage.c linux-2.6.20-mm2/drivers/ide/pci/siimage.c
> > --- linux.vanilla-2.6.20-mm2/drivers/ide/pci/siimage.c	2007-02-20 13:38:01.000000000 +0000
> > +++ linux-2.6.20-mm2/drivers/ide/pci/siimage.c	2007-02-20 13:59:44.000000000 +0000
> > @@ -26,6 +26,9 @@
> >   *	If you have strange problems with nVidia chipset systems please
> >   *	see the SI support documentation and update your system BIOS
> >   *	if neccessary
> > + *
> > + *	If you are using a Dell DRAC4 you should use the libata driver
> > + *	if possible.
> 
> IMO it would probably easier on all involved if the comment noted what 
> you state in the patch description.

seconded

Alan, please send me the actual OOPS if possible.

Bart
