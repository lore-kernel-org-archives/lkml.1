Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbZAVWex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbZAVWex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZAVWep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:34:45 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:47610 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbZAVWeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:34:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=k7bGgWInFNnqUVMGbsqZcEPkBt13fajkV58W3gFUracoziQQtLsbse6EcRqpX/QvWh
         Rjt707gokob/5zynKW729/FvuoDgs5q9pGpgyxdUZRs/H1MMJzK+EkOpz/YPxLQnrHPT
         e31FO0d2+lf943IpkwzvVSkf4gvGAxx3BckXk=
Message-ID: <4978F47C.6010909@gmail.com>
Date: Thu, 22 Jan 2009 23:34:36 +0100
From: Sandro Bonazzola <sandro.bonazzola@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in	wb35_probe()
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI> <20090122114237.GA13845@atrey.karlin.mff.cuni.cz> <4978C812.90702@gmail.com> <20090122211052.GA1928@elf.ucw.cz>
In-Reply-To: <20090122211052.GA1928@elf.ucw.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pavel Machek ha scritto:

> Maybe you could try _current_ w35und on 2.6.28 or something like that?
> I have feeling that networking core changed in incompatible way here.

Ok, test done with git current version of w35und over 2.6.28-gentoo-r1 (2.6.28.1
and some patches)

# uname -a
Linux arilinn 2.6.28-gentoo-r1 #1 Wed Jan 21 19:37:07 CET 2009 x86_64 AMD
Athlon(tm) 64 Processor 3500+ AuthenticAMD GNU/Linux

# dmesg
usb 1-3: new high speed USB device using ehci_hcd and address 4
usb 1-3: configuration #1 chosen from 1 choice
usb 1-3: New USB device found, idVendor=18e8, idProduct=6201
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-3: Product: Usb2Wlan
usb 1-3: Manufacturer: WINBOND
usb 1-3: SerialNumber: 101d350112
w35und: module is from the staging directory, the quality is unknown, you have
been warned.
w35und: probe of 1-3:1.0 failed with error 4
usbcore: registered new interface driver w35und

I'll be away untill monday.

- --
Sandro
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkl49HwACgkQV871CybFezmbDACgmYRXmSVpXePYuNndXDf0x1WO
UvUAn3e456zicd7M05KCLQlXyoUlRtGg
=JW6n
-----END PGP SIGNATURE-----
