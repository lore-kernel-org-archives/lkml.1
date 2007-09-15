Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbXIOPbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbXIOPbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 11:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbXIOPbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 11:31:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2748 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751172AbXIOPbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 11:31:04 -0400
Date: Sat, 15 Sep 2007 11:31:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Christian Volkmann <haveaniceday@cv-sv.de>
cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] 2.6.23-rc6: usb 1-1: device not accepting
 address 2, error -62
In-Reply-To: <46EBCAB6.1070003@cv-sv.de>
Message-ID: <Pine.LNX.4.44L0.0709151123590.30525-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007, Christian Volkmann wrote:

> > Does the machine otherwise work OK?
> >
> Yes, the USB is working fine for the easy things I do with it.
> 
> Hmm, so I expect this 2.6.22 message:
> >> <6>usb 1-1: USB disconnect, address 2
> 
> became this 2.6.23rc6 message:
> >> <3>usb 1-1: device not accepting address 2, error -62
> 
> and nothing is harmed.

Maybe.  It's hard to tell because you have not provided enough
information.  To get a better idea of what's going on you should enable 
CONFIG_USB_DEBUG, for both 2.6.22 and 2.6.23, and then post the dmesg 
logs.  It wouldn't hurt to enable CONFIG_PRINTK_TIME also.

These sorts of errors can occur because of bad cable connections or
other similar hardware problems.  There's an excellent chance they have
no connection to the kernel version.

Alan Stern

