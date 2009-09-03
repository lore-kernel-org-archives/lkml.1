Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZICSiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZICSiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZICSiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:38:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbZICSiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:38:24 -0400
Date: Thu, 3 Sep 2009 11:36:37 -0700
From: Greg KH <gregkh@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@linux.intel.com, stern@rowland.harvard.edu
Subject: Re: WARNINGs in usb-serial.c
Message-ID: <20090903183637.GA5140@suse.de>
References: <E1MjD4A-0002wi-KL@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1MjD4A-0002wi-KL@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 04:13:34PM +0200, Miklos Szeredi wrote:
> I get the following warnings in 2.6.31-rc.  A lot of them:
> 
> WARNING: at drivers/usb/serial/usb-serial.c:414 serial_write_room+0x59/0x6e [usbserial]()
> WARNING: at drivers/usb/serial/usb-serial.c:401 serial_write+0x77/0x9d [usbserial]()
> 
> This is a huawei-3565 modem.
> 
> The messages don't seem to hurt, but there's lot of trouble with this
> gadget.  Sometimes it just doesn't work after a while and a reboot is
> needed.  Sometimes it hangs the kernel after suspend, etc.  Not sure
> if this is related to the warnings...

{sigh}

The tty layer changes are being a pain here :(

Alan Stern posted a set of patches to the linux-usb list to hopefully
address stuff like this, is there any way you could test them out to see
if they help or not?

thanks,

greg k-h
