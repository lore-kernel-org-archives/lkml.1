Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab0AOO1Q (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204Ab0AOO1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:27:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:4220 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab0AOO1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:27:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T3qkl2ANZBFgRp+g9LHG+w8tfY5/nFW6JrJa5xciPrlqH/igOzW1wqQk2yl5EQanVk
         pvJpBHVOOhL9fy70TZlr2mGxzedvtz735pcO3q64gIRNTaK2ATnhZnzOrdPgJVGQorJW
         vspyJJlgaiq4ckjlWWpffyEWblCdJAibGIKro=
MIME-Version: 1.0
In-Reply-To: <4B50778F.2010405@gmail.com>
References: <4B50778F.2010405@gmail.com>
Date: Fri, 15 Jan 2010 09:27:12 -0500
Message-ID: <a728f9f91001150627t654e837fo3e5fbfcebb90929b@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon/kms: crtc_ omitted in display assignments in 
	radeon_atom_mode_fixup()?
From: Alex Deucher <alexdeucher@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 9:11 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> The crtc_ prefix was omitted in h/vdisplay assignments
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Not sure, but maybe the change below is needed? please ack/nack.

NAK.  the code is correct as is.

>
> diff --git a/drivers/gpu/drm/radeon/radeon_encoders.c b/drivers/gpu/drm/radeon/radeon_encoders.c
> index 82eb551..a9dc073 100644
> --- a/drivers/gpu/drm/radeon/radeon_encoders.c
> +++ b/drivers/gpu/drm/radeon/radeon_encoders.c
> @@ -233,8 +233,8 @@ static bool radeon_atom_mode_fixup(struct drm_encoder *encoder,
>                if (!ASIC_IS_AVIVO(rdev)) {
>                        adjusted_mode->hdisplay = mode->hdisplay;
>                        adjusted_mode->vdisplay = mode->vdisplay;
> -                       adjusted_mode->crtc_hdisplay = mode->hdisplay;
> -                       adjusted_mode->crtc_vdisplay = mode->vdisplay;
> +                       adjusted_mode->crtc_hdisplay = mode->crtc_hdisplay;
> +                       adjusted_mode->crtc_vdisplay = mode->crtc_vdisplay;
>                }
>                adjusted_mode->base.id = mode_id;
>        }
>
> ------------------------------------------------------------------------------
> Throughout its 18-year history, RSA Conference consistently attracts the
> world's best and brightest in the field, creating opportunities for Conference
> attendees to learn about information security's most important issues through
> interactions with peers, luminaries and emerging and established companies.
> http://p.sf.net/sfu/rsaconf-dev2dev
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>
