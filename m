Return-Path: <linux-kernel-owner+w=401wt.eu-S1751573AbZHUAwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbZHUAwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 20:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbZHUAwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 20:52:13 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:59541 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZHUAwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 20:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lKeDufTaEz9HwTIWDnGrEOteW1nR9de8x2vVqbmqO3PjAVh4oMMXeFu+6VuJ8nw+Wm
         NUJgkePbBaMAIr+9Cqf38PfE2RGNxqLX7dPh5XTvwrg361ahlVGOOyIK0v8kDKjvehVG
         EsET+QlWQOgRyN0mn1DxeV0I50V4LqrpTJ/mY=
MIME-Version: 1.0
In-Reply-To: <s5hpraqobuf.wl%tiwai@suse.de>
References: <s5hpraqobuf.wl%tiwai@suse.de>
Date: Fri, 21 Aug 2009 10:52:13 +1000
Message-ID: <21d7e9970908201752y352f194byf10bd786dd2d383b@mail.gmail.com>
Subject: Re: [PATCH] drm/kms/radeon: Add kconfig to specify the default 
	modesetting
From: Dave Airlie <airlied@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: David Airlie <airlied@linux.ie>, gregkh@suse.de,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 11:26 PM, Takashi Iwai<tiwai@suse.de> wrote:
> This patch adds a Kconfig item to specify the default radeon modeset
> value.  Also fixed the description of CONFIG_DRM_RADEON_KMS.
>
> Since KMS gives problems on some Radeon devices, it's safer to disable
> it as default on distro kernels.  But distros would love to include the
> feature itself instead of disabling KMS completely.
>
> Reference: Novell bnc#527910
>        https://bugzilla.novell.com/show_bug.cgi?id=527910

I'm sort of torn on this, when radeon KMS moves out of staging it will
be disabled by
default using the current option. It will build everything always and
disable/enable like this patch
does. I'm not willing to do that yet esp now in -rcX time as it might
break builds
on some other arches.

So if a distro isn't shipping a compatible userspace, I'd rather they
didn't ship
the kernel support built at all until we move it from staging.

AFAIK you guys don't use -ati on a lot of cards kms is useful so I'm
not sure when you'll
ever have a compatible userspace.

Dave.
