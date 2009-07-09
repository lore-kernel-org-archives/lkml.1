Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbZGIPJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbZGIPJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759301AbZGIPIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:08:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45825 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757296AbZGIPIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:08:52 -0400
Date: Thu, 9 Jul 2009 11:08:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Michael S. Zick" <lkml@morethan.org>
cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Null Pointer BUG in uhci_hcd
In-Reply-To: <200907090946.59055.lkml@morethan.org>
Message-ID: <Pine.LNX.4.44L0.0907091106050.5823-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, Michael S. Zick wrote:

> In case you missed it - this is the CX700 integrated chipset in a NetBook.
> No all USB devices are removable in the sense of being physically impossible.

Do the best you can.

> The documentation for the CX700 has been released from NDA and is available
> at the VIA Linux portal - just in case you don't already have your copy.
> 
> More testing today - including trying some of the many kernel options available
> for dealing with funky irq, bios, and acpi implementations.
> 
> On the subject of irq's:
> 
> root@cb01:~# biosdecode
> # biosdecode 2.9
> SMBIOS 2.4 present.
>         Structure Table Length: 1556 bytes
>         Structure Table Address: 0x000DC010
>         Number Of Structures: 47
>         Maximum Structure Size: 119 bytes
> BIOS32 Service Directory present.
>         Revision: 0
>         Calling Interface Address: 0x000FDD64
> ACPI 1.0 present.
>         OEM Identifier: PTLTD
>         RSD Table 32-bit Address: 0x1BEE5663
> PNP BIOS 1.0 present.
>         Event Notification: Not Supported
>         Real Mode 16-bit Code Address: E923:768E
>         Real Mode 16-bit Data Address: 0040:0000
>         16-bit Protected Mode Code Address: 0x00015FCF
>         16-bit Protected Mode Data Address: 0x00000400
> PCI Interrupt Routing 1.0 present.
>         Router ID: 00:11.0
>         Exclusive IRQs: None
>         Compatible Router: 1106:8324
>         Slot Entry 1: ID 00:00, on-board
>         Slot Entry 2: ID 00:11, on-board
>         Slot Entry 3: ID 00:10, on-board
>         Slot Entry 4: ID 00:0f, on-board
>         Slot Entry 5: ID 04:09, slot number 9
>         Slot Entry 6: ID 00:01, on-board
>         Slot Entry 7: ID 01:00, on-board
>         Slot Entry 8: ID 00:13, on-board
>         Slot Entry 9: ID 02:01, on-board
>         Slot Entry 10: ID 00:13, on-board
>         Slot Entry 11: ID 03:03, slot number 49
>         Slot Entry 12: ID 03:04, slot number 50
>         Slot Entry 13: ID 03:05, slot number 51
>         Slot Entry 14: ID 03:06, slot number 52
>         Slot Entry 15: ID 03:07, slot number 53

Means nothing to me.  I'm no ACPI or chipset expert.

> Whatever a VIA 8324 router happens to be - - -
> 
> All four of the different brands of "Nano-book reference design"
> machines have the same, or very similar, BIOS (all the VIA demo
> board BIOS).  That interrupt table is the same in all machines.
> Only one of the manufacturer's even bothered to change the serial
> number of the machine (1234567890) - they are that "similar".

Alan Stern

