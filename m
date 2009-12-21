Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZLUQVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZLUQVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbZLUQVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:21:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:58116 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbZLUQVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:21:54 -0500
Date: Mon, 21 Dec 2009 08:20:02 -0800
From: Greg KH <gregkh@suse.de>
To: Alexander Strakh <strakh@ispras.ru>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: BUG null dereference in driver ./drivers/usb/serial/mos7840.c
Message-ID: <20091221162002.GA7091@suse.de>
References: <200912211951.09832.strakh@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912211951.09832.strakh@ispras.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 07:51:09PM +0000, Alexander Strakh wrote:
>         KERNEL_VERSION: 2.6.32
>         SUBJECT: null derefernce in function mos7840_bulk_in_callback
>         SUBSCRIBE:
>         In driver drivers/usb/serial/mos7840.c in function 
> mos7840_bulk_in_callback:
> 
> 1. If in line 697 mos7840_port = NULL then we goto line 699

How can that happen?

> 2. In line 699 we have null dereference.
> 
>  696         mos7840_port = urb->context;
>  697         if (!mos7840_port) {
>  698                 dbg("%s", "NULL mos7840_port pointer");
>  699                 mos7840_port->read_urb_busy = false;
>  700                 return;
>  701         }
> 
> Found by Linux Device Drivers Verification Project (Svace Detector)

What is this?

Are you also going to send patches for stuff like this?

thanks,

greg k-h
