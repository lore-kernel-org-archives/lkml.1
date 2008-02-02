Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbYBBBIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbYBBBIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbYBBBIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:08:02 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53414 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755026AbYBBBIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:08:00 -0500
Date: Fri, 1 Feb 2008 17:07:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, shaohua.li@intel.com,
       yanmin.zhang@intel.com
Subject: Re: [GIT PATCH] PCI patches for 2.6.24
Message-Id: <20080201170746.31a7caa0.akpm@linux-foundation.org>
In-Reply-To: <20080202004916.GA10071@suse.de>
References: <20080201231147.GA18174@suse.de>
	<20080201164206.d96c6ee0.akpm@linux-foundation.org>
	<20080202004916.GA10071@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008 16:49:16 -0800
Greg KH <gregkh@suse.de> wrote:

> > --- a/drivers/pci/pcie/Kconfig~fix-gregkh-pci-pci-pcie-aspm-support
> > +++ a/drivers/pci/pcie/Kconfig
> > @@ -32,7 +32,7 @@ source "drivers/pci/pcie/aer/Kconfig"
> >  #
> >  config PCIEASPM
> >  	bool "PCI Express ASPM support(Experimental)"
> > -	depends on PCI && EXPERIMENTAL
> > +	depends on PCI && EXPERIMENTAL && PCIEPORTBUS
> >  	default y
> >  	help
> >  	  This enables PCI Express ASPM (Active State Power Management) and
> > _
> 
> Oops, sorry, I'll add that to my queue for the next round.

Was "default y" appropriate?
