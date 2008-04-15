Return-Path: <linux-kernel-owner+w=401wt.eu-S932796AbYDOVUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbYDOVUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932768AbYDOVTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:19:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:31989 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737AbYDOVTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:19:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=A8ygsZKMnzxXuzabLPVqP5WHUAIPdNOkEKqGKN7qXsDq7+Rke0SGtlFCS5VZ/HwYx3VJhKT+CnIGOMAhhZv5jqf8DZt5fkjkRAcRHPtZYQ9EqlUipaZx4yFqPqDVETvnIMWpFmwtilwMFh8zkWa6Nqgh66EaiwNFHwHPBPD/iR0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [2.6 patch] PCMCIA mustn't select HAVE_IDE
Date: Tue, 15 Apr 2008 22:15:34 +0200
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       Russell King <rmk@arm.linux.org.uk>
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <20080414175344.GA15028@uranus.ravnborg.org>
In-Reply-To: <20080414175344.GA15028@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804152215.34904.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Sam Ravnborg wrote:
> On Mon, Apr 14, 2008 at 05:16:59PM +0300, Adrian Bunk wrote:
> > It's plain wrong for PCMCIA to select HAVE_IDE that implies e.g. the 
> > availability of an asm/ide.h
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > ---
> > 9cdb66112488bc0c6e1d528444d3ba30d5b0487f diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
> > index 8b22281..519b4ff 100644
> > --- a/drivers/pcmcia/Kconfig
> > +++ b/drivers/pcmcia/Kconfig
> > @@ -38,7 +38,6 @@ config PCMCIA_DEBUG
> >  config PCMCIA
> >  	tristate "16-bit PCMCIA support"
> >  	select CRC32
> > -	select HAVE_IDE
> >  	default y
> 
> I did this when introducing HAVE_IDE.
> But I do not recall why and the rationale for removing it
> seems fine to me.

IIRC it was needed for some arm platforms which don't select HAVE_IDE
explicetely but I don't know if this is still the case, pinging Russell.

> So patch looks good - but I have not investigated in detail.
> 
> 	Sam
