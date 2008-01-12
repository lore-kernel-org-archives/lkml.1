Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbYALTx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbYALTx1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 14:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbYALTxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 14:53:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46677 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbYALTxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 14:53:18 -0500
Date: Sat, 12 Jan 2008 11:53:33 -0800
From: Greg KH <greg@kroah.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] USB Kconfig: Reorganize USB Kconfig Menu
Message-ID: <20080112195333.GA4924@kroah.com>
References: <200801051546.SAA08937@raad.intranet> <20080111223928.GB5942@kroah.com> <200801121320.46580.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801121320.46580.a1426z@gawab.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 01:20:46PM +0300, Al Boldi wrote:
> Greg KH wrote:
> > On Sat, Jan 05, 2008 at 06:40:38PM +0300, Al Boldi wrote:
> > > Reorganize USB Kconfig Menu, and move USB_GADGET out into the Device
> > > Driver Menu. ?This helps the USB Kconfig Menu to be more logical/usable.
> > >
> > > Patchset against 2.6.23
> >
> > So what was the final verdict in this patch set?
> 
> IMHO, it's a lot better than what we have right now, and it's split up so 
> that you can pick and choose what you think is useful.
> 
> > Can you rsend this against 2.6.24-rc7 with the requested changes (if
> > any) in it?
> 
> The only critical change is in patch 2/5:
> 
>         menuconfig USB_STORAGE
>         tristate "USB Mass Storage support"
> -       depends on USB && SCSI
> +       depends on USB && BLOCK
> +       select SCSI
> 
> 
> I was hoping you could take care of it, or maybe wait until 2.6.25 is out.

Well, if you want such a change to go into 2.6.25, I need the patches
now :)

So, can you respin these against 2.6.24-rc7, with the above fix, so that
I can apply them and test them out?

thanks,

greg k-h
