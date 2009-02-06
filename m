Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbZBFTW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbZBFTW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbZBFTWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:22:14 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:43114 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbZBFTWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:22:13 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 001/001]  usbserial: New mobile broadband modems to be supported through option module
Date: Fri, 6 Feb 2009 20:23:06 +0100
User-Agent: KMail/1.9.10
Cc: Dirk DeSchepper <ddeschepper@nvtl.com>,
       USB development list <linux-usb@vger.kernel.org>, smurf@smurf.noris.de,
       linux-kernel@vger.kernel.org
References: <12047829252365@kroah.org> <200902061258.40303.oliver@neukum.org> <20090206185130.GB8517@kroah.com>
In-Reply-To: <20090206185130.GB8517@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902062023.07759.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Friday 06 February 2009 19:51:30 schrieben Sie:
> On Fri, Feb 06, 2009 at 12:58:39PM +0100, Oliver Neukum wrote:
> > Am Friday 06 February 2009 12:29:06 schrieb Dirk DeSchepper:
> > > From: Dirk De Schepper <ddeschepper@nvtl.com>
> > > 
> > > Patch for option.c, based on kernel v2.6.28.3
> > > - New Novatel and Dell mobile broadband modem products added
> > > - Dell pid variables used in stead of numerical PIDs for known products
> > 
> > This is not really an advantage. You usually get the nummeric IDs
> > just fine from lsusb. And you could easily see the nummeric order of entries.
> > These symbolic names do not appear in code, just in the macros
> > where their meaning is clear. You introduce a useless level of indirection.
> 
> No, it's fine, we can use all of the descriptive information that we can

Which descriptive information? The symbolic names used are internal
to the kernel.

> get at times.  So changing the defines from a generic one, to a specific
> one to match the device type, only helps out in the end.

The specifity is not affected at all.

	Regards
		Oliver
