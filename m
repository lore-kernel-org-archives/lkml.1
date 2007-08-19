Return-Path: <linux-kernel-owner+w=401wt.eu-S1752300AbXHSWKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbXHSWKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbXHSWKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:10:14 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:57942 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbXHSWKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=T3dzxP1rC7jobiiYdPzEJM8j8qfYo5Xn8wlWN9UcynTkV9JCUz1vZJYu5MTb5enf/8/S/4I1z3n3m4vROqnemttUZE7Ah+9JYI9/av32QnW0+YbYtMZRcxaL7yuptdAHoNuzmGJz+55Ye27raa7S2rTCh2bYkFNGKkEEkDUirBs=
Message-ID: <46C8BFAF.50604@googlemail.com>
Date: Mon, 20 Aug 2007 00:09:51 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: bizu <bizu@burlesk.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: HTC as USB gprs/edge modem on linux
References: <c929dccd5f4f0fec6ad55e93caafae43@127.0.0.1>
In-Reply-To: <c929dccd5f4f0fec6ad55e93caafae43@127.0.0.1>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

bizu pisze:
> Hi,
> 
> I've got an HTC P4350 running Win Mobile 5.
> 
> I can synchronize data with synce, everything work fine.
> 
> But i can't use it as an USB modem on linux, where as everything work
> fine on windows.
> 
> To get it working with windows, i activate the 'internet share' on the
> HTC and plug it to the laptop by USB. Then a virtual network interface
> called 'Windows Mobile-base Internet Sharing Device' is mounted, its
> address is attributed by DHCP, and its speed connection is fixed to
> 10Mbps.
> And everything work fine, i can surf to the web by edge....
> 
> 
> 
> So now, let's go on linux!
> i'm on debian leeny/sid with a recompiled kernel 2.6.22.1 (see my
> config file at bottom)
> my USB Controller is:
> USB Controller: Intel Corporation 82801CA/CAM USB (Hub #1) (rev 02)
> and i use udev as device manager
> 
> at boot, there are my loaded modules:
> Module                  Size  Used by
> apm                    19284  2
> ipv6                  234596  14
> sr_mod                 15396  0
> pcmcia                 37780  0
> firmware_class          9472  1 pcmcia
> ide_cd                 38048  0
> e100                   34316  0
> mii                     5632  1 e100
> uhci_hcd               32400  0
> cdrom                  35616  2 sr_mod,ide_cd
> rtc                    11800  0
> yenta_socket           25868  5
> rsrc_nonstatic         11136  1 yenta_socket
> pcmcia_core            38288  3 pcmcia,yenta_socket,rsrc_nonstatic
> parport_pc             24740  0
> parport                23616  1 parport_pc
> 8250_pnp                9728  0
> usbcore               141336  2 uhci_hcd
> 8250_pci               20608  0
> 8250                   22132  2 8250_pnp,8250_pci
> serial_core            19840  1 8250
> 
> 
> 
> Now i connect the HTC in modem mode:
> $> dmesg:
> usb usb1: usb resume
> usb usb1: finish resume
> hub 1-0:1.0: hub_resume
> usb usb1: wakeup_rh
> hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
> uhci_hcd 0000:00:1d.0: port 1 portsc 0093,00
> hub 1-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
> hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
> usb 1-1: new full speed USB device using uhci_hcd and address 2
> usb 1-1: skipped 3 descriptors after interface
> usb 1-1: default language 0x0409
> usb 1-1: new device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-1: Product: Generic RNDIS
> usb 1-1: Manufacturer: HTC
> usb 1-1: SerialNumber: fb511207-593d-1103-a800-0050bf3f5173
> usb 1-1: uevent
> usb 1-1: usb_probe_device
> usb 1-1: configuration #1 chosen from 1 choice
> usb 1-1: adding 1-1:1.0 (config #1, interface 0)
> usb 1-1:1.0: uevent
> usb 1-1:1.0: uevent
> usb 1-1: adding 1-1:1.1 (config #1, interface 1)
> usb 1-1:1.1: uevent
> usb 1-1:1.1: uevent
> drivers/usb/core/inode.c: creating file '002'
> hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
> usb 1-1: usb auto-suspend
> hub 1-0:1.0: hub_suspend
> usb usb1: suspend_rh
> usb usb1: usb auto-suspend
> 
> I don't understand why there is a suspend action on my usb-hub
> Furthermore the HTC ask me to check the USB connexion.
> 

This patch (against 2.6.23-rc3-git2) disables auto-suspend for this device.

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index b7917c5..d715d46 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -64,6 +64,8 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x05d8, 0x4005), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
 	/* Agfa Snapscan1212u */
 	{ USB_DEVICE(0x06bd, 0x2061), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
+	/* High Tech Computer Corp. Generic RNDIS */
+	{ USB_DEVICE(0x0bb4, 0x0303), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
 	/* Umax [hex] Astra 3400U */
 	{ USB_DEVICE(0x1606, 0x0060), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
 
