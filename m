Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZBWXc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZBWXc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 18:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZBWXco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 18:32:44 -0500
Received: from kroah.org ([198.145.64.141]:46708 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751242AbZBWXcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 18:32:43 -0500
Date: Mon, 23 Feb 2009 15:26:21 -0800
From: Greg KH <greg@kroah.com>
To: Mike Murphy <mamurph@cs.clemson.edu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] (revision 1) input: xpad.c - Xbox 360 wireless and
	sysfs support
Message-ID: <20090223232621.GC8829@kroah.com>
References: <5aa163d00902212131g7cf9218ewd8a6396a7f1c95fd@mail.gmail.com> <20090222064806.GC8494@nowhere> <5aa163d00902220921s7c42f307xda6df7b071849fe4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aa163d00902220921s7c42f307xda6df7b071849fe4@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 12:21:10PM -0500, Mike Murphy wrote:
> On Sun, Feb 22, 2009 at 1:48 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> ...
> >> +static ssize_t xpad_store_rumble_enable(struct device *dev,
> >> +             struct device_attribute *attr, const char *buf, size_t count)
> >> +{
> >> +     struct usb_xpad *xpad = to_xpad(dev);
> >> +     int newrumble = xpad->rumble_enable;
> >> +     if (1 == sscanf(buf, "%d", &newrumble))
> >
> >
> > Oh, that's not wrong but it looks weird, usually, a code reader would
> > expect to see if (sscanf(...) == 1)
> >
> 
> Oops... I changed some stuff around (deleted an unneeded variable) and
> didn't change the test form back.
> 
> The "backwards" expression is a trick that some of us teach when
> teaching C, for the specific case of comparing a variable to a
> constant. It allows the compiler to check for an unintentional "="
> where a "==" was desired. (foo = 4) is not an error or a warning

Yes it is, on modern versions of gcc.

thanks,

greg k-h
