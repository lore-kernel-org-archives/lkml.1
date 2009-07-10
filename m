Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbZGJUdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbZGJUdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZGJUcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:32:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48552 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752978AbZGJUcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:32:52 -0400
Date: Fri, 10 Jul 2009 16:32:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: K R I S K <kdbbox@gmail.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, <linux-usb@vger.kernel.org>,
       <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: usb mouse not responding after resume
In-Reply-To: <12e16730907101254s12cdb3aam5fa87044938f2080@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0907101628550.4183-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, K R I S K wrote:

> Thanks Allan.
> 
> We need to look into the console messages of the bootloader rather than
> dmesg's.

What bootloader?  What's the connection between booting and 
suspend/resume?

> the second USB - mouse may not be resumed or initialized
> 
> solution one:
> 
> The resistor value may have to be changed ; for example in PPC the following
> resistor values would release the reset to PPC
> 1. No install R670
> 2. Install R776

We're talking about a T60 notebook.  It doesn't use a PPC.

> Second Solution:
> 
> The USB devices can be re-initialized after suspend or when resuming
> by issuing the following sequence of commands: USB_STOP(),
> DELAY(),USB_INIT()
> in the bootloader's board specific file with in conditional High speed and
> Lowspeed flags for USB.

What bootloader?  What board-specific file?

Besides, it won't help.  The log shows that the kernel did reset the 
USB controller.

Alan Stern

