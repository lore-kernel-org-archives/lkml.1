Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbZAVWgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbZAVWgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbZAVWf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:35:59 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43665 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZAVWf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:35:58 -0500
Message-ID: <4978F3CF.2010301@cs.helsinki.fi>
Date: Fri, 23 Jan 2009 00:31:43 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Sandro Bonazzola <sandro.bonazzola@gmail.com>
CC: Pavel Machek <pavel@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in	wb35_probe()
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI> <20090122114237.GA13845@atrey.karlin.mff.cuni.cz> <4978C812.90702@gmail.com> <20090122211052.GA1928@elf.ucw.cz> <4978F47C.6010909@gmail.com>
In-Reply-To: <4978F47C.6010909@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sandro Bonazzola wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Pavel Machek ha scritto:
> 
>> Maybe you could try _current_ w35und on 2.6.28 or something like that?
>> I have feeling that networking core changed in incompatible way here.
> 
> Ok, test done with git current version of w35und over 2.6.28-gentoo-r1 (2.6.28.1
> and some patches)
> 
> # uname -a
> Linux arilinn 2.6.28-gentoo-r1 #1 Wed Jan 21 19:37:07 CET 2009 x86_64 AMD
> Athlon(tm) 64 Processor 3500+ AuthenticAMD GNU/Linux
> 
> # dmesg
> usb 1-3: new high speed USB device using ehci_hcd and address 4
> usb 1-3: configuration #1 chosen from 1 choice
> usb 1-3: New USB device found, idVendor=18e8, idProduct=6201
> usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-3: Product: Usb2Wlan
> usb 1-3: Manufacturer: WINBOND
> usb 1-3: SerialNumber: 101d350112
> w35und: module is from the staging directory, the quality is unknown, you have
> been warned.
> w35und: probe of 1-3:1.0 failed with error 4

Yeah, my patch is not in -git yet so you still need to apply it manually 
to get over this part.

> usbcore: registered new interface driver w35und
> 
> I'll be away untill monday.
> 
> - --
> Sandro
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.9 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
> 
> iEYEARECAAYFAkl49HwACgkQV871CybFezmbDACgmYRXmSVpXePYuNndXDf0x1WO
> UvUAn3e456zicd7M05KCLQlXyoUlRtGg
> =JW6n
> -----END PGP SIGNATURE-----

