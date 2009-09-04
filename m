Return-Path: <linux-kernel-owner+w=401wt.eu-S933877AbZIDTVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbZIDTVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbZIDTVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:21:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58341 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751195AbZIDTVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:21:21 -0400
Date: Fri, 4 Sep 2009 20:21:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-kernel@vger.kernel.org,
       kernel@pengutronix.de, armlinux@phytec.de
Subject: Re: [PATCH] linux-next: fix pxa2xx-ac97.c breakage
Message-ID: <20090904192121.GA13497@rakim.wolfsonmicro.main>
References: <20090904191635.GI29655@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904191635.GI29655@pengutronix.de>
X-Cookie: No lifeguard on duty.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 09:16:36PM +0200, Robert Schwebel wrote:
> Today's linux-next fails to build with

>   sound/arm/pxa2xx-ac97.c: In function 'pxa2xx_ac97_probe':
>   sound/arm/pxa2xx-ac97.c:211: error: 'pxa2xx_audio_ops_t' has no member named 'codec_data'
>   make[2]: *** [sound/arm/pxa2xx-ac97.o] Error 1

> It looks like commit e2365bf313fb21b49b1e4c911033389564428d03 has
> introduced this; patch below.

Applied, thanks.
