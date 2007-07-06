Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbXGFSa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbXGFSa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761351AbXGFSaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:30:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:36594 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760891AbXGFSaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:30:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=srQu/kNTOksVcA1+a1Ea5hJYS/S12PRoJCBiBq0PyLzeVyK06t3ccWNGcB/fERpXtFko3J0+vNaXT42butUUXsqC1r3TPiFr6Xx4IbR74DsvJQdgmJOU+8KPAXiUVVnAJHAkEL7MOGkdJJmfH0sl/2URkvMW26fhrsOhzXsl28A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: PATA-disk named sda
Date: Fri, 6 Jul 2007 20:47:10 +0200
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>,
       Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       linux-kernel@vger.kernel.org
References: <fa.VMMtK2yPXE5gkxuIC8MWb1aPBiQ@ifi.uio.no> <468E5420.7090605@shaw.ca> <468E82C8.7060204@rtr.ca>
In-Reply-To: <468E82C8.7060204@rtr.ca>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707062047.10265.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 July 2007, Mark Lord wrote:
> Robert Hancock wrote:
> >..
> > Currently the DMA, multi-sector mode, etc. are not controllable with 
> > hdparm with libata. libata is designed to use the fastest settings 
> > possible by default. In a lot of cases this messing with hdparm was only 
> > needed because of stupidity with the old IDE code (like DMA not being 
> > automatically enabled if the low-level driver was built modular).
> 
> Actually, most of the hdparm flags were put there to help test the IDE
> subsystem and to help debug the much stranger hardware it had to deal with.
> 
> "DMA off by default" was a Linus Torvalds request, to help ensure data safety
> with all of the weird and wonderful crap pre-standardization.

Exactly as Mark says.

I just want to add that "DMA off by default" hasn't been a case for a long
time now and since 2.6.21 the config option for "DMA on by default" is also
finally gone (to make a long story short: this was the best way to fix some
bugs while not causing regressions, not to mention that it was defaulting
to Y for years).

Thanks,
Bart
