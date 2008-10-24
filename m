Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbYJXWNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbYJXWNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYJXWNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:13:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38214 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753488AbYJXWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:13:05 -0400
Date: Fri, 24 Oct 2008 18:13:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Folkert van Heusden <folkert@vanheusden.com>,
       Oliver Neukum <oliver@neukum.org>, <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [2.6.27-rc7] oops in usbcore
In-Reply-To: <200810242353.08576.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0810241809110.2180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008, Rafael J. Wysocki wrote:

> On Thursday, 9 of October 2008, Folkert van Heusden wrote:
> > > > lpc-ntpd is a atomic clock receiver driver doing read()-calls on an fd
> > > > from a serial device (connected via usb), nothing fancy
> > > > (http://vanheusden.com/lpc-ntpd/ ).
> > > 
> > > Which devices? Please post lsusb -v
> > 
> > thegate:/home/folkert# lsusb  -v > lsusb
> > cannot read device status, Broken pipe (32)
> > 
> > Isn't that error odd?
> > 
> > The output is:

...

> > > But you do get this oops even without running that script, don't you?   
> > 
> > No, only with that script.
> 
> Is this still reproducible in mainline?
> 
> If not, is it reproducible with 2.6.27 final?

I submitted a patch for this:

	http://marc.info/?l=linux-usb&m=122461735606713&w=2

It hasn't been merged yet, in any tree.

Alan Stern

