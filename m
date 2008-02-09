Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbYBIWMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbYBIWMp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 17:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbYBIWMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 17:12:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56362 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754555AbYBIWMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 17:12:36 -0500
Date: Sat, 9 Feb 2008 17:12:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Patrick Ringl <patrick_@freenet.de>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
       <linux-storage@vger.kernel.org>
Subject: Re: wrong cylinders of kingston usb pendrive [intel 82801DB]
In-Reply-To: <47A6615D.9090201@freenet.de>
Message-ID: <Pine.LNX.4.44L0.0802091709450.3355-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008, Patrick Ringl wrote:

> Hello,
> 
> I am suffering from the following (usb-related?) problem:
> 
> I have several different mashines - all x86 architecture - just lets 
> call them mashineA, mashineB and mashineC.
> Anyway, mashineA has a severe problem with a 
> Kingston-USB-pendrive(2gig). I simply cant install anything on it - the 
> kernel usually moans with problems like "attempt to access beyond end of 
> device" - while it does work fine with several noname usb-pendrives of 
> the same size.
> Now, I just tested that kingston pendrive on mashineB and mashineC - 
> where it runs fine .. I can install debian to it (same installation 
> media) without any problem or kernel errors.
> 
> I compared the output of dmesg and fdisk from mashineA and mashineB and 
> C .. and the difference is simple: mashineA always shows 248 cylinders - 
> while all the other mashines show 228 cylinders.

The number of cylinders is meaningless.  What matters is the number of 
sectors.  What does "fdisk -l /dev/sdX" (substitute the appropriate 
letter for X) display for the pendrive on each of the machines?

What messages show up in the dmesg log when you plug in the pendrive?

What version of the Linux kernel are you using?

Alan Stern

