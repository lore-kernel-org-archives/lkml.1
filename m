Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbXJXVIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbXJXVIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXJXVIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:08:32 -0400
Received: from outbound-mail-63.bluehost.com ([69.89.21.23]:56992 "HELO
	outbound-mail-63.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752590AbXJXVIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:08:31 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC] full suspend/resume support for i915 DRM driver
Date: Wed, 24 Oct 2007 14:07:08 -0700
User-Agent: KMail/1.9.7
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200710181401.50470.jbarnes@virtuousgeek.org> <200710222115.44549.jbarnes@virtuousgeek.org> <20071024201712.GH30533@stusta.de>
In-Reply-To: <20071024201712.GH30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710241407.08792.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 24, 2007 1:17 pm Adrian Bunk wrote:
> > diff --git a/linux-core/Kconfig b/linux-core/Kconfig
> > index 2d02c76..5e73fc7 100644
> > --- a/linux-core/Kconfig
> > +++ b/linux-core/Kconfig
> > @@ -50,7 +50,7 @@ config DRM_I810
> >
> >  choice
> >  	prompt "Intel 830M, 845G, 852GM, 855GM, 865G"
> > -	depends on DRM && AGP && AGP_INTEL
> > +	depends on DRM && AGP && AGP_INTEL && !FB_INTEL
> >  	optional
> >...
>
> This sounds like a bad regression.

Well it's really documenting existing behavior.  Unless you're very 
careful, running custom applications, the Intel FB and DRM drivers will 
conflict.  IMO this is a long overdue change, but Dave has some custom 
stuff that requires both drivers so he'd rather not see it go in, so 
I'm fine with dropping this part.

Jesse
