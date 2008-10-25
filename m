Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYJYLVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYJYLVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 07:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYJYLVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 07:21:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50253 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYJYLVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 07:21:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [2.6.27-rc7] oops in usbcore
Date: Sat, 25 Oct 2008 13:26:15 +0200
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Folkert van Heusden <folkert@vanheusden.com>,
       Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org,
       USB list <linux-usb@vger.kernel.org>
References: <200810242353.08576.rjw@sisk.pl> <Pine.LNX.4.44L0.0810241809110.2180-100000@iolanthe.rowland.org> <20081024221639.GA23702@kroah.com>
In-Reply-To: <20081024221639.GA23702@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810251326.15821.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 25 of October 2008, Greg KH wrote:
> On Fri, Oct 24, 2008 at 06:13:03PM -0400, Alan Stern wrote:
> > On Fri, 24 Oct 2008, Rafael J. Wysocki wrote:
> > 
> > > On Thursday, 9 of October 2008, Folkert van Heusden wrote:
> > > > > > lpc-ntpd is a atomic clock receiver driver doing read()-calls on an fd
> > > > > > from a serial device (connected via usb), nothing fancy
> > > > > > (http://vanheusden.com/lpc-ntpd/ ).
> > > > > 
> > > > > Which devices? Please post lsusb -v
> > > > 
> > > > thegate:/home/folkert# lsusb  -v > lsusb
> > > > cannot read device status, Broken pipe (32)
> > > > 
> > > > Isn't that error odd?
> > > > 
> > > > The output is:
> > 
> > ...
> > 
> > > > > But you do get this oops even without running that script, don't you?   
> > > > 
> > > > No, only with that script.
> > > 
> > > Is this still reproducible in mainline?
> > > 
> > > If not, is it reproducible with 2.6.27 final?
> > 
> > I submitted a patch for this:
> > 
> > 	http://marc.info/?l=linux-usb&m=122461735606713&w=2
> > 
> > It hasn't been merged yet, in any tree.
> 
> I'm a bit hesitant to add it for .28, especially as this isn't a
> "regression" per-say, but something that we have always done wrong, and
> it changes the core USB code.

OK, I'm not going to list it, then.

Thanks,
Rafael
