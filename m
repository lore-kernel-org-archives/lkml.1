Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbZEGOCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbZEGOCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932131AbZEGOAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:00:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46031 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932107AbZEGOAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:00:17 -0400
Date: Thu, 7 May 2009 10:00:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Jason Wessel <jason.wessel@windriver.com>,
       Oliver Neukum <oliver@neukum.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to
 forcewrites
In-Reply-To: <20090506213209.GA18511@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0905070956480.3087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Greg KH wrote:

> > If I want to printk from the nmi_watchdog out to this device, am I going
> > to get anything if the write is not synchronous, because in theory the
> > hcd device is never going to get accessed again?
> 
> No you are not, sorry, USB doesn't work without interrupts in this kind
> of mode at all.

This really is an interesting point.  Provided the hardware is 
functioning correctly and enough free memory is available, Jason's 
polling approach would indeed allow USB to work without interrupts -- 
to a limited extent, which is all one needs for console support.  
Especially when the system has just crashed and you want to see that 
final "oops" message...

Alan Stern

