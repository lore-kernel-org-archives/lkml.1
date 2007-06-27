Return-Path: <linux-kernel-owner+w=401wt.eu-S1762134AbXF0Q0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134AbXF0Q0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbXF0QZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:25:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbXF0QZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:25:55 -0400
Message-ID: <46828F91.9050405@anagramm.de>
Date: Wed, 27 Jun 2007 18:25:53 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.5 BUG: USB FTDI FT323BM usb exports duplicate symbols
References: <46826EA3.2020707@anagramm.de> <200706271612.46175.oliver@neukum.org>
In-Reply-To: <200706271612.46175.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/lP8nvW1JmRht76nNYIGIIFb4b25otZlbp8nm
 grYcR54JcjANrvFVrxZq6kXpRBGDvfMdEeXzweOgAQWjAjon3v
 /OtTtbFBt6sTgSbvPwauQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum schrieb:
> Am Mittwoch, 27. Juni 2007 schrieb Clemens Koller:
>> Whenever I plug/unplug the FTDI FT232BM USB-RS232 converter, the latest
>> 2.6.21.5 kernel complains:
>>
>> usb 2-1: USB disconnect, address 7
>> ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
>> ftdi_sio 2-1:1.0: device disconnected
>> usb 3-1: new full speed USB device using ohci_hcd and address 43
>> usb 3-1: configuration #1 chosen from 1 choice
>> ftdi_sio 3-1:1.0: FTDI USB Serial Device converter detected
>> drivers/usb/serial/ftdi_sio.c: Detected FT232BM
>> usb 3-1: FTDI USB Serial Device converter now attached to ttyUSB0
>> usbcore: exports duplicate symbol usb_buffer_unmap_sg (owned by kernel)
>> usbserial: exports duplicate symbol usb_serial_port_softint (owned by kernel)
> 
> Please rebuild your kernel and modules from scratch. It looks like you are
> mixing builds.

Okay, I rebuilt the kernel in a new tree and cleaned up /lib/modules/*
so, the problem is solved.

Thank you.
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
