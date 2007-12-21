Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbXLUVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbXLUVQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXLUVQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:16:06 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50367 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbXLUVQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:16:02 -0500
Date: Fri, 21 Dec 2007 22:16:01 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Boldi <a1426z@gawab.com>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [RFC] USB Kconfig: Declutter USB Kconfig Menu
In-Reply-To: <200712211630.03426.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0712212211420.11671@fbirervta.pbzchgretzou.qr>
References: <200712211630.03426.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 21 2007 16:30, Al Boldi wrote:
>
>The current USB Kconfig menu is rather cluttered and unorganized.
>
>Propose new layout as follows:
>

Yes, this has been done before in a lot of places, and attempts to
clean up more menus is always welcome.

Try to use 'menuconfig' objects so people can disable a whole menu
at once without having to enter it, e.g. that USB Gadget thing down
there.

(You are free to post UTF-8.)

>  ┌──────────────────────────────────── USB support ─────────────────────────────────────┐
>  │  Arrow keys navigate the menu.  <Enter> selects submenus --->.  Highlighted letters  │  
>  │  are hotkeys.  Pressing <Y> includes, <N> excludes, <M> modularizes features.  Press │  
>  │  <Esc><Esc> to exit, <?> for Help, </> for Search.  Legend: [*] built-in  [ ]        │  
>  │  excluded  <M> module  < > module capable                                            │  
>  │ ┌──────────────────────────────────────────────────────────────────────────────────┐ │  
>  │ │      --- USB support                                                             │ │   
>  │ │      <*>   Support for Host-side USB  --->                                       │ │   
>  │ │            USB Host Controller Drivers  --->                                     │ │   
>  │ │            USB Device Class drivers  --->                                        │ │   
>  │ │      ---   NOTE: USB_STORAGE needs SCSI, and 'SCSI disk support' may             │ │   
>  │ │      ---   also be needed; see USB_STORAGE Help for more information             │ │   
>  │ │      <*>   USB Mass Storage support  --->                                        │ │   
>  │ │      [ ]   The shared table of common (or usual) storage devices                 │ │   
>  │ │      [ ]   USB Monitor                                                           │ │   
>  │ │            USB Serial Converter support  --->                                    │ │   
>  │ │            USB DSL modem support  --->                                           │ │   
>  │ │            USB Imaging devices  --->                                             │ │   
>  │ │            USB Miscellaneous drivers  --->                                       │ │   
>  │ │            USB Gadget Support  --->                                              │ │   
>  │ │                                                                                  │ │   
>  │ │                                                                                  │ │   
>  │ │                                                                                  │ │   
>  │ │                                                                                  │ │   
>  │ │                                                                                  │ │   
>  │ │                                                                                  │ │   
>  │ │                                                                                  │ │   
>  │ │                                                                                  │ │   
>  │ └──────────────────────────────────────────────────────────────────────────────────┘ │  
>  ├──────────────────────────────────────────────────────────────────────────────────────┤  
>  │                           <Select>    < Exit >    < Help >                           │  
>  └──────────────────────────────────────────────────────────────────────────────────────┘  
>
>
>Any comments appreciated.
>
>
>Thanks!
>
>--
>Al
> 
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

