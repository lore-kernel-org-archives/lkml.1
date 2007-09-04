Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbXIDU6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbXIDU6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 16:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbXIDU6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 16:58:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43165 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753746AbXIDU6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 16:58:35 -0400
Date: Tue, 4 Sep 2007 16:58:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
cc: Jens Axboe <jens.axboe@oracle.com>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, Micah Gruber <micah.gruber@gmail.com>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH] Fix a potential NULL pointer dereference
 in usbat_check_status() in drivers/usb/storage/shuttle_usbat.c
In-Reply-To: <1188935869.19079.3.camel@odie.local>
Message-ID: <Pine.LNX.4.44L0.0709041657460.7853-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2007, Simon Holm Thøgersen wrote:

> > tir, 04 09 2007 kl. 13:06 +0200, skrev Jens Axboe:
> > On Tue, Sep 04 2007, Micah Gruber wrote:
> > > This patch fixes a potential null dereference bug where we dereference us before a null check. This patch simply moves the dereferencing after the null check.
> > > 
> > > Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
> > 
> > Be careful with stuff like that, if you actually look at the code, a us
> > == NULL doesn't seem to be possible (or usbat_flash_transport() would
> > have oopsed before).
> > 
> If that is true, then
>         if (!us)
>                 return USB_STOR_TRANSPORT_ERROR;
> is utterly pointless.

Indeed, so it is.

Alan Stern

