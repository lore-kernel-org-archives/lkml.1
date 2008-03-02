Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYCBTXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYCBTXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbYCBTXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:23:43 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:9784 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYCBTXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:23:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A8dZRMOpfIHF8ryEhprhRByZlOyXobNLSqtFiTfd1IOOMb3qy+siD4e4XzhAuqnzMOPwPQBAk99/ONsQC4FwLS3kRplSJ9sugbs0C6MzEn3gd1UylzPk8sUd4D1pWqApgFj/7zVa8g6UvuJC+Cl/JfytsltPxrs3An/Anmh/p7o=
Message-ID: <a728f9f90803021123i4feacd07k9b5baa94107d46cf@mail.gmail.com>
Date: Sun, 2 Mar 2008 14:23:41 -0500
From: "Alex Deucher" <alexdeucher@gmail.com>
To: "Jonathan McDowell" <noodles@earth.li>
Subject: Re: 2.6.25-rc3 + RS690 + DRM + xf86-video-ati hang
Cc: xorg-driver-ati@lists.x.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080301193511.GP9009@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080301193511.GP9009@earth.li>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 1, 2008 at 2:35 PM, Jonathan McDowell <noodles@earth.li> wrote:
> If I enable CONFIG_DRM_RADEON under 2.6.25-rc3 then starting up
>  X using the xf86-video-ati driver (6.8.0 or latest git) causes the
>  machine to become unresponsive; while it still pings and will accept
>  incoming connections they never actually complete and it's not possible
>  to login over a serial console (the actual video console doesn't display
>  anything and the monitor reports a loss of sync).
>
>  Disabling the kernel DRM option results in X running successfully.
>  Likewise 2.6.24 works fine with DRM enabled, presumably because the
>  support for the RS690 was only added in 2.6.25-rc
>
>  The last messages from the kernel before it becomes unresponsive are:
>
>  [drm] Setting GART location based on new memory map
>  [drm] Loading R300 Microcode
>  [drm] writeback test succeeded in 1 usecs
>
>  The motherboard in question is an ASUS M2A-VM HDMI, with the analog VGA
>  output being used. The machine is running an AMD64 with Debian unstable.
>  I have put the output of lspci, a non drm Xorg.log and a drm Xorg.log
>  at:
>
>  http://the.earth.li/~noodles/xorg-ati-drm/lspci
>  http://the.earth.li/~noodles/xorg-ati-drm/Xorg.0.log-nodrm
>  http://the.earth.li/~noodles/xorg-ati-drm/Xorg.0.log-drm
>
>  If I can provide any more useful information please let me know.

Unfortunately, drm support on recent IGP chips is a little shaky at
the moment.  In some cases it helps to change the bios vram options to
a fixed vram size rather than setting it to "auto".

Alex
