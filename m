Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYL2VBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYL2VBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYL2VBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:01:18 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39253 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752356AbYL2VBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:01:15 -0500
Date: Mon, 29 Dec 2008 16:01:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: John Daiker <daikerjohn@gmail.com>
cc: David Brownell <david-b@pacbell.net>, Julia Lawall <julia@diku.dk>,
       <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 10/13] drivers/usb/gadget: use USB API functions rather
 than constants
In-Reply-To: <495937C3.7090101@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0812291558120.2176-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008, John Daiker wrote:

> So you're saying that these functions:
> usb_endpoint_dir_in(epd)
> usb_endpoint_dir_out(epd)
> usb_endpoint_is_bulk_in(epd)
> usb_endpoint_is_bulk_out(epd)
> usb_endpoint_is_int_in(epd)
> usb_endpoint_is_int_out(epd)
> usb_endpoint_num(epd)
> usb_endpoint_type(epd)
> usb_endpoint_xfer_bulk(epd)
> usb_endpoint_xfer_control(epd)
> usb_endpoint_xfer_int(epd)
> usb_endpoint_xfer_isoc(epd)
> 
> Should be defined in ch9.h instead of usb.h?

Yes.  Also usb_endpoint_is_isoc_in(epd) and 
usb_endpoint_is_isoc_out(epd).

> If that's the case, then I'll be glad to cook up a patch! :)

Good, thank you.

Alan Stern

