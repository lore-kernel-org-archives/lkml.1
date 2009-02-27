Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbZB0Azo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbZB0Azo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZB0Aze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:55:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:43340 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZB0Azd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:55:33 -0500
MIME-Version: 1.0
In-Reply-To: <20090118152856.4179.91855.stgit@vmbox.hanneseder.net>
References: <20090118152725.4179.40835.stgit@vmbox.hanneseder.net>
	 <20090118152856.4179.91855.stgit@vmbox.hanneseder.net>
Date: Fri, 27 Feb 2009 01:55:30 +0100
Message-ID: <154e089b0902261655j17cf1fc3vaf254d0c2af74616@mail.gmail.com>
Subject: Re: [PATCH 3/3] drivers/gpu/drm: comment out dead code
From: Hannes Eder <hannes@hanneseder.net>
To: dri-devel@lists.sourceforge.net, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added To]

On Sun, Jan 18, 2009 at 4:28 PM, Hannes Eder <hannes@hanneseder.net> wrote:
> The functions:
>
>  drm_crtc_from_fb
>  drm_mode_validate_clocks
>
> are not used, so comment them out.
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  drivers/gpu/drm/drm_crtc.c  |    2 ++
>  drivers/gpu/drm/drm_modes.c |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index d378306..c44bbde 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -254,6 +254,7 @@ void *drm_mode_object_find(struct drm_device *dev, uint32_t id, uint32_t type)
>  }
>  EXPORT_SYMBOL(drm_mode_object_find);
>
> +#ifdef UNUSED
>  /**
>  * drm_crtc_from_fb - find the CRTC structure associated with an fb
>  * @dev: DRM device
> @@ -278,6 +279,7 @@ static struct drm_crtc *drm_crtc_from_fb(struct drm_device *dev,
>        }
>        return NULL;
>  }
> +#endif /* UNUSED */
>
>  /**
>  * drm_framebuffer_init - initialize a framebuffer
> diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
> index c0cfe39..8ebcf51 100644
> --- a/drivers/gpu/drm/drm_modes.c
> +++ b/drivers/gpu/drm/drm_modes.c
> @@ -341,6 +341,7 @@ void drm_mode_validate_size(struct drm_device *dev,
>  }
>  EXPORT_SYMBOL(drm_mode_validate_size);
>
> +#ifdef UNUSED
>  /**
>  * drm_mode_validate_clocks - validate modes against clock limits
>  * @dev: DRM device
> @@ -376,6 +377,7 @@ static void drm_mode_validate_clocks(struct drm_device *dev,
>                        mode->status = MODE_CLOCK_RANGE;
>        }
>  }
> +#endif /* UNUSED */
>
>  /**
>  * drm_mode_prune_invalid - remove invalid modes from mode list
>
>
