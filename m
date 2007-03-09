Return-Path: <linux-kernel-owner+w=401wt.eu-S1767369AbXCIQa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767369AbXCIQa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767370AbXCIQa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:30:57 -0500
Received: from mail.emacinc.com ([63.245.244.68]:60345 "EHLO mail.emacinc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767369AbXCIQa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:30:56 -0500
From: NZG <ngustavson@emacinc.com>
Organization: EMAC.Inc
To: David Brownell <david-b@pacbell.net>
Date: Fri, 9 Mar 2007 10:31:19 -0600
User-Agent: KMail/1.9.5
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200703070955.31370.david-b@pacbell.net>
In-Reply-To: <200703070955.31370.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703091031.19758.ngustavson@emacinc.com>
X-SA-Exim-Connect-IP: 63.245.244.67
X-SA-Exim-Mail-From: ngustavson@emacinc.com
Subject: Re: passing function pointers through platform devices?
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Spam-Relay: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2007 11:55 am, David Brownell wrote:
> > I'm developing an SPI- bus >MMC/SD block driver translation layer.
>
> Another one?  There's already been significant work in that area.  See for
> example
>
>   http://marc.theaimsgroup.com/?l=linux-kernel&m=117000652529003&w=2
Nice, I'll build on that, my previous work ignored the SPI/MMC layers (because 
they didn't exist at the time) and just build a stacked driver on a character 
SPI driver.  This gives me some direction as to how to proceed.

> Which admittedly didn't behave when I just put it onto my test rig,
> but seems nonetheless to be a significant step forward.  It's not like
> everyone has hardware that can use such a driver after all!
True, but it's fairly common right now, until every microcontroller gets a 
hardware SD controller (which seems to be the trend)

> That's how it's done in that patch.  The model being what the PXA MMC/SD
> card driver does, since that's the most generic model I found ... handling
> for example systems which need to poll for card detect, as well as ones
> that can use real gpio based IRQs.  The mmc_spi driver doesn't need to know
> which kind of platform it's got.
Sounds good, thanks

NZG

