Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbZAJXzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbZAJXzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbZAJXzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:55:38 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:28698 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbZAJXzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:55:37 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=pg9HUYMpGyUeBZk-p9MA:9 a=_wb7nFAKa9rtbsIaisVOsD3A144A:4 a=kNAwe-3CODUA:10 a=XK7UU1QYhjMA:10
Message-ID: <49693575.2030007@shaw.ca>
Date: Sat, 10 Jan 2009 17:55:33 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: RHubbell@iHubbell.com
CC: linux-kernel@vger.kernel.org
Subject: Re: USB memory card reader and 64MB SD card - 2.6.28-git14
References: <1231621530.4495.36.camel@127>
In-Reply-To: <1231621530.4495.36.camel@127>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rhubbell wrote:
> (Please CC me in replie,s if it's not too much trouble.)
> 
> I had this issue with previous kernels, but I don't know when the
> problem
> started. I once was able to read this card.
> 
> Not sure what filesystems are on either card, not sure if it matters.
> The cards are not mounted automatically so I am guessing that the
> file system doesn't become an issue until mount time.
> 
> The device is a Phison 6-in-1 and has no problems with
> other cards.
> 
> When inserted this card causes no problems:
> 
> This is a 128MB card:
> 
> Jan 10 10:47:06  kernel:  uba: uba1

Looks like your kernel is configured to use the ub "low performance USB 
storage" driver, you could try the normal USB storage driver instead..

> 
> 
> When the next card is inserted the keyboard partially locks up, the
> special laptop keys work still.
> e.g. the fn-contrast up/dn works still but not other keys work
> 
> Removing the card returns things to as before insertion.
> 
> This is a 64MB card from a phone:
> 
> Jan 10 10:54:44  kernel:  ubc: ubc1
> Jan 10 10:54:44  kernel: usb 3-1: reset full speed USB device using
> ohci_hcd and address 4
> Jan 10 10:54:51  kernel: usb 3-1: reset full speed USB device using
> ohci_hcd and address 4
> Jan 10 10:54:52  kernel: __ratelimit: 22 callbacks suppressed
> Jan 10 10:55:00  kernel: usb 3-1: reset full speed USB device using
> ohci_hcd and address 4
> Jan 10 10:55:16  kernel:  ubc: ubc1
> Jan 10 10:55:16  kernel: usb 3-1: reset full speed USB device using
> ohci_hcd and address 4
> Jan 10 10:55:23  kernel: usb 3-1: reset full speed USB device using
> ohci_hcd and address 4
> Jan 10 10:55:24  kernel: __ratelimit: 9 callbacks suppressed
> Jan 10 10:55:32  kernel: usb 3-1: reset full speed USB device using
> ohci_hcd and address 4
> Jan 10 10:55:56  kernel: usb 3-1: reset full speed USB device using
> ohci_hcd and address 4
> Jan 10 10:56:44  kernel:  ubc: ubc1
> Jan 10 10:56:44  kernel: usb 3-1: reset full speed USB device using
> ohci_hcd and address 4
> Jan 10 10:56:51  kernel: usb 3-1: reset full speed USB device using
> ohci_hcd and address 4
> Jan 10 10:56:52  kernel: __ratelimit: 22 callbacks suppressed
> Jan 10 10:57:00  kernel: usb 3-1: reset full speed USB device using
> ohci_hcd and address 4
> 
> lspci:
> 
> 00:02.0 USB Controller: nVidia Corporation nForce3 USB 1.1 (rev a5)
> 00:02.1 USB Controller: nVidia Corporation nForce3 USB 1.1 (rev a5)
> 00:02.2 USB Controller: nVidia Corporation nForce3 USB 2.0 (rev a2)
> 
> 

