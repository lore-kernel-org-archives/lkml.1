Return-Path: <linux-kernel-owner+w=401wt.eu-S1766608AbXEDUwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766608AbXEDUwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766611AbXEDUwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:52:23 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:60703 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766608AbXEDUwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:52:22 -0400
Date: Fri, 4 May 2007 22:52:13 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Stefan Roese <ml@stefan-roese.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Correct location for ADC/DAC drivers
Message-ID: <20070504205213.GQ22585@pengutronix.de>
References: <200705011435.45046.ml@stefan-roese.de> <20070504082434.GA22585@pengutronix.de> <200705041054.05650.ml@stefan-roese.de> <200705041421.50830.rgetz@blackfin.uclinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200705041421.50830.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin,

On Fri, May 04, 2007 at 02:21:50PM -0400, Robin Getz wrote:
> We also have DAC and ADC drivers (up to 16 bits @ 64MS/s, via DMA),
> that would be nice to put in the "right" place  - I don't think that
> drivers/char is the right place, nor drivers/misc - I also don't think
> that /adc is a descriptive place for DAC or mixed signal front ends
> (MxFE).

What userspace interface do your drivers have? I don't think that there
is anything generic available at the moment, other than COMEDI (which is
rather outdated as far as I know).
 
> What about /drivers/char/daq or just drivers/daq - drivers for
> non-PCI/USB/ISA/PCMCIA Data Acquisition Hardware, D/A and A/D
> converters, Analog Front ends, etc.

I'd like drivers/daq better, because it doesn't have anything to do with
the bus it is connected to; a chipselect bus connectable ADC may be
connected to a SoC CS-bus or to a PCI bridge and you want to use the
same driver for it.

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

