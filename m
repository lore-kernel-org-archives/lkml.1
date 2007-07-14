Return-Path: <linux-kernel-owner+w=401wt.eu-S1763747AbXGNTRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763747AbXGNTRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760816AbXGNTRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:17:43 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36455 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760365AbXGNTRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:17:42 -0400
Date: Sat, 14 Jul 2007 21:18:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Paprocki <andrew@ishiboo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Geode GX framebuffer driver: Arcom vs. AMD
Message-ID: <20070714191854.GD13823@uranus.ravnborg.org>
References: <76366b180707141201u14585c2eyeb58f0b7b279ea1b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76366b180707141201u14585c2eyeb58f0b7b279ea1b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 03:01:56PM -0400, Andrew Paprocki wrote:
> Is there any reason why the GPL framebuffer driver for the GX/GX1/LX
> directly from AMD is not integrated into the kernel and only a custom
> driver for only the GX/GX1 written by Arcom exists?
> (drivers/video/geode/*)
> 
> If you have an LX, the Arcom driver won't work and it is difficult to
> use AMD's patch for 2.6.11 with a more recent kernel because the
> drivers/video/geode directory has filename conflicts with files in the
> patch.
> 
> If there are no issues preventing its inclusion, would updated patches
> be accepted to switch to AMD's framebuffer driver? The AMD patches
> would need to be combined to support all three platforms in the driver
> dir, all sitting on top of the Cimarron HAL installed in lib/cimarron.
> 
> The entire AMD LX patch for 2.6.11 is here:
> http://www.amd.com/files/connectivitysolutions/geode/geode_lx/Patches_Linux2.6.11_Common_02.03.0100.patch

After a very brief look on the relevant part of the patch:
-> Needs to be adapted to CodingStyle all over.
-> The use of AMD specific BUILDNUM etc are not used in-kernel
-> The HAL in lib/cimarron needs to be justified - who are the oter users?
-> There seems to be a _lot_ of specific defines in lib/cimarron - I wonder
   if this is the way used in the rest of the kernel?

But anyway - the patch it not trivially ready for inclusion.

	Sam
