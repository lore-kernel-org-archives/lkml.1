Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbXLaBP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbXLaBP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 20:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758641AbXLaBPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 20:15:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:54200 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214AbXLaBPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 20:15:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EbdITIlhvnI74Wj8+GEWY2vjN8c63DcSjSBZ39JENPVASguWHJABozdPmoOV+alRTPdLxhEKPjmUt6akR2OUL749YbkZrC3A3pHfk6jivHmGY+NM5CGnCVI+R3DoAEtSP5Jktvya3Aeh/0VFhF535XSkDkIicrYc4hfEhrXj4LQ=
Message-ID: <a276da400712301715p722590ecw37236bf8d8c6f63d@mail.gmail.com>
Date: Mon, 31 Dec 2007 09:15:40 +0800
From: "Xiaofan Chen" <xiaofanc@gmail.com>
To: mgross <640e9920@gmail.com>
Subject: Re: [RFC] USB driver for talking to the Microchip PIC18 boot loader
Cc: "Alan Stern" <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <a276da400712292046k5d9a47c2x462c9070275d8ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229193409.GA20188@mgross-t43>
	 <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org>
	 <a276da400712291840m7d90d6fr5d80f21a04a1c1b3@mail.gmail.com>
	 <20071230042939.GB4741@mgross-t43>
	 <a276da400712292046k5d9a47c2x462c9070275d8ee@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 12:46 PM, Xiaofan Chen <xiaofanc@gmail.com> wrote:
> If you do not like the existing fsusb application, you can rewrite
> it in python with pyusb (which is based on libusb) but you do not
> need a kernel driver.
>
> pyusb: http://pyusb.berlios.de/
>
> Hex file parsing  in pyk by Mark Rages. He is using the Bitpim
> libusb wrapper which IMHO is not as good as pyusb.
> http://groups.google.com/group/pickit-devel/msg/35e850832256e890

The pyk code is for PICkit 2 and include the PICKit 2 bootloader.
it is an HID device so it is different from PICDEM FS-USB but you
might be able to reuse part of the codes.

By the way, there is another perl based code for the bootloader.
Just in case you are interested. Again I do not know perl and I
am not so sure if it is good enough for you.
http://www.nabble.com/HID-keyboard-code-for-gpasm-and-the-fs-picdem-board-td860144.html
http://www.nabble.com/attachment/878980/0/picdem.pl.bz2

Thinking about it, if the Linux USB maintainers agree to include your
driver, I have no objections. It should not affect the existing libusb
based applications and the users have one more choices.

Xiaofan
