Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXGXFsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXGXFsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 01:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbXGXFs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 01:48:29 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55404 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbXGXFs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 01:48:29 -0400
Date: Tue, 24 Jul 2007 07:49:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kconfig:  Remove top level menu "Code maturity level options"
Message-ID: <20070724054943.GA12946@uranus.ravnborg.org>
References: <200707210658.28241.a1426z@gawab.com> <20070723165813.20848a85.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723165813.20848a85.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 04:58:13PM -0700, Andrew Morton wrote:
> On Sat, 21 Jul 2007 06:58:28 +0300
> Al Boldi <a1426z@gawab.com> wrote:
> 
> > 
> > This patch removes the top level menu "Code maturity level options", and 
> > moves its options into menu "General setup".
> > 
> > This makes Kconfig less cluttered and easier to setup.
> > 
> > 
> > Cc: Andrew Morton <akpm@osdl.org>
> > Signed-off-by: Al Boldi <a1426z@gawab.com>
> > 
> > ---
> > --- a/init/Kconfig	2007-07-09 06:38:47.000000000 +0300
> > +++ b/init/Kconfig	2007-07-21 06:42:06.000000000 +0300
> > @@ -7,7 +7,7 @@ config DEFCONFIG_LIST
> >  	default "/boot/config-$UNAME_RELEASE"
> >  	default "arch/$ARCH/defconfig"
> >  
> > -menu "Code maturity level options"
> > +menu "General setup"
> >  
> >  config EXPERIMENTAL
> >  	bool "Prompt for development and/or incomplete code/drivers"
> > @@ -61,9 +61,6 @@ config INIT_ENV_ARG_LIMIT
> >  	  Maximum of each of the number of arguments and environment
> >  	  variables passed to init from the kernel command line.
> >  
> > -endmenu
> > -
> > -menu "General setup"
> >  
> >  config LOCALVERSION
> >  	string "Local version - append to kernel release"
> 
> OK (IMO).  The "Code maturity level options" menu only has a single
> entry, and I doubt if it will grow more entries any time soon.  It
> makes sense to kill it and to move its sole entry into "General setup".

Agreed. These should be a reason for a menu and a single entry is not enough.
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
