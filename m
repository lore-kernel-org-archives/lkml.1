Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0BVTKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:10:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34375 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753291Ab0BVTKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:10:34 -0500
Date: Mon, 22 Feb 2010 14:10:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Anssi Hannula <anssi.hannula@iki.fi>
cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       <dvomlehn@cisco.com>, <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes"
 causes gobi_loader to hang
In-Reply-To: <201002222035.36043.anssi.hannula@iki.fi>
Message-ID: <Pine.LNX.4.44L0.1002221408200.1251-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Anssi Hannula wrote:

> I guess that would suggest that the device doesn't allow the initialization 
> data to be broken into packets arbitrarily (though some differences seem 
> allowed, as the windows driver transmits them differently).
> 
> Does this mean a tty interface is ill-suited for the microcode upload, and 
> instead qcserial should use the kernel's generic microcode upload mechanism or 
> the userspace should use libusb to do it?

I don't know.  Didn't the old successful code use a tty interface?

> Any idea what could be causing the hang, then?

No idea, unless it's the device.

>  The WARNING that appears when 
> interrupting the hung gobi_loader is for serial_unthrottle() being called 
> while usb_serial_port->port.count == 0.

That's a bogus warning.  It will be removed in an upcoming kernel 
version.

Alan Stern

