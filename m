Return-Path: <linux-kernel-owner+w=401wt.eu-S966708AbXG3Rit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966708AbXG3Rit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761948AbXG3Rim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:38:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34446 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760281AbXG3Rim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:38:42 -0400
Date: Mon, 30 Jul 2007 13:38:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Gabriel C <nix.or.die@googlemail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <dbrownell@users.sourceforge.net>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] drivers/usb/gadget/dummy_hcd.c - DEBUG redefined
 warnings
In-Reply-To: <46AE18DE.5010704@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.0707301338000.9339-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007, Gabriel C wrote:

> Hi,
> 
> I noticed the following warnings with a randconfig ( http://194.231.229.228/git-current/randconfig-auto-34 ):
> 
> ...
> 
>  CC [M]  drivers/usb/gadget/dummy_hcd.o
> drivers/usb/gadget/dummy_hcd.c:37:1: warning: "DEBUG" redefined
> <command-line>: warning: this is the location of the previous definition
>   CC      drivers/scsi/scsi_transport_sas.o
>   CC      drivers/usb/core/notify.o
>   CC      drivers/usb/core/generic.o
> drivers/usb/gadget/dummy_hcd.c:37:1: warning: "DEBUG" redefined
> <command-line>: warning: this is the location of the previous definition
> 
> ...
> 
> 
> Line 37 is #define DEBUG , is that really needed ?

No it isn't -- that's a mistake.  Thanks for pointing it out.

Alan Stern

