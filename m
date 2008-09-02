Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYIBTT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYIBTT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 15:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYIBTTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 15:19:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59365 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751554AbYIBTTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 15:19:49 -0400
Date: Tue, 2 Sep 2008 15:19:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thiago Galesi <thiagogalesi@gmail.com>
cc: Alex Buell <alex.buell@munted.org.uk>, <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockr@shaw.ca>, Tomas Styblo <tripie@cpan.org>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
In-Reply-To: <82ecf08e0809020907x102179b6ld0d372547759a143@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809021508480.5583-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Thiago Galesi wrote:

> Ok, I've created a USBMON log, here it is here:
> http://duskblue.org/jmicron_log_k3b.log
> 
> (I guess it is a little too big - 70k -  to be placed in the message directly)
> 
> Using k3b, since it seems it is the program which causes more errors.
> DVD is completely unusable after I did this, dmesg has sr 4:0:0:0:
> rejecting I/O to offline device
> 
> If I reload the drivers manually I have the reader back without
> rebooting the machine.

I can't tell exactly what's happening, but your device is sending back 
a lot of error messages (Not Ready - Medium not present).  Maybe it 
doesn't recognize the type of disc you have loaded.

Also, there appears to be some program querying the state of your
device 7 or 8 times every two seconds.  I can't tell what that is; it 
might be hal or it might be your k3b program.

However what finally caused the failure was a command (0xAC) which I 
don't recognize and apparently your drive doesn't recognize either.

Alan Stern

