Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZH0CTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZH0CTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZH0CTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:19:50 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42702 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754710AbZH0CTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:19:49 -0400
Date: Wed, 26 Aug 2009 22:19:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090826223202.49914a41@neptune.home>
Message-ID: <Pine.LNX.4.44L0.0908262218120.25799-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Bruno [UTF-8] Prémont wrote:

> Change applied to usb-serial.c, serial_instal().
> Tried it out with both pl2302 and ftdi-sio, no visible issues!
> 
> Actions I tried: connect, disconnect (with minicom running as well as
> without), start/stop minicom multiple times.
> 
> I've seen nothing unexpected or bad in kernel log (just a note that
> some sending failed while typing into minicom and pulling the USB
> plug: pl2303_write_bulk_callback - failed resubmitting write urb, error -19)

Great!  Okay, I'll break this up into a bunch of logically separate 
patches and submit them for 2.6.32.  When they have gotten sufficient 
testing, they can be back-ported into 2.6.31.stable.

Alan Stern

