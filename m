Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZHSSM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZHSSM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbZHSSM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:12:27 -0400
Received: from kroah.org ([198.145.64.141]:48797 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbZHSSM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:12:27 -0400
Date: Wed, 19 Aug 2009 11:11:02 -0700
From: Greg KH <greg@kroah.com>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux USB <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Purpose of parameter in sysfs binary read
Message-ID: <20090819181102.GA12609@kroah.com>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
 <20090818151427.GA6295@kroah.com>
 <ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
 <20090819170501.1dbd29a8@lxorguk.ukuu.org.uk>
 <5ea7c6a46fa1e051d69a302fdc8961ac.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ea7c6a46fa1e051d69a302fdc8961ac.squirrel@intranet.cs.nmsu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 11:41:28AM -0600, Rick L. Vinyard, Jr. wrote:
> Alan Cox wrote:
> > On Tue, 18 Aug 2009 09:41:56 -0600
> > "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu> wrote:
> >
> >> Greg KH wrote:
> >> > On Tue, Aug 18, 2009 at 08:55:29AM -0600, Rick L. Vinyard, Jr. wrote:
> >> > What are you using the binary sysfs attribute for?  It should ONLY be
> >> > used as a pass-through to and from hardware, with no interpretation by
> >> > the kernel at all.
> >>
> >> It's for the Logitech G13's game panel image (a simple binary bitmap of
> >> the pixels).
> >>
> >> It doesn't do any interpretation... just a few checks on the magic
> >> number
> >> and size.
> >
> > If its a bitmap image why not register the device as a framebuffer ?
> >
> 
> Would that preclude it also being registered as a HID? The primary purpose
> of the device is to function as a keypad input.

Is the framebuffer a different USB interface?  Or are they all
controlled through the same one?

thanks,

greg k-h
