Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXA2AM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXA2AM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 19:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932982AbXA2AM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 19:12:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:56159 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978AbXA2AM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 19:12:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eEpNII7r+Plxn7aGr3/0dYKsE2G+g5ZauPO3zsh47NVnYfQTd0Jm3nIjFqUbUJxlZ7wVvCs3c/rJBieOSTSLSAqwpnScM+t8dz23/m7hlB3QyJ78j0aLcOksfx2cpN3fv6o+JB1y/Kj/ciSJI7pfxBZHeDJBOTfw4ShJnTAiBPY=
Message-ID: <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
Date: Mon, 29 Jan 2007 11:12:57 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070128160831.fb51347f.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ephv35$4i3$1@sea.gmane.org>
	 <20070128160831.fb51347f.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Some nVidia video cards have broken EDID information. Using nvidiafb
> > with CONFIG_FB_NVIDIA_I2C enabled on these systems causes the console
> > framebuffer to use wrong timing information, causing the display to be
> > extremely 'snowy'. Since most distribution kernels are compiled with
> > CONFIG_FB_NVIDIA_I2C enabled, this prevents usage of the nvidia
> > framebuffer on said broken system without recompiling the kernel
> > (or at least the nvidiafb module).
> >
> > Solve the issue by introducing a new boolean module parameter (useedid)
> > which can be set to 0 to prevent the driver from using the EDID
> > information.
> >
> > If this patch is accepted, we can probably get rid of CONFIG_FB_NVIDIA_I2C
> > altogether.
> >
>
> That's a pretty sad solution.  Is it possible to detect these bad cards at
> runtime via ther behaviour?  If not, can we generate a blacklist for the
> known-bad cards based on PCI IDs or something?
>
> Because most users won't even be aware of the module option: they'll just
> know that their card doesn't work right.

This isn't a card problem this is a monitor problem, the card just
passes through the edid data from the monitor... or else the
programming of the card registers from edid is wrong..

Dave.
