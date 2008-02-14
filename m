Return-Path: <linux-kernel-owner+w=401wt.eu-S935349AbYBNXsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935349AbYBNXsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934769AbYBNXn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:43:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:60538 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933930AbYBNXnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:43:25 -0500
Date: Thu, 14 Feb 2008 15:47:48 -0800
From: Greg KH <gregkh@suse.de>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: problem with starting 2.5.25-rc1 and latest git
Message-ID: <20080214234748.GA6061@suse.de>
References: <200802132316.03155.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802132316.03155.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 11:16:02PM +0100, Mariusz Kozlowski wrote:
> Hello,
> 
> 	I tried 2.6.25-rc1 and latest git on my laptop (x86 32bit) and have a problem.
> Linux boots but with huge delay due to some issue with loading usb modules.
> Udev complains:
> 
> 'Could not lock modprobe uhci_hcd'
> 'Could not lock modprobe yenta_socket'
> 'Unknown symbol usb_*'
> 'Gave up waiting for init of module usbcore'
> 
> at the same time I can see these messages in syslog (look at timing - grep by usb):
> 
> Feb 13 21:34:22 laptop kernel: usbcore: registered new interface driver usbfs
> Feb 13 21:34:22 laptop kernel: usbcore: registered new interface driver hub
> Feb 13 21:34:22 laptop kernel: usbcore: registered new device driver usb
> Feb 13 21:34:22 laptop kernel: ehci_hcd: gave up waiting for init of module usbcore.

I don't see how this is a usb issue, it looks to be a module loading
issue, which is in the module core and module-init-tools.

What version of module-init-tools do you have, and are you using an
initramfs that loads these modules?  If so, what distro and version are
you using?

thanks,

greg k-h
