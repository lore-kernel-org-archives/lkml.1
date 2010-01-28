Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694Ab0A1Wsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0A1Wsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502Ab0A1Wso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:48:44 -0500
Received: from kroah.org ([198.145.64.141]:58917 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab0A1Wsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:48:43 -0500
Date: Thu, 28 Jan 2010 14:32:33 -0800
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
 writes" causes gobi_loader to hang
Message-ID: <20100128223233.GA1358@kroah.com>
References: <20100117025535.GB7045@srcf.ucam.org>
 <201001191420.29652.oliver@neukum.org>
 <20100128174546.GC19871@kroah.com>
 <201001281940.12173.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001281940.12173.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 07:40:12PM +0100, Oliver Neukum wrote:
> Am Donnerstag, 28. Januar 2010 18:45:46 schrieb Greg KH:
> > On Tue, Jan 19, 2010 at 02:20:29PM +0100, Oliver Neukum wrote:
> > > Am Montag, 18. Januar 2010 21:14:16 schrieb Matthew Garrett:
> > > 
> > > > drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1565 
> > > > bytes
> > > > drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes 
> > > > into fifo
> > > > drivers/usb/serial/generic.c: usb_serial_generic_read_bulk_callback - 
> > > > port 0
> > > 
> > > If the FIFO is full we can do nothing. Please try the attached patch.
> > 
> > Did we ever determine if the patch below is needed or not?
> 
> No. Further discussion cast serious doubt on it, but we have no
> experimental evidence I am aware of.

Ok, thanks for letting me know.

greg k-h
