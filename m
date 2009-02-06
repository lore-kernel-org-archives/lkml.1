Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZBFTL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZBFTL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZBFTLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:11:18 -0500
Received: from kroah.org ([198.145.64.141]:51469 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753083AbZBFTLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:11:17 -0500
Date: Fri, 6 Feb 2009 10:51:30 -0800
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Dirk DeSchepper <ddeschepper@nvtl.com>,
       USB development list <linux-usb@vger.kernel.org>, smurf@smurf.noris.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001]  usbserial: New mobile broadband modems to be
	supported through option module
Message-ID: <20090206185130.GB8517@kroah.com>
References: <12047829252365@kroah.org> <20090206003352.GA22530@kroah.com> <B29F014DE7B1F949B0BC4C1EBCF29DD6C6D2A3@Vectra.nvtl.local> <200902061258.40303.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902061258.40303.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 12:58:39PM +0100, Oliver Neukum wrote:
> Am Friday 06 February 2009 12:29:06 schrieb Dirk DeSchepper:
> > From: Dirk De Schepper <ddeschepper@nvtl.com>
> > 
> > Patch for option.c, based on kernel v2.6.28.3
> > - New Novatel and Dell mobile broadband modem products added
> > - Dell pid variables used in stead of numerical PIDs for known products
> 
> This is not really an advantage. You usually get the nummeric IDs
> just fine from lsusb. And you could easily see the nummeric order of entries.
> These symbolic names do not appear in code, just in the macros
> where their meaning is clear. You introduce a useless level of indirection.

No, it's fine, we can use all of the descriptive information that we can
get at times.  So changing the defines from a generic one, to a specific
one to match the device type, only helps out in the end.

thanks,

greg k-h
