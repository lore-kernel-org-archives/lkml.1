Return-Path: <linux-kernel-owner+w=401wt.eu-S1762651AbZDCA16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762651AbZDCA16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZDCA1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:27:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:52764 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZDCA1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:27:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S1JhSrmGDE0RTICwbhitEY5UgVRdGR4abhdA9D/g0xnXuyuvxfZX4eES87nX6SXOLC
         75mNjSzpk8uMHEBTNnviO4NublTn0gws714Wfr0KrWyUya85OuMEdWw97/lYBJPixdDV
         a4//85n42xOg2iGd9dPzqwyefCjZuJc8PxXKg=
MIME-Version: 1.0
In-Reply-To: <20090402115224.069b0f23@hyperion.delvare>
References: <20090402115224.069b0f23@hyperion.delvare>
Date: Fri, 3 Apr 2009 10:27:48 +1000
Message-ID: <21d7e9970904021727s3ccb3ad2t7e071319b93d2c80@mail.gmail.com>
Subject: Re: [PATCH] DRM: drm_crtc_helper.h doesn't actually need i2c.h
From: Dave Airlie <airlied@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 7:52 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Remove an include that isn't actually needed to prevent needless
> rebuilds.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
> Patch already sent on:
>  * 2009-01-13
>  * 2009-02-25
> David, are you going to apply this patch or should I push it upstream
> myself?

Sorry kept missing it,

Applied now.

Dave.

>
>  include/drm/drm_crtc_helper.h |    1 -
>  1 file changed, 1 deletion(-)
>
> --- linux-2.6.29-rc1.orig/include/drm/drm_crtc_helper.h 2009-01-11 10:57:58.000000000 +0100
> +++ linux-2.6.29-rc1/include/drm/drm_crtc_helper.h      2009-01-13 16:50:20.000000000 +0100
> @@ -33,7 +33,6 @@
>  #ifndef __DRM_CRTC_HELPER_H__
>  #define __DRM_CRTC_HELPER_H__
>
> -#include <linux/i2c.h>
>  #include <linux/spinlock.h>
>  #include <linux/types.h>
>  #include <linux/idr.h>
>
>
> --
> Jean Delvare
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
