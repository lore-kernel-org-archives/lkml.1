Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbZFUBde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbZFUBde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 21:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZFUBd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 21:33:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54314 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbZFUBdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 21:33:25 -0400
Date: Sun, 21 Jun 2009 02:33:26 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm: previous pull req + 1.
In-Reply-To: <1245542690.6104.6.camel@localhost>
Message-ID: <alpine.DEB.2.00.0906210228190.23021@skynet.skynet.ie>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie> <1245542690.6104.6.camel@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Please pull the 'drm-linus' branch from
> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> > 
> > This is the same tree from the previous pull request + the fix from Pierre 
> > that actually makes the PAE/GEM combination on i965 work. \o/
> 
> Something from this tree breaks my i965.
> Using -git just before this was pulled,
> 
>  a552f0af753eb4b5bbbe9eff205fe874b04c4583 works, but using latest git
> 
> makes google earth stall, it doesn't update its main window. It appears
> that openining and closing its menu, allows it to progress frame after
> frame. No crashes hangs however.
> 
> Used latest -git of all graphic components (mesa, libdrm, xserver, intel
> driver)
> 
> KMS is used, as well as UXA and DRI2 (this is enabled by default now)

Wierd I'm not seeing anything in there that would just break something 
like googleearth, and still leave compiz going, I think a git bisect on 
the drivers/gpu/drm/i915 subdir should work.

Were you running a PAE kernel before now?

Dave.

> 
> 
> Compiz used as well, but this happens without it as well.
> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
