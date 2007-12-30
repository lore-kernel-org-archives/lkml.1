Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbXL3DyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbXL3DyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 22:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXL3Dx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 22:53:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:15132 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbXL3Dx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 22:53:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=uA2DaDJ2jYUM2EEbCwbOUK514TECyARXxBmvHda+YlfmETEaD83ry/FjrriRchY3fi8TOuiZ/gOWteAYl2W9L6E8xhx3RL97rUbxKHT9QeJsXg/FYs2GAX71hoYuYSfskaKa3LuB2lKGBhLW27WBcjH4fF3WuodOMOYxuSEtrhU=
Date: Sat, 29 Dec 2007 19:53:49 -0800
From: mgross <640e9920@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC] USB driver for talking to the Microchip PIC18 boot loader
Message-ID: <20071230035349.GA4741@mgross-t43>
References: <20071229193409.GA20188@mgross-t43> <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 05:15:30PM -0500, Alan Stern wrote:
> On Sat, 29 Dec 2007, mgross wrote:
> 
> > I'm playing around with a PIC based project at home (not an Intel
> > activity) and found I needed a usb driver to talk to the boot loader
> > so I can program my USB Bitwhacker with new custom firmware.  The
> > following adds the pic18bl driver to the kernel.  Its pretty simple
> > and is somewhat based on bits of a libusb driver that does some of
> > what this driver does.
> > 
> > What do you think?
> 
> Not to detract from your driver, but would it be possible to do the 
> whole thing in userspace using libusb?  Maybe by extending the driver 
> you mentioned?
>
Yeah, it has been done from user space using a libusb based
application.  (that didn't work with a usb-hub in the loop) and had
code that was just too nasty for words, so I made a kernel driver that
looks nicer to me and enables a nice python FW loader program to work.

What is the linux-usb policies on new drivers that could be
implemented in user space?  When does a kernel driver make  sense over
a libusb one?

--mgross

