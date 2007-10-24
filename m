Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbXJXU0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbXJXU0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbXJXU0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:26:47 -0400
Received: from ns.suse.de ([195.135.220.2]:51830 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561AbXJXU0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:26:46 -0400
Date: Wed, 24 Oct 2007 13:21:17 -0700
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Buesch <mb@bu3sch.de>, Al Viro <viro@ftp.linux.org.uk>,
       David Brownell <dbrownell@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] usb: fix ssb_ohci_probe() build bug
Message-ID: <20071024202117.GA20463@suse.de>
References: <20071014032948.GA25760@elte.hu> <20071015173840.GA26109@elte.hu> <20071015174321.GA27428@elte.hu> <200710152008.49590.mb@bu3sch.de> <20071024194619.GA18309@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024194619.GA18309@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 09:46:19PM +0200, Ingo Molnar wrote:
> 
> * Michael Buesch <mb@bu3sch.de> wrote:
> 
> > >  CONFIG_SSB=m
> > >  CONFIG_USB_OHCI_HCD=y
> > >  CONFIG_USB_OHCI_HCD_SSB=y
> > > 
> > > the fix is to require a modular USB_OHCI_HCD build when SSB is modular.
> > > 
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > Acked-by: Michael Buesch <mb@bu3sch.de>
> > 
> > Somebody of the USB folks apply this, please.
> 
> FYI, this build fix is still not in v2.6.24-rc1.

Sorry, it's in my tree of patches to go to Linus in a few days.

thanks,

greg k-h
