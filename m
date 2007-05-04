Return-Path: <linux-kernel-owner+w=401wt.eu-S1767736AbXEDIYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767736AbXEDIYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767734AbXEDIYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:24:41 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:51451 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767736AbXEDIYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:24:39 -0400
Date: Fri, 4 May 2007 10:24:34 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Stefan Roese <ml@stefan-roese.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: Correct location for ADC/DAC drivers
Message-ID: <20070504082434.GA22585@pengutronix.de>
References: <200705011435.45046.ml@stefan-roese.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200705011435.45046.ml@stefan-roese.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 02:35:44PM +0200, Stefan Roese wrote:
> I'm in the stage of integrating some ADC and DAC drivers for the AMCC
> 405EZ PPC and looking for the correct location to place these drivers
> in the Linux source tree. The drivers are basically character-drivers,
> so my first thought is to put them in "drivers/char/adc/foo.c" or
> "drivers/char/adc_foo.c". Is this a good solution?
> 
> Any suggestions welcome (could be that I missed an already existing
> example).
> 
> BTW: I am aware of the hwmon subsystem, but I don't think it fits my
> needs in this case.

Could you elaborate the requirements a bit more? ADC is not ADC, because
slow i2c ADCs which measure a temperature every five minutes have other
requirements than multi-megabyte-per-second-dma-driven ADCs.

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

