Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbXL3EqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbXL3EqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 23:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbXL3EqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 23:46:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:37422 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbXL3EqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 23:46:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y0D5T6yM6YA72j/jecOslpMu3x8mUtHCMLLlhtrtpshz0Qo1M1lGqNhVaKSgGE7ACOlmkOEplIBvK48R9EX4wp/7lKuFhQCjaldJIIRGaXWZBQV6ScJ9tSd+D3fSiD0pJwBdxsSB1CebEldyNhMz4ig7khfEkNllG856wGVgfok=
Message-ID: <a276da400712292046k5d9a47c2x462c9070275d8ee@mail.gmail.com>
Date: Sun, 30 Dec 2007 12:46:12 +0800
From: "Xiaofan Chen" <xiaofanc@gmail.com>
To: mgross <640e9920@gmail.com>
Subject: Re: [RFC] USB driver for talking to the Microchip PIC18 boot loader
Cc: "Alan Stern" <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <20071230042939.GB4741@mgross-t43>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229193409.GA20188@mgross-t43>
	 <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org>
	 <a276da400712291840m7d90d6fr5d80f21a04a1c1b3@mail.gmail.com>
	 <20071230042939.GB4741@mgross-t43>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 12:29 PM, mgross <640e9920@gmail.com> wrote:
> The device ID's are different 0x000C in ldusb.c vrs 0x000b in the
> driver I just posted.

I know that. 000b is for the demo application. 000c is for the
bootloader application.

I am not a progammer myself but I think the USB communication part
of both the two libusb based application are fine. I have no comments
about the other part of fsusb coce.
http://forum.microchip.com/tm.aspx?m=106426


> > Please do not add it to the kernel. There are libusb based application
> > for both the bootloader and the demo application and both are working
> > fine under Linux (along with Windows and I am trying to get FreeBSD
> > working).
>
> The libusb based FW loader http://www.internetking.org/fsusb/ program
> is nasty and didn't work on one of my systems, so I refactored it into
> a kernel driver and python program.
>

If it does not work, read my patches and see if it will work.

If you do not like the existing fsusb application, you can rewrite
it in python with pyusb (which is based on libusb) but you do not
need a kernel driver.

pyusb: http://pyusb.berlios.de/

Hex file parsing  in pyk by Mark Rages. He is using the Bitpim
libusb wrapper which IMHO is not as good as pyusb.
http://groups.google.com/group/pickit-devel/msg/35e850832256e890


Xiaofan
