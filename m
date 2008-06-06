Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbYFFPJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbYFFPJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbYFFPJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:09:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4542 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbYFFPJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:09:43 -0400
Date: Fri, 6 Jun 2008 16:09:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, perex@perex.cz, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ac97: add support for wm9711 master left inv switch
Message-ID: <20080606150941.GF24872@sirena.org.uk>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	linux-kernel@vger.kernel.org, perex@perex.cz,
	alsa-devel@alsa-project.org
References: <Pine.LNX.4.64.0806061659550.3338@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806061659550.3338@axis700.grange>
X-Cookie: Non-sequiturs make me eat lampshades.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 05:02:57PM +0200, Guennadi Liakhovetski wrote:
> From: Juergen Beisert <j.beisert@pengutronix.de>
> 
> This patch adds support for Master Left Inv Switch on wm9711.
> At least required to drive the mono speaker on the PXA270 platfrom
> 
> Signed-off-by: Juergen Beisert <j.beisert@pengutronix.de>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Note that ALSA patches should really be CCed to the alsa-devel mailing
list (CC added).

>  sound/pci/ac97/ac97_patch.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/sound/pci/ac97/ac97_patch.c
> ===================================================================
> --- linux-2.6.orig/sound/pci/ac97/ac97_patch.c	2008-05-26 12:19:23.000000000 +0200
> +++ linux-2.6/sound/pci/ac97/ac97_patch.c	2008-05-27 13:23:11.000000000 +0200
> @@ -669,6 +669,7 @@
>  AC97_SINGLE("Mic 2 Volume", AC97_MIC, 0, 31, 1),
>  AC97_SINGLE("Mic 20dB Boost Switch", AC97_MIC, 7, 1, 0),
>  
> +AC97_SINGLE("Master Left Inv Switch", AC97_MASTER, 6, 1, 0),
>  AC97_SINGLE("Master ZC Switch", AC97_MASTER, 7, 1, 0),
>  AC97_SINGLE("Headphone ZC Switch", AC97_HEADPHONE, 7, 1, 0),
>  AC97_SINGLE("Mono ZC Switch", AC97_MASTER_MONO, 7, 1, 0),
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
