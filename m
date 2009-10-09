Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbZJISbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbZJISbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761299AbZJISbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:31:46 -0400
Received: from kroah.org ([198.145.64.141]:35332 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761266AbZJISbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:31:44 -0400
Date: Fri, 9 Oct 2009 10:56:02 -0700
From: Greg KH <greg@kroah.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb@vger.kernel.org,
       e9hack <e9hack@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: Fix read regression in 2.6.31.
Message-ID: <20091009175602.GC5718@kroah.com>
References: <Pine.LNX.4.44L0.0909191217430.15223-100000@netrider.rowland.org>
 <20090920201836.GA5602@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090920201836.GA5602@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 10:18:36PM +0200, Johan Hovold wrote:
> Use ASYNCB_INITIALIZED to determine when to stop reading.
> 
> Port count can no longer be used to determine when to stop reading from
> the device as it can be zero when the first read callbacks are made (see
> tty_port_block_til_read where port count is temporarily decremented
> during serial_open).
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
> 
> Hi, 
> 
> Here's a patch which fixes the port count issue for all drivers. I only
> have access to an ftdi device at the moment so that's the only driver
> I've been able to test (against latest git with latest patches from
> Greg's tree). 

Hm, this doesn't apply on top of the other ftdi patches.  Could you
respin this?

thanks,

greg k-h
