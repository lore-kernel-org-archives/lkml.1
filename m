Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbZH3QDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbZH3QDO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 12:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZH3QDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 12:03:13 -0400
Received: from mail-yw0-f188.google.com ([209.85.211.188]:41475 "EHLO
	mail-yw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbZH3QDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 12:03:13 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Aug 2009 12:03:13 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=cS0ICBg5DSzJMaKgDOS5hvEDVxHaw32r1jkEgxyNN0pTCmF72kFBN+4L/gGSBgi5oG
         TaGHt+G6Y4YuJiXlw+MUtJ/TE3WMiOv2Gzz4+mdsmzf7Zji/fCd7n8juOdzetDrPYVC8
         BF3wZXWLh/k8OZaAJiv9K6Gu3tfhjofzQMxaE=
MIME-Version: 1.0
Date: Sun, 30 Aug 2009 11:56:49 -0400
Message-ID: <804dabb00908300856x3e5d03f9m2a1672009b904cdb@mail.gmail.com>
Subject: micro-SD problem
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just bought an 8G brand new micro-SD.....i plugged into my
blackberry....it created the filesystem inside....and then I plugged
into m WinXP SP3, and I can some directories created on it, and i can
even copy files to the subdir.

Next i plugged it into my Linux:   (2.6.31-rc6) and got the following
dmesg output:

[   39.513014] eth0: no IPv6 routers present
[14556.821035] usb 1-1: new high speed USB device using ehci_hcd and address 2
[14556.937437] usb 1-1: configuration #1 chosen from 1 choice
[14557.035489] Initializing USB Mass Storage driver...
[14557.035663] scsi6 : SCSI emulation for USB Mass Storage devices
[14557.036575] usbcore: registered new interface driver usb-storage
[14557.036580] USB Mass Storage support registered.
[14557.044956] usb-storage: device found at 2
[14557.044960] usb-storage: waiting for device to settle before scanning
[14562.044859] scsi 6:0:0:0: Direct-Access     Multi    Flash Reader
  1.00 PQ: 0 ANSI: 0
[14562.045118] sd 6:0:0:0: Attached scsi generic sg2 type 0
[14592.806021] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[14603.023025] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[14619.240021] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[14619.458027] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[14629.675032] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[14629.791287] sd 6:0:0:0: Device offlined - not ready after error recovery
[14629.791334] sd 6:0:0:0: rejecting I/O to offline device
[14629.791362] sd 6:0:0:0: rejecting I/O to offline device
[14629.791382] sd 6:0:0:0: rejecting I/O to offline device
[14629.791391] sd 6:0:0:0: [sdc] READ CAPACITY failed
[14629.791395] sd 6:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK
[14629.791402] sd 6:0:0:0: [sdc] Sense not available.
[14629.791419] sd 6:0:0:0: rejecting I/O to offline device
[14629.791431] sd 6:0:0:0: [sdc] Write Protect is off
[14629.791436] sd 6:0:0:0: [sdc] Mode Sense: 00 00 00 00
[14629.791440] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[14629.791650] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[14629.791874] usb-storage: device scan complete


fdisk -l /dev/sdc returned nothing, neither it is automounted by my
FedoraCore 10.   Is there any limitations/problems from the Linux
side?

-- 
Regards,
Peter Teoh
