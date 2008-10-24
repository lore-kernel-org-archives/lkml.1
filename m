Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYJXWU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYJXWU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbYJXWUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:20:13 -0400
Received: from kroah.org ([198.145.64.141]:37136 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754914AbYJXWUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:20:11 -0400
Date: Fri, 24 Oct 2008 15:16:39 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [2.6.27-rc7] oops in usbcore
Message-ID: <20081024221639.GA23702@kroah.com>
References: <200810242353.08576.rjw@sisk.pl> <Pine.LNX.4.44L0.0810241809110.2180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0810241809110.2180-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 06:13:03PM -0400, Alan Stern wrote:
> On Fri, 24 Oct 2008, Rafael J. Wysocki wrote:
> 
> > On Thursday, 9 of October 2008, Folkert van Heusden wrote:
> > > > > lpc-ntpd is a atomic clock receiver driver doing read()-calls on an fd
> > > > > from a serial device (connected via usb), nothing fancy
> > > > > (http://vanheusden.com/lpc-ntpd/ ).
> > > > 
> > > > Which devices? Please post lsusb -v
> > > 
> > > thegate:/home/folkert# lsusb  -v > lsusb
> > > cannot read device status, Broken pipe (32)
> > > 
> > > Isn't that error odd?
> > > 
> > > The output is:
> 
> ...
> 
> > > > But you do get this oops even without running that script, don't you?   
> > > 
> > > No, only with that script.
> > 
> > Is this still reproducible in mainline?
> > 
> > If not, is it reproducible with 2.6.27 final?
> 
> I submitted a patch for this:
> 
> 	http://marc.info/?l=linux-usb&m=122461735606713&w=2
> 
> It hasn't been merged yet, in any tree.

I'm a bit hesitant to add it for .28, especially as this isn't a
"regression" per-say, but something that we have always done wrong, and
it changes the core USB code.

But, I can probably be convinced otherwise if needed :)

thanks,

greg k-h
