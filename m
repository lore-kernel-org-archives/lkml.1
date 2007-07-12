Return-Path: <linux-kernel-owner+w=401wt.eu-S1762957AbXGLXR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762957AbXGLXR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759429AbXGLXRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:17:18 -0400
Received: from waste.org ([66.93.16.53]:59065 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758381AbXGLXRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:17:17 -0400
Date: Thu, 12 Jul 2007 18:16:45 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rob Landley <rob@landley.net>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Start to genericize kconfig for use by other projects.
Message-ID: <20070712231645.GY11166@waste.org>
References: <200707111522.14240.rob@landley.net> <Pine.LNX.4.64.0707121820110.1817@scrub.home> <200707121444.18599.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707121444.18599.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 02:44:18PM -0400, Rob Landley wrote:
> On Thursday 12 July 2007 12:28:39 pm Roman Zippel wrote:
> > Hi,
> >
> > On Wed, 11 Jul 2007, Rob Landley wrote:
> > > Replace name "Linux Kernel" in menuconfig with a macro (defaulting to
> > > "Linux Kernel" if not -Ddefined by the makefile), and remove a few
> > > unnecessary occurrences of "kernel" in pop-up text.
> >
> > Could you drop the PROJECT_NAME changes for now? The rest looks fine.
> > I would prefer if the project would be settable via Kconfig.
> 
> Are projects likely to grab a common kconfig binary externally, rather
> than build their own? 

Yes.

If you really want to share kconfig, it'd be better to break it off
into a separately packaged project. For the time being, the kernel
makefiles can look for it in path, then fall back to its own copy
which we can eventually drop.

-- 
Mathematics is the supreme nostalgia of our time.
