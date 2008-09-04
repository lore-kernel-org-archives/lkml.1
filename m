Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbYIDMi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbYIDMi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbYIDMhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:37:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52545 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756919AbYIDMhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:37:45 -0400
Date: Thu, 4 Sep 2008 13:37:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>
Subject: Re: [PATCH 4/9] ASoC: Blackfin: DMA Driver for AC97 sound chip
Message-ID: <20080904123741.GA13735@rakim.wolfsonmicro.main>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	Cliff Cai <cliff.cai@analog.com>
References: <1220516528-20301-1-git-send-email-cooloney@kernel.org> <1220516528-20301-5-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220516528-20301-5-git-send-email-cooloney@kernel.org>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 04:22:03PM +0800, Bryan Wu wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

A couple of coding standards nits below but please fix these as an
incremental patch to save on reviewing.

> +	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
> +		curr = sport_curr_offset_tx(sport) / sizeof(struct ac97_frame);
> +	else {
> +		curr = sport_curr_offset_rx(sport) / sizeof(struct ac97_frame);
> +
> +	}

Don't need the { }.

> +	ret = snd_pcm_hw_constraint_integer(runtime, \
> +			SNDRV_PCM_HW_PARAM_PERIODS);
> +	if (ret < 0)
> +		goto out;

No need for the line continuation here.
