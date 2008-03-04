Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbYCDROB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbYCDROB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYCDRNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:13:53 -0500
Received: from hu-out-0506.google.com ([72.14.214.233]:2055 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbYCDRNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:13:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N1ryUoZ2SkDrMLMiuCzdE+gmNUhfkMW6Yu+y596tQQVkFksw1IPxu/JoHf7Bk+TSYBj7rVLOlrDxG3F/8/PzknKtr2AyHV78Pmb9RgtDlIbvn+wxpIv1AkwAMpSi49O2DYzYhMdU2Eg7vJbX3h/BomNOAoZUMiPiCPgCyYHtuc8=
Message-ID: <226dee610803040913h4718b61r4310fa78938bc386@mail.gmail.com>
Date: Tue, 4 Mar 2008 22:43:50 +0530
From: "JoJo jojo" <onetwojojo@gmail.com>
To: "Dave Airlie" <airlied@linux.ie>
Subject: Re: 2.6.25-rc3 + RS690 + DRM + xf86-video-ati hang
Cc: "Jonathan McDowell" <noodles@earth.li>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       xorg-driver-ati@lists.x.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.82.0803041120400.24971@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080301193511.GP9009@earth.li>
	 <20080303224830.28e98b2b.akpm@linux-foundation.org>
	 <alpine.DEB.0.82.0803040816180.24971@skynet.skynet.ie>
	 <20080304085155.GX9009@earth.li>
	 <alpine.DEB.0.82.0803041120400.24971@skynet.skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is 128 MB some sort of a sweet spot for ram allocated to gpu  ?
(hard coded?)

First Alex suggested that, & now you.

(asking 'coz i used 256 MB while testing)

-JoJo

On Tue, Mar 4, 2008 at 4:53 PM, Dave Airlie <airlied@linux.ie> wrote:
> >
>  > Is xf86-driver-ati 6.8.0 not a proper release? I'm pretty sure the
>  > combination of that, 2.6.25-rc3 and CONFIG_DRM_RADEON causes my machine
>  > to become unresponsive. I only tried a git build of the driver after the
>  > released version was causing issues.
>
>  Yes we made a mistake with 6.8.0 enabling DRI on rs680 chips before we
>  knew it worked for everyone, I may be still able to fix this in the kernel
>  but there is a good chance that it'll require a 6.8.1 userspace, I can't
>  do anything else about it..
>
>  Jonathan I appreciate the bug report, I'm more saying to Andrew that
>  getting DRI right on new chipsets is non-trivial as there are lot of
>  configurations we can't test until we actually push the code to users..
>  and in this case you are one of those..
>
>  you might try setting the VRAM in your BIOS to 128MB instead of Auto and
>  seeing it helps..
>
>  I'll be trying to fix the problem properly quite soon.
>
>  The correct workaround is to add Option "DRI" "Off" to xorg.conf or for me
>  to travel back in time and unrelease 6.8.0. Removing the kernel DRI
>  support will just break lots of working systems.
>
>  Dave.
>
>
>   >
>  > Replacing 2.6.25-rc3 with 2.6.24 (still with CONFIG_DRM_RADEON enabled)
>  > results in a machine that boots to GDM successfully. Likewise if I
>  > disable CONFIG_DRM_RADEON in 2.6.25-rc3 the machine boots to GDM ok.
>  >
>  > J.
>  >
>  >
>
>
> _______________________________________________
>  xorg-driver-ati mailing list
>  xorg-driver-ati@lists.x.org
>  http://lists.x.org/mailman/listinfo/xorg-driver-ati
>
