Return-Path: <linux-kernel-owner+w=401wt.eu-S1030756AbXBOT1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030756AbXBOT1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030757AbXBOT1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:27:49 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:48959 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030756AbXBOT1s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:27:48 -0500
Date: Thu, 15 Feb 2007 14:27:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] MARKERS should depend on, not select MODULES
Message-ID: <20070215192745.GD31359@Krystal>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org> <20070215150123.GA13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070215150123.GA13958@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 14:24:42 up 13 days,  9:32,  7 users,  load average: 1.09, 1.19, 1.24
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@stusta.de) wrote:
> On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.20-rc6-mm3:
> >...
> > +linux-kernel-markers-kconfig-menus.patch
> >...
> >  Linux Kenrel Markers
> >...
> 
> Never ever select MODULES.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
> 
> BTW: Can we get in-kernel users?
> 

It could apply to any subsystems that needs hooks. (selinux?)


> --- linux-2.6.20-mm1/kernel/Kconfig.marker.old	2007-02-15 15:54:10.000000000 +0100
> +++ linux-2.6.20-mm1/kernel/Kconfig.marker	2007-02-15 15:54:27.000000000 +0100
> @@ -2,8 +2,7 @@
>  
>  config MARKERS
>  	bool "Activate markers"
> -	select MODULES
> -	default n
> +	depends on MODULES
>  	help
>  	  Place an empty function call at each marker site. Can be
>  	  dynamically changed for a probe function.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, École Polytechnique de Montréal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
