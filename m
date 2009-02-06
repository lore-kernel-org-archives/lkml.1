Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZBGAxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZBGAxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZBGAxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:53:43 -0500
Received: from kroah.org ([198.145.64.141]:36062 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752234AbZBGAxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:53:42 -0500
Date: Fri, 6 Feb 2009 15:47:16 -0800
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Dirk DeSchepper <ddeschepper@nvtl.com>,
       USB development list <linux-usb@vger.kernel.org>, smurf@smurf.noris.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001]  usbserial: New mobile broadband modems to be
	supported through option module
Message-ID: <20090206234716.GB31059@kroah.com>
References: <12047829252365@kroah.org> <200902061258.40303.oliver@neukum.org> <20090206185130.GB8517@kroah.com> <200902062023.07759.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902062023.07759.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 08:23:06PM +0100, Oliver Neukum wrote:
> Am Friday 06 February 2009 19:51:30 schrieben Sie:
> > On Fri, Feb 06, 2009 at 12:58:39PM +0100, Oliver Neukum wrote:
> > > Am Friday 06 February 2009 12:29:06 schrieb Dirk DeSchepper:
> > > > From: Dirk De Schepper <ddeschepper@nvtl.com>
> > > > 
> > > > Patch for option.c, based on kernel v2.6.28.3
> > > > - New Novatel and Dell mobile broadband modem products added
> > > > - Dell pid variables used in stead of numerical PIDs for known products
> > > 
> > > This is not really an advantage. You usually get the nummeric IDs
> > > just fine from lsusb. And you could easily see the nummeric order of entries.
> > > These symbolic names do not appear in code, just in the macros
> > > where their meaning is clear. You introduce a useless level of indirection.
> > 
> > No, it's fine, we can use all of the descriptive information that we can
> 
> Which descriptive information? The symbolic names used are internal
> to the kernel.

Exactly, and people look at kernel code all the time :)

> > get at times.  So changing the defines from a generic one, to a specific
> > one to match the device type, only helps out in the end.
> 
> The specifity is not affected at all.

If you look at the names that were changed, they are now more
descriptive than before, always a good thing to have.

thanks,

greg k-h
