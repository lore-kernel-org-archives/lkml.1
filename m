Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbZLHLsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbZLHLsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZLHLsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:48:17 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:58803 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbZLHLsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:48:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=pwjdTr5DM79MpOQvhvjMNnrlKbgjDEVspO2DQxwF7g/6y+Cw2XXmks7ynRU0eq930S
         fO8G7NfGFMm+V66zOBO62iim6FjT0iDkTtLHrTImHRN3zJz4sq5arcUb+GUcNPsE7zYB
         05zIlsMp/5GWiCt4dH5U2MGUn6Qv3u2QyDsf4=
MIME-Version: 1.0
Date: Tue, 8 Dec 2009 12:48:23 +0100
Message-ID: <d3e73af70912080348q48556d5cx1e7c281da347e078@mail.gmail.com>
Subject: SMP Kernel and SCSI problem at boot
From: Sim <simvirus@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
excuse my (old) question, but I have a big problem with kernel 2.4.21-4.EL
and SMP+SCSI (Red Hat), in a critical running server.

Trying to boot the server with SMP version (2.4.21-4.ELsmp)
the system sleep over "SCSI DAT detect".

This is the report of dmesg in NOT SMP version:
---------------------------------
[..]
PCI: Enabling device 03:0c.0 (0000 -> 0003)
scsi2 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.10
        <Adaptec 29320LP Ultra320 SCSI adapter>
        aic7901A: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs

Starting timer : 0 0
blk: queue f6d3dc14, I/O limit 4095Mb (mask 0xffffffff)
(scsi2:A:6): 80.000MB/s transfers (40.000MHz, 16bit)
  Vendor: IBM       Model: DDS Gen5          Rev: A060
  Type:   Sequential-Access                  ANSI SCSI revision: 03
Starting timer : 0 0
blk: queue f6d3de14, I/O limit 4095Mb (mask 0xffffffff)
Journalled Block Device driver loaded
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Freeing unused kernel memory: 164k freed
usb.c: registered new driver usbdevfs
usb.c: registered new driver hub
usb-uhci.c: $Revision: 1.275 $ time 18:21:59 Oct  3 2003
usb-uhci.c: High bandwidth mode enabled
PCI: Setting latency timer of device 00:1d.0 to 64
usb-uhci.c: USB UHCI at I/O 0x2200, IRQ 5
usb-uhci.c: Detected 2 ports
usb.c: new USB bus registered, assigned bus number 1
[..]
---------------------------------


With SMP boot, the system stops its startup with:
---------------------------------
[..]
PCI: Enabling device 03:0c.0 (0000 -> 0003)
scsi2 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.10
        <Adaptec 29320LP Ultra320 SCSI adapter>
        aic7901A: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs

Starting timer : 0 0
blk: queue f6d3dc14, I/O limit 4095Mb (mask 0xffffffff)
---------------------------------


Looking around this problemsSomeone wrote:

...Dumping the ahd state when probing the da and simply stopped.
So I set the SCSI BIOS to restrict the device speed upto 80MB/s and
the problem went away.
After that, the machine runs flawlessly for 8 months.


Can You help me?

Best Regards

---
Sim
