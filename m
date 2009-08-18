Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbZHRQGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbZHRQGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbZHRQGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:06:40 -0400
Received: from kroah.org ([198.145.64.141]:44189 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbZHRQGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:06:40 -0400
Date: Tue, 18 Aug 2009 09:02:15 -0700
From: Greg KH <greg@kroah.com>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Linux USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Purpose of parameter in sysfs binary read
Message-ID: <20090818160215.GB7039@kroah.com>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
 <20090818151427.GA6295@kroah.com>
 <ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 09:41:56AM -0600, Rick L. Vinyard, Jr. wrote:
> Greg KH wrote:
> > On Tue, Aug 18, 2009 at 08:55:29AM -0600, Rick L. Vinyard, Jr. wrote:
> > What are you using the binary sysfs attribute for?  It should ONLY be
> > used as a pass-through to and from hardware, with no interpretation by
> > the kernel at all.
> 
> It's for the Logitech G13's game panel image (a simple binary bitmap of
> the pixels).
> 
> It doesn't do any interpretation... just a few checks on the magic number
> and size.

Cool.  Have a pointer to the driver yet?

thanks,

greg k-h
