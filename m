Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbZKIHrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbZKIHrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:47:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbZKIHrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:47:04 -0500
Received: from smtp.nokia.com ([192.100.105.134]:19574 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZKIHrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:47:02 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, "tony@atomide.com" <tony@atomide.com>
Subject: Re: [alsa-devel] [PATCH 2/4 v2] OMAP: Configure audio_mclk for twl4030-codec MFD
Date: Mon, 9 Nov 2009 09:46:46 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-gentoo-r4; KDE/4.3.2; i686; ; )
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1257321500-27049-1-git-send-email-peter.ujfalusi@nokia.com> <1257321500-27049-2-git-send-email-peter.ujfalusi@nokia.com> <1257321500-27049-3-git-send-email-peter.ujfalusi@nokia.com>
In-Reply-To: <1257321500-27049-3-git-send-email-peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911090946.46576.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 09 Nov 2009 07:46:54.0575 (UTC) FILETIME=[CE8627F0:01CA6110]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tony,

On Wednesday 04 November 2009 09:58:18 Ujfalusi Peter (Nokia-D/Tampere) wrote:
> audio_mclk value is going to be handled by the
> twl4030-codec MFD driver, configure the correct
> value for boards, which is using the twl4030 audio.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
> ---
>  arch/arm/mach-omap2/board-3430sdp.c      |    1 +
>  arch/arm/mach-omap2/board-omap3beagle.c  |    1 +
>  arch/arm/mach-omap2/board-omap3evm.c     |    1 +
>  arch/arm/mach-omap2/board-omap3pandora.c |    1 +
>  arch/arm/mach-omap2/board-overo.c        |    1 +
>  arch/arm/mach-omap2/board-zoom2.c        |    1 +
>  6 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-3430sdp.c
>  b/arch/arm/mach-omap2/board-3430sdp.c index 4f91f7a..9afd957 100644
> --- a/arch/arm/mach-omap2/board-3430sdp.c
> +++ b/arch/arm/mach-omap2/board-3430sdp.c
> @@ -415,6 +415,7 @@ static struct twl4030_codec_audio_data sdp3430_audio =
>  { };
> 
>  static struct twl4030_codec_data sdp3430_codec = {
> +	.audio_mclk = 26000000,
>  	.audio = &sdp3430_audio,
>  };
> 
> diff --git a/arch/arm/mach-omap2/board-omap3beagle.c
>  b/arch/arm/mach-omap2/board-omap3beagle.c index 2161d85..8f0c106 100644
> --- a/arch/arm/mach-omap2/board-omap3beagle.c
> +++ b/arch/arm/mach-omap2/board-omap3beagle.c
> @@ -259,6 +259,7 @@ static struct twl4030_codec_audio_data
>  beagle_audio_data = { };
> 
>  static struct twl4030_codec_data beagle_codec_data = {
> +	.audio_mclk = 26000000,
>  	.audio = &beagle_audio_data,
>  };
> 
> diff --git a/arch/arm/mach-omap2/board-omap3evm.c
>  b/arch/arm/mach-omap2/board-omap3evm.c index d9a6103..5bb30cb 100644
> --- a/arch/arm/mach-omap2/board-omap3evm.c
> +++ b/arch/arm/mach-omap2/board-omap3evm.c
> @@ -199,6 +199,7 @@ static struct twl4030_codec_audio_data
>  omap3evm_audio_data = { };
> 
>  static struct twl4030_codec_data omap3evm_codec_data = {
> +	.audio_mclk = 26000000,
>  	.audio = &omap3evm_audio_data,
>  };
> 
> diff --git a/arch/arm/mach-omap2/board-omap3pandora.c
>  b/arch/arm/mach-omap2/board-omap3pandora.c index 5036b56..77790ee 100644
> --- a/arch/arm/mach-omap2/board-omap3pandora.c
> +++ b/arch/arm/mach-omap2/board-omap3pandora.c
> @@ -286,6 +286,7 @@ static struct twl4030_codec_audio_data
>  omap3pandora_audio_data = { };
> 
>  static struct twl4030_codec_data omap3pandora_codec_data = {
> +	.audio_mclk = 26000000,
>  	.audio = &omap3pandora_audio_data,
>  };
> 
> diff --git a/arch/arm/mach-omap2/board-overo.c
>  b/arch/arm/mach-omap2/board-overo.c index dc55008..e1fb504 100644
> --- a/arch/arm/mach-omap2/board-overo.c
> +++ b/arch/arm/mach-omap2/board-overo.c
> @@ -334,6 +334,7 @@ static struct twl4030_codec_audio_data overo_audio_data
>  = { };
> 
>  static struct twl4030_codec_data overo_codec_data = {
> +	.audio_mclk = 26000000,
>  	.audio = &overo_audio_data,
>  };
> 
> diff --git a/arch/arm/mach-omap2/board-zoom2.c
>  b/arch/arm/mach-omap2/board-zoom2.c index f1b4e7c..de3a38d 100644
> --- a/arch/arm/mach-omap2/board-zoom2.c
> +++ b/arch/arm/mach-omap2/board-zoom2.c
> @@ -234,6 +234,7 @@ static struct twl4030_codec_audio_data zoom2_audio_data
>  = { };
> 
>  static struct twl4030_codec_data zoom2_codec_data = {
> +	.audio_mclk = 26000000,
>  	.audio = &zoom2_audio_data,
>  };
> 
> --
> 1.6.5.2

Can you take a look at this patch?
The rest of the series has already got Ack from Samuel and Mark, and only your 
verdict for the OMAP part is missing.

Thank you, 
Péter
