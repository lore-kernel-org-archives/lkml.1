Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab0CBXRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:17:16 -0500
Received: from gir.skynet.ie ([193.1.99.77]:37772 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab0CBXRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:17:15 -0500
Date: Tue, 2 Mar 2010 23:16:59 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm request 2
In-Reply-To: <alpine.LFD.2.00.1003021459450.3616@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1003022305070.4099@skynet.skynet.ie>
References: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain> <alpine.LFD.2.00.1003021459450.3616@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-900477362-1267571819=:4099"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-900477362-1267571819=:4099
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

> 
> Never mind. I've unpulled the whole effin' mess since it doesn't even 
> compile:
> 
> 	drivers/gpu/drm/nouveau/nouveau_acpi.c:191: error: redefinition of ¡nouveau_register_dsm_handler¢
> 	drivers/gpu/drm/nouveau/nouveau_drv.h:859: note: previous definition of ¡nouveau_register_dsm_handler¢ was here
> 	drivers/gpu/drm/nouveau/nouveau_acpi.c:202: error: redefinition of ¡nouveau_unregister_dsm_handler¢
> 	drivers/gpu/drm/nouveau/nouveau_drv.h:860: note: previous definition of ¡nouveau_unregister_dsm_handler¢ was here
> 
> because not only was that VGA_SWITCHEROO Kconfig default the wrong way 
> around, the thing had clearly never ever been tested at all.
> 
> Why does sh*t like this even make it to me? Was this ever at all in -next? 
> I assume not, since that would have picked up on basic compile failures.
> 
> Grr. Things like this is what makes me go "Ok, there's always the next 
> merge window, maybe it will have gotten some testing by then".

Linux next didn't pick up this build failure, wierdly neither did the 
powerpc build I did with this turned off, because ACPI was also off on 
ppc, it was in linux-next for at least 2 days, and from what I can see 
that found the ppc problems, it never found the x86 option since it was on 
by default.

I'm going to just rip the nouveau bits out of the patch, btw nouveau is in 
staging, so you are being a bit OTT, calm down.

Dave.
--29444707-900477362-1267571819=:4099--
