Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab0AOUQx (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205Ab0AOUQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:16:49 -0500
Received: from kroah.org ([198.145.64.141]:51574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758196Ab0AOUQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:16:47 -0500
Date: Fri, 15 Jan 2010 10:50:34 -0800
From: Greg KH <greg@kroah.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13][v2] USB: serial: fix DMA buffers on stack and
 endianess bugs
Message-ID: <20100115185034.GF12146@kroah.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
 <1262274489-12447-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262274489-12447-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 04:47:56PM +0100, Johan Hovold wrote:
> Hi, 
> 
> Here's an updated series rebased against rc2 with all patches from Greg's tree
> applied. The mct_u232 patch has been dropped as it had already been fixed. I
> also updated the ch341 and cypress_m8 patches to use the unaligned macros. 

Ok, I took your original series (sorry, didn't read ahead) and then
added 2 new ones for the ch341 and cypress_m8 unaligned stuff.  Please
verify that I got all of this correct.

thanks,

greg k-h
