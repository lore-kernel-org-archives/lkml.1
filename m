Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbYIEMse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbYIEMse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYIEMsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:48:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1457 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbYIEMsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:48:25 -0400
Date: Fri, 5 Sep 2008 13:48:22 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 3/9] ASoC: Blackfin: DMA Driver for AC97 sound chip
Message-ID: <20080905124821.GG12383@sirena.org.uk>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>,
	Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
References: <1220610102-7716-1-git-send-email-cooloney@kernel.org> <1220610102-7716-4-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220610102-7716-4-git-send-email-cooloney@kernel.org>
X-Cookie: Universe, n.:
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 06:21:36PM +0800, Bryan Wu wrote:

> +static int bf5xx_pcm_open(struct snd_pcm_substream *substream)
> +{
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +	int ret;
> +
> +	pr_debug("%s enter\n", __func__);
> +	snd_soc_set_runtime_hwparams(substream, &bf5xx_pcm_hardware);
> +
> +	ret = snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
> +	if (ret < 0)
> +		goto out;

This change now goes over 80 columns...  I'll fix this up locally.
