Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbXF0R5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbXF0R5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758630AbXF0R4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:56:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:50421 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbXF0R4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:56:53 -0400
Message-ID: <4682A4E2.4020206@anagramm.de>
Date: Wed, 27 Jun 2007 19:56:50 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.5: BUG: usbtouchscreen.c DMC TSC-10 wrong descriptor type
 / type->init() failed.
References: <468294E4.40801@anagramm.de> <d120d5000706271004u5e2304dekd4ad5315cdd4a55@mail.gmail.com>
In-Reply-To: <d120d5000706271004u5e2304dekd4ad5315cdd4a55@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/erSWyttjpP/l5uZnnn4xXxaX56X+yadMIXnc
 Nk/Lu55ezZa7zCDjxTU/uxkXoi2AME18DbfSM9SJVzeRrvYSoX
 ybWVkHswJwUvQRKPZUs3w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dimitry!

Dmitry Torokhov schrieb:
> On 6/27/07, Clemens Koller <clemens.koller@anagramm.de> wrote:
>> drivers/usb/input/usbtouchscreen.c: usbtouch_probe - type->init() 
>> failed, err: -19
> 
> dmc_tsc10_init() returns -ENODEV (-19) when device responds with
> something other than 0x06 0x00 to the "reset" and "set rate" commands.
> It would be interesting to see what your touchscreen responses are.

Yes, thank you!
I just had a look into the datasheet.
(tsc10usb_pi_e.pdf, Rev. 1.2 from November 1, 2005)
and I will need more debugging info to the dmc_tsc10_init()...

As I wrote, I am using the TSC-103 without EEPROM.
(I can add one if it's of any use.)
The PanelID is 0 (pin 3 [SEL1] is low), so it's the "first"
device on the bus.

What exact chip version and EEPROM configuration do you use?
I guess there are different firmware releases for the different
TSC-10* devices which behave... well... different. :-(

Regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
