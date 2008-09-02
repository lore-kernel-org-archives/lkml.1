Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbYIBO0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbYIBO0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYIBO0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:26:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:32400 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYIBO0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ALjPjPmbioShMnqWRhT/hhMUPgNLU/uM7DFcCEegSWRdbpOxv6qiWLFKdeeVvboC+6
         gUrcKcgaEh1U1qWdxf0x5Q37SrCXnfwAOdlNldbwp1145SyCJGwqOoTmLZySaWdFt1qC
         vJciFWhKkBz6JWPXNNSxsmbSh0ijeXX8sW2tA=
Message-ID: <48BD4D20.5020704@gmail.com>
Date: Tue, 02 Sep 2008 16:26:40 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5-mmotm0829 - CONFIG_HID_COMPAT causes hangs at boot
References: <7419.1220261347@turing-police.cc.vt.edu>
In-Reply-To: <7419.1220261347@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu napsal(a):
> I built a rc5-mmotm kernel, and set CONFIG_HID_COMPAT=y, but then found
> that I didn't actually *need* any of quirks files that tries to load, so
> those all got set to 'n'.
> 
> The resulting kernel would get this far (using a HID_COMPAT=n kernel's dmesg
> and annotating, I couldn't get netconsole) and then hang while still running
> off the initrd:
> 
> [    1.665167] usb 1-8: New USB device found, idVendor=413c, idProduct=0058
> [    1.678083] usb 1-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    1.753101] usb 1-8.1: new low speed USB device using ehci_hcd and address 5
> [    1.842008] usb 1-8.1: configuration #1 chosen from 1 choice
> [    1.869343] usb 1-8.1: New USB device found, idVendor=045e, idProduct=0023
> [    1.882267] usb 1-8.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    1.895189] usb 1-8.1: Product: Microsoft Trackball OpticalÂ®
> [    1.908056] usb 1-8.1: Manufacturer: Microsoft
> 
> (the next line would make it to the console)
> 
> [    1.926685] input: Microsoft Microsoft Trackball OpticalÂ® as /devices/pci000:00/0000:00:1d.7/usb1/1-8/1-8.1/1-8.1:1.0/input/input1
> [    1.945217] generic-usb 0003:045E:0023.0001: input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft Trackball OpticalÂ®] on usb-0000:00:1d.7-8.1/input0
> [    1.959193] usbcore: registered new interface driver usbhid
> [    1.973037] usbhid: v2.6:USB HID core driver
> 
> (the following line would not)
> [    1.987014] Advanced Linux Sound Architecture Driver Version 1.0.18rc1.
> 
> Poking around with sysrq-T would show a modprobe process running and not
> making any progress, just hung waiting for something.  I can go get the
> traceback if needed.

I'm confused of your description. Which line exactly is the last one on
HID_COMPAT=y and which lines go through with n -- does it hang too?

> This ring any bells?

Not really, sorry.
