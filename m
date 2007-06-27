Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXF0TTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXF0TTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXF0TTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:19:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:3824 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbXF0TTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FKx6FkdgfCK9n5+PJZNM618Xa2oIx3gAd1m4GYskd23+CfOmmrSZYIzhFZ9WPglS7mtCAe78QFM4HH7w+BVOkjGzFp4j84l4Pfb2ui3Ef1uK2KwxFarj4akbcgIOA6aCnjOm55SdhWzKdl2Xo4tj5/Ue/iT2+1H7INQj+77QBR4=
Message-ID: <d120d5000706271219i7a892c27j33b9476bd3d9b2ae@mail.gmail.com>
Date: Wed, 27 Jun 2007 15:19:03 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Clemens Koller" <clemens.koller@anagramm.de>
Subject: Re: 2.6.21.5: BUG: usbtouchscreen.c DMC TSC-10 wrong descriptor type / type->init() failed.
Cc: linux-kernel@vger.kernel.org, "Daniel Ritz" <daniel.ritz@gmx.ch>
In-Reply-To: <4682A4E2.4020206@anagramm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <468294E4.40801@anagramm.de>
	 <d120d5000706271004u5e2304dekd4ad5315cdd4a55@mail.gmail.com>
	 <4682A4E2.4020206@anagramm.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/07, Clemens Koller <clemens.koller@anagramm.de> wrote:
> Hello, Dimitry!
>
> Dmitry Torokhov schrieb:
> > On 6/27/07, Clemens Koller <clemens.koller@anagramm.de> wrote:
> >> drivers/usb/input/usbtouchscreen.c: usbtouch_probe - type->init()
> >> failed, err: -19
> >
> > dmc_tsc10_init() returns -ENODEV (-19) when device responds with
> > something other than 0x06 0x00 to the "reset" and "set rate" commands.
> > It would be interesting to see what your touchscreen responses are.
>
> Yes, thank you!
> I just had a look into the datasheet.
> (tsc10usb_pi_e.pdf, Rev. 1.2 from November 1, 2005)
> and I will need more debugging info to the dmc_tsc10_init()...
>
> As I wrote, I am using the TSC-103 without EEPROM.
> (I can add one if it's of any use.)
> The PanelID is 0 (pin 3 [SEL1] is low), so it's the "first"
> device on the bus.
>
> What exact chip version and EEPROM configuration do you use?

I don't.

> I guess there are different firmware releases for the different
> TSC-10* devices which behave... well... different. :-(
>

Could be, although according to that data sheet 0x0600 is ACK for both
touchschreens with and without EEPROMs.

I think most of the changes fro USB touchscreen came in from Daniel
Ritz, let's try CCing him...

-- 
Dmitry
