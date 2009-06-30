Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbZF3Jj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbZF3Jj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZF3Jjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:39:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51193 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZF3Jjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:39:47 -0400
Date: Tue, 30 Jun 2009 10:39:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Jarkko Nikula <jhnikula@gmail.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] [RFC] ASoC: OMAP: fix OMAP1510 broken PCM
	pointer callback
Message-ID: <20090630093944.GB13961@sirena.org.uk>
References: <200906280021.05931.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906280021.05931.jkrzyszt@tis.icnet.pl>
X-Cookie: Only fools are quoted.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 12:21:05AM +0200, Janusz Krzysztofik wrote:
> This patch tries to work around the problem of broken OMAP1510 PCM playback 
> pointer calculation by replacing DMA function call that incorrectly tries to 
> read the value form DMA hardware with a value computed locally from an 
> already maintained variable omap_runtime_data.period_index.
> 
> Tested on OMAP5910 based Amstrad Delta (E3) using work in progress ASoC 
> driver.
> 
> Based on linux-2.6-asoc.git v2.6.31-rc1.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Applied, thanks.  Please CC me on ASoC patches.
