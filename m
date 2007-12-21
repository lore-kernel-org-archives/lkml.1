Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbXLUWds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbXLUWds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbXLUWdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:33:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58446 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbXLUWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:33:40 -0500
Date: Fri, 21 Dec 2007 14:32:09 -0800
From: Greg KH <greg@kroah.com>
To: David Hilvert <dhilvert@gmail.com>
Cc: linux-kernel@vger.kernel.org, dmitri@users.sourceforge.net,
       linux-usb@vger.kernel.org
Message-ID: <20071221223209.GA24780@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-usb@vger.kernel.org
Bcc: 
Subject: Re: Regarding request for IBM camera patch to be applied to the
	main tree
Reply-To: 
In-Reply-To: <20071221152130.bf2d745d.dhilvert@gmail.com>

On Fri, Dec 21, 2007 at 03:21:30PM -0600, David Hilvert wrote:
> > > http://www.linux-usb.org/ibmcam/
> 
> > > http://auricle.dyndns.org/xvp610/
> 
> [Remainder of private e-mail context snipped; message has been blind-CC'ed to
> the original recipients.  Please CC any replies intended for me.]
> 
> As the author of the second patch noted, I had avoided sending it to lkml due
> to the difficulty of determining whether the patch is correct (e.g., having no
> ill effect on other cameras), due, in turn, to lack of documentation for this
> series of cameras.  Perhaps dmitri could comment further on this, if he has
> time and access to test on any other cameras that might fall under the 'model
> 3' designation (whatever this designation might mean).  The (rather old, now)
> patch in question (against 2.6.1 or so, and perhaps other versions) follows; if
> I recall correctly, it was designed to minimize change lines rather than
> provide for overall clarity, so that a clearer final implementation is probably
> possible.
> 
> 
> diff -urN linux-2.6.1/drivers/usb/media/ibmcam.c linux-2.6.1-patched/drivers/usb/media/ibmcam.c
> --- linux-2.6.1/drivers/usb/media/ibmcam.c	Fri Jan  9 00:59:19 2004
> +++ linux-2.6.1-patched/drivers/usb/media/ibmcam.c	Fri Feb  6 14:54:33 2004

I suggest forward porting it to the latest tree and submit it to the usb
video maintainers for inclusion.

thanks,

greg k-h
