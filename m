Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab0AOUQu (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197Ab0AOUQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:16:48 -0500
Received: from kroah.org ([198.145.64.141]:51570 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758200Ab0AOUQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:16:47 -0500
Date: Fri, 15 Jan 2010 10:43:26 -0800
From: Greg KH <greg@kroah.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] USB: mct_u232: fix DMA buffers on stack
Message-ID: <20100115184326.GE12146@kroah.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
 <1262037718-31424-10-git-send-email-jhovold@gmail.com>
 <20091231114025.GE15063@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091231114025.GE15063@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 12:40:25PM +0100, Johan Hovold wrote:
> Please disregard this one as I just realised that this has already been
> fixed by Pete Zaitcev (in Greg's patch tree). The patches basically only
> differs in that I added error messages for failed allocations, and
> that Pete used put_unaligned for the divsor.
> 
> Sorry about that.

No problem, thanks for letting me know.

greg k-h
