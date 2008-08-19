Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYHSGP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYHSGP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYHSGPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:15:13 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYHSGPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:15:11 -0400
Message-ID: <3ef3fed769e5aa57681bacea1230e82b.squirrel@secure.sipsolutions.net>
In-Reply-To: <48AA407C.8090409@gmail.com> 
References: <48AA407C.8090409@gmail.com>
Date: Tue, 19 Aug 2008 08:15:05 +0200 (CEST)
Subject: Re: [PATCH] duplicate SNDRV_PCM_FMTBIT_S{16,24}_BE
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "roel kluin" <roel.kluin@gmail.com>
Cc: linuxppc-dev@ozlabs.org, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-sips-origin: local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin wrote:
> untested, is it correct?

not a clue, do you know how long ago that was? :)
does the driver check endianness anywhere?

> duplicate SNDRV_PCM_FMTBIT_S{16,24}_BE
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/sound/aoa/codecs/snd-aoa-codec-tas.c
> b/sound/aoa/codecs/snd-aoa-codec-tas.c
> index 7a16a33..c922505 100644
> --- a/sound/aoa/codecs/snd-aoa-codec-tas.c
> +++ b/sound/aoa/codecs/snd-aoa-codec-tas.c
> @@ -654,15 +654,15 @@ static struct snd_kcontrol_new bass_control = {
>  static struct transfer_info tas_transfers[] = {
>  	{
>  		/* input */
> -		.formats = SNDRV_PCM_FMTBIT_S16_BE | SNDRV_PCM_FMTBIT_S16_BE |
> -			   SNDRV_PCM_FMTBIT_S24_BE | SNDRV_PCM_FMTBIT_S24_BE,
> +		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S16_BE |
> +			   SNDRV_PCM_FMTBIT_S24_LE | SNDRV_PCM_FMTBIT_S24_BE,
>  		.rates = SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100 |
> SNDRV_PCM_RATE_48000,
>  		.transfer_in = 1,
>  	},
>  	{
>  		/* output */
> -		.formats = SNDRV_PCM_FMTBIT_S16_BE | SNDRV_PCM_FMTBIT_S16_BE |
> -			   SNDRV_PCM_FMTBIT_S24_BE | SNDRV_PCM_FMTBIT_S24_BE,
> +		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S16_BE |
> +			   SNDRV_PCM_FMTBIT_S24_LE | SNDRV_PCM_FMTBIT_S24_BE,
>  		.rates = SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100 |
> SNDRV_PCM_RATE_48000,
>  		.transfer_in = 0,
>  	},
>
>

