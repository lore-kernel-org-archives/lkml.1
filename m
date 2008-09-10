Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbYIJBm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbYIJBm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 21:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYIJBms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 21:42:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46773 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbYIJBmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 21:42:47 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 03/18] lirc driver for 1st-gen Media Center Ed. USB IR transceivers
Date: Tue, 9 Sep 2008 21:39:52 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>, dconti@acm.wwu.edu
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <20080909132140.3c0adcca@bike.lwn.net> <200809100159.32524.j@jannau.net>
In-Reply-To: <200809100159.32524.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809092139.52369.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 19:59:32 Janne Grunau wrote:
> > > +static void mceusb_setup(struct usb_device *udev)
> > > +{
> > > +   char data[8];
> > > +   int res;
> > > +
> > > +   memset(data, 0, 8);
> > > +
> > > +   /* Get Status */
> > > +   res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> > > +                         USB_REQ_GET_STATUS, USB_DIR_IN,
> > > +                         0, 0, data, 2, HZ * 3);
> >
> > res is set many times in this function, but it is never checked.  It
> > seems to me like the addition of some error handling would be a good
> > idea.
>
> sigh, It would be a good idea, not sure if I'm motivated enough to add
> that to a driver I can't test and I know almost nothing about.

I'll take a look, I've at least got the hardware to test with.

-- 
Jarod Wilson
jarod@redhat.com

