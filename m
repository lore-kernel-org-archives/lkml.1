Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbYGDEGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbYGDEGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 00:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbYGDEGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 00:06:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:58247 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYGDEGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 00:06:24 -0400
Date: Thu, 3 Jul 2008 22:05:50 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Chen Gong <G.Chen@freescale.com>
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, david-b@pacbell.net,
       fabrizio.garetto@gmail.com
Subject: Re: [PATCH v2 3/5] of-bindings: Add binding documentation for SPI
	bussesand devices
Message-ID: <20080704040550.GG12945@secretlab.ca>
References: <20080703005749.26187.71719.stgit@trillian.secretlab.ca> <20080703010308.26187.23037.stgit@trillian.secretlab.ca> <58A20A281BAF1047B4EAE68DE5C0BDC2010121B9@zch01exm21.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58A20A281BAF1047B4EAE68DE5C0BDC2010121B9@zch01exm21.fsl.freescale.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 11:59:07AM +0800, Chen Gong wrote:
> > +    - reg             - (required) chip select address of device.
> > +    - compatible      - (required) name of SPI device 
> > following generic names
> > +			recommended practice
> > +    - max-speed       - (required) Maximum SPI clocking 
> > speed of device in Hz
> > +    - spi,cpol        - (optional) Device requires inverse 
> > clock polarity
> > +    - spi,cpha        - (optional) Device requires shifted 
> > clock phase
> > +    - linux,modalias  - (optional, Linux specific) Force 
> > binding of SPI device
> > +			to a particular spi_device driver.  
> > Useful for changing
> > +			driver binding between spidev and a 
> > kernel SPI driver.
> > +
> 
> How about adding a "model" property to describe actual devie type.
> Such as using a "sst25vf040b" device with spi-interface, we can
> use model="sst25vf040b" to describe it.

That's what "compatible" is for.  First value in the compatible list is
the actual device, followed by devices it is compatible with.  In
your particular example, the value would be "sst,sst25vf040b" so that it
follows device tree conventions.

g.
