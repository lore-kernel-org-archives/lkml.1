Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbZDFPKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbZDFPKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbZDFPJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:09:56 -0400
Received: from kroah.org ([198.145.64.141]:46269 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753085AbZDFPJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:09:55 -0400
Date: Mon, 6 Apr 2009 08:04:31 -0700
From: Greg KH <greg@kroah.com>
To: Jon Grant <jg@jguk.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: USB disconnect, address 6
Message-ID: <20090406150431.GA25557@kroah.com>
References: <19ac3f7a0904051104h1abc4cf3rae6dc1a027207831@mail.gmail.com> <20090406022356.GA866@kroah.com> <19ac3f7a0904060211s5a79b659tf8ac315010151dbb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19ac3f7a0904060211s5a79b659tf8ac315010151dbb@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 11:11:55AM +0200, Jon Grant wrote:
> Hello
> 
> 2009/4/6 Greg KH <greg@kroah.com>:
> > On Sun, Apr 05, 2009 at 07:04:45PM +0100, Jon Grant wrote:
> >> Hello
> >>
> >> Would there be a way to propagate the device name back from the scsi
> >> system to the usb so it can name the device which is disconnected in
> >> the output? This saves needing to go hunting to find what the
> >> disconnected device was.
> >
> > What do you mean, all the info needed is already in the messages below,
> > what more do you need?
> 
> The idea was that the disconnect could give more information.
> Otherwise it's necessary to go hunting back up the log to track down
> which USB device was the one disconnected (which works fine, but isn't
> ideal for time consumed doing this regularly).

As you yanked the device out, don't you know which one it was?

> [...]
> >> Apr  5 18:56:58 data-laptop kernel: [65451.669308] usb 5-1: USB disconnect, address 6
> >
> >
> > confused,
> 
> If it said instead:
> 
> Apr  5 18:56:58 data-laptop kernel: usb 5-1: USB disconnect, address 6
> (Samsung  Mighty Drive)
> 
> Would this not be clearer?

That might be nice, but note that the kernel doesn't even know the
strings after a device is gone, as it had to read them from the device
:)

Also, lots of devices don't have strings describing them, and some of
them are just flat out wrong.  And, if you have multiple devices of the
same type, it wouldn't really help out any either.

So it would be a bit difficult to do this, sorry.

thanks,

greg k-h
