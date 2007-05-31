Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbXEaQU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbXEaQU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbXEaQUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:20:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:55320 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbXEaQUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:20:15 -0400
Date: Thu, 31 May 2007 18:20:13 +0200
From: Karsten Keil <kkeil@suse.de>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/06] Use menuconfig objects 4 - ISDN part 2/6 (CONFIG_ISDN_I4L)
Message-ID: <20070531162013.GA31575@pingi.kke.suse.de>
Mail-Followup-To: Tilman Schmidt <tilman@imap.cc>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net> <Pine.LNX.4.61.0705302137560.11140@yvahk01.tjqt.qr> <465EF4F4.1090507@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465EF4F4.1090507@imap.cc>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 06:16:52PM +0200, Tilman Schmidt wrote:
> Am 30.05.2007 21:38 schrieb Jan Engelhardt:
> > --- linux-2.6.22-rc3-git1.orig/drivers/isdn/Kconfig
> > +++ linux-2.6.22-rc3-git1/drivers/isdn/Kconfig
> > @@ -21,9 +21,7 @@ menuconfig ISDN
> >  
> >  if ISDN
> >  
> > -menu "Old ISDN4Linux"
> > -
> > -config ISDN_I4L
> > +menuconfig ISDN_I4L
> >  	tristate "Old ISDN4Linux (obsolete)"
> >  	---help---
> >  	  This driver allows you to use an ISDN-card for networking
> > @@ -44,8 +42,6 @@ if ISDN_I4L
> >  source "drivers/isdn/i4l/Kconfig"
> >  endif
> >  
> > -endmenu
> > -
> >  comment "CAPI subsystem"
> >  
> 
> This results in a rather strange and inconsistent presentation in
> "make xconfig", with ISDN4Linux appearing as a subtree in the left
> pane but CAPI only visible in the right pane after selecting ISDN.
> IMHO it looks much saner like this:
> 
> --- a/drivers/isdn/Kconfig
> +++ b/drivers/isdn/Kconfig
> @@ -21,8 +21,6 @@ menuconfig ISDN
> 
>  if ISDN
> 
> -menu "Old ISDN4Linux"
> -
>  config ISDN_I4L
>  	tristate "Old ISDN4Linux (deprecated)"
>  	---help---
> @@ -44,12 +42,8 @@ if ISDN_I4L
>  source "drivers/isdn/i4l/Kconfig"
>  endif
> 
> -endmenu
> -
> -comment "CAPI subsystem"
> -
>  config ISDN_CAPI
> -	tristate "CAPI2.0 support"
> +	tristate "CAPI 2.0 subsystem"
>  	help
>  	  This provides the CAPI (Common ISDN Application Programming
>  	  Interface, a standard making it easy for programs to access ISDN
> 
> This gives you a single entry in the left pane tree for disabling
> all of ISDN with a single click, and nicely presents all of its
> suboptions in the right pane once you select the tree entry.
> 

I agree.


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
