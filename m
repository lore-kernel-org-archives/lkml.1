Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbZJGTgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbZJGTgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759205AbZJGTgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:36:47 -0400
Received: from kroah.org ([198.145.64.141]:41382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbZJGTgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:36:47 -0400
Date: Wed, 7 Oct 2009 12:33:29 -0700
From: Greg KH <greg@kroah.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       Oliver Neukum <oliver@neukum.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4]: USB: ftdi_sio: fix regression in 2.6.31 and clean
 up
Message-ID: <20091007193329.GA2977@kroah.com>
References: <1254938707-6996-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254938707-6996-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 08:05:03PM +0200, Johan Hovold wrote:
> Hi, 
> 
> These patches clean up the ftdi_sio driver and fixes
> 
>  1) a long outstanding bug manifesting itself as 
>  
>  	BUG: sleeping function called from invalid context at kernel/mutex.c:280
> 
>  2) a couple of regressions in 2.6.31 (stalled reads and unthrottle race)
>     due to changes in the tty layer.
> 
> Please have a look at it so we can get something back-ported to stable as the
> ftdi_sio driver is currently completly broken and unusable due to the stalled
> reads.
> 
> Note that the patches do not add suspend/resume support to the driver (but the
> clean up should make it easier to implement).
> 
> Thanks to Alan Cox, Oliver Neukum, and Alan Stern for all comments and
> suggestions so far.

Very nice, thanks for doing this work, I really appreciate it.  I'll
queue it up as soon as possible.

thanks,

greg k-h
