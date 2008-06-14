Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYFNP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYFNP6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbYFNP6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 11:58:00 -0400
Received: from server.drzeus.cx ([85.8.24.28]:42683 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753122AbYFNP57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 11:57:59 -0400
Date: Sat, 14 Jun 2008 17:57:23 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jochen Friedrich <jochen@scram.de>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC v3] OF: OpenFirmware bindings for the mmc_spi
 driver
Message-ID: <20080614175723.209e93dc@mjolnir.drzeus.cx>
In-Reply-To: <20080605161624.GA517@polina.dev.rtsoft.ru>
References: <20080605161624.GA517@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.2; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008 20:16:24 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> Here is v3. I'm out of ideas if you won't like it. :-)
> 
> v3:
> - Now these bindings are using bus notifiers chain, thus we adhere to the
>   spi bus.
> 

Now this was nice and clean. I take it Grant doesn't like this version
though. What's the downside of it?

> 
> - Plus changed the OF bindings themselves, implemented voltage-range
>   property. (Pierre, please take a look at vddrange_to_ocrmask(). I
>   wonder if you would like this in the MMC core instead, with a kernel
>   doc, of course.)
> 

That might be a good idea in the long run. MMC OCR masks have some
gotchas, so it's best if we have as few pieces of code as possible
dealing with it.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Use end-to-end encryption where
  possible.
