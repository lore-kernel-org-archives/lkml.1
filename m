Return-Path: <linux-kernel-owner+w=401wt.eu-S933386AbXC0XWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbXC0XWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 19:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933364AbXC0XWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 19:22:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39799 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbXC0XW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 19:22:28 -0400
Date: Tue, 27 Mar 2007 15:50:06 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: gregkh@suse.de, Adrian Bunk <bunk@stusta.de>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove the broken PCI_MULTITHREAD_PROBE option
Message-ID: <20070327225006.GC4478@kroah.com>
References: <20070327010251.GX16477@stusta.de> <20070327130351.51aff00e@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327130351.51aff00e@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 01:03:51PM +0200, Cornelia Huck wrote:
> On Tue, 27 Mar 2007 03:02:51 +0200,
> Adrian Bunk <bunk@stusta.de> wrote:
> 
> > This patch removes the PCI_MULTITHREAD_PROBE option that had already 
> > been marked as broken.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > 
> > ---
> > 
> >  Documentation/pci.txt    |    4 ---
> >  drivers/base/dd.c        |   41 ++-------------------------------------
> >  drivers/pci/Kconfig      |   25 -----------------------
> >  drivers/pci/pci-driver.c |   15 --------------
> >  include/linux/device.h   |    1 
> >  5 files changed, 3 insertions(+), 83 deletions(-)
> 
> Greg, what about driver-core-per-subsystem-multithreaded-probing.patch?
> PCI_MULTITHREAD_PROBE shoudn't be broken with that, only in mainline?

Do you want to enable PCI multithreaded probing using your patch?  I
don't think the world is ready for pci multithreaded probing as was
determined by the zillion of bug reports from people who like to enable
config options that state in big letters, "THIS WILL BREAK YOUR BOX"...

And I'm still questioning if we should add your patch at all, as I don't
think any other subsystems need it.  Do you?

thanks,

greg k-h
