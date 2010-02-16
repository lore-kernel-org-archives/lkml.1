Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab0BPQou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:44:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:49759 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757015Ab0BPQor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:44:47 -0500
X-Authenticated: #6146996
X-Provags-ID: V01U2FsdGVkX19ctxslAmdcCxeHxR/Qp2pWqR1EZeai1kobbkAp3s
	PNAVRZFgXBduSC
Message-ID: <4B7ACB75.4070907@gmx.ch>
Date: Tue, 16 Feb 2010 17:44:37 +0100
From: Jan Sechser <jsechser@gmx.ch>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Sony Ericson w995 does not local net mode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys,


Please CC me for Questions and answers


I have got an w995 Sony Ericsson, but i cant make local net via usb with it.
I uploaded a recent software version: 1215-7995 R1HA036 091216



First for the usb ID guys since the ids are not yet in usbid.txt:

PC mode            (for Windows(r))
  usb 1-4: New USB device found, idVendor=0fce, idProduct=e112
  usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
  usb 1-4: Product: Memory Card (MSC)
  usb 1-4: Manufacturer: Sony Ericsson
  usb 1-4: SerialNumber: 3582180356368990
  usb 1-4: configuration #1 chosen from 1 choice


USB mem. device        (File transfer)
  usb 1-4: New USB device found, idVendor=0fce, idProduct=2112
  usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
  usb 1-4: Product: Sony Ericsson W995
  usb 1-4: Manufacturer: Sony Ericsson
  usb 1-4: SerialNumber: 3582180356368990
  usb 1-4: configuration #1 chosen from 5 choices
  Initializing USB Mass Storage driver...

Other OS         (E.g. Mac(tm), Linux(tm))
  usb 1-4: New USB device found, idVendor=0fce, idProduct=d112
  usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
  usb 1-4: Product: Sony Ericsson W995
  usb 1-4: Manufacturer: Sony Ericsson
  usb 1-4: SerialNumber: 3582180356368990
  usb 1-4: configuration #1 chosen from 1 choice

MTP devices        (E.g. certain car stereos)
  usb 1-4: New USB device found, idVendor=0fce, idProduct=0112
  usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
  usb 1-4: Product: W995
  usb 1-4: Manufacturer: Sony Ericsson
  usb 1-4: SerialNumber: 3582180356368990
  usb 1-4: configuration #1 chosen from 1 choice


Now USB mass storage works, PC mode doesnt bother me much, but i 
actually excepted Other OS mode to work, which it does not.

following are the logs:
Feb  6 18:40:01 jebian2 kernel: [  247.240026] usb 1-4: new high speed 
USB device using ehci_hcd and address 6
Feb  6 18:40:01 jebian2 kernel: [  247.376970] usb 1-4: New USB device 
found, idVendor=0fce, idProduct=d112
Feb  6 18:40:01 jebian2 kernel: [  247.376977] usb 1-4: New USB device 
strings: Mfr=1, Product=2, SerialNumber=3
Feb  6 18:40:01 jebian2 kernel: [  247.376983] usb 1-4: Product: Sony 
Ericsson W995
Feb  6 18:40:01 jebian2 kernel: [  247.376987] usb 1-4: Manufacturer: 
Sony Ericsson
Feb  6 18:40:01 jebian2 kernel: [  247.376991] usb 1-4: SerialNumber: 
3582180356368990
Feb  6 18:40:01 jebian2 kernel: [  247.378726] usb 1-4: configuration #1 
chosen from 1 choice
Feb  6 18:40:01 jebian2 kernel: [  247.487110] cdc_wdm 1-4:1.7: 
cdc-wdm0: USB WDM device
Feb  6 18:40:01 jebian2 kernel: [  247.487190] usbcore: registered new 
interface driver cdc_wdm
Feb  6 18:40:01 jebian2 kernel: [  247.502990] cdc_acm 1-4:1.1: ttyACM0: 
USB ACM device
Feb  6 18:40:01 jebian2 kernel: [  247.515010] cdc_acm 1-4:1.3: ttyACM1: 
USB ACM device
Feb  6 18:40:01 jebian2 kernel: [  247.531016] usbcore: registered new 
interface driver cdc_acm
Feb  6 18:40:01 jebian2 kernel: [  247.531024] cdc_acm: v0.26:USB 
Abstract Control Model driver for USB modems and ISDN adapters
Feb  6 18:40:01 jebian2 kernel: [  247.536755] usbcore: registered new 
interface driver cdc_ether
Feb  6 18:40:01 jebian2 kernel: [  247.543927] usb 1-4: unsupported MDLM 
descriptors
Feb  6 18:40:01 jebian2 kernel: [  247.544394] usbcore: registered new 
interface driver zaurus
Feb  6 18:40:01 jebian2 modem-manager: (ttyACM1) opening serial device...
Feb  6 18:40:01 jebian2 modem-manager: (ttyACM1): probe requested by 
plugin 'Generic'
Feb  6 18:40:01 jebian2 modem-manager: (ttyACM0) opening serial device...
Feb  6 18:40:01 jebian2 modem-manager: (ttyACM0): probe requested by 
plugin 'Generic'
Feb  6 18:40:03 jebian2 modem-manager: (ttyACM1) closing serial device...
Feb  6 18:40:03 jebian2 modem-manager: (Generic): GSM modem 
/sys/devices/pci0000:00/0000:00:02.1/usb1/1-4 claimed port ttyACM1
Feb  6 18:40:03 jebian2 modem-manager: Added modem 
/sys/devices/pci0000:00/0000:00:02.1/usb1/1-4
Feb  6 18:40:03 jebian2 modem-manager: Exported modem 
/sys/devices/pci0000:00/0000:00:02.1/usb1/1-4 as 
/org/freedesktop/ModemManager/Modems/0
Feb  6 18:40:03 jebian2 modem-manager: (ttyACM0) closing serial device...
Feb  6 18:40:03 jebian2 modem-manager: (Generic): GSM modem 
/sys/devices/pci0000:00/0000:00:02.1/usb1/1-4 claimed port ttyACM0
Feb  6 18:40:03 jebian2 NetworkManager: <info>  (ttyACM1): new GSM 
device (driver: 'cdc_acm')
Feb  6 18:40:03 jebian2 NetworkManager: <info>  (ttyACM1): exported as 
/org/freedesktop/NetworkManager/Devices/2
Feb  6 18:40:03 jebian2 NetworkManager: <info>  (ttyACM1): now managed
Feb  6 18:40:03 jebian2 NetworkManager: <info>  (ttyACM1): device state 
change: 1 -> 2 (reason 2)
Feb  6 18:40:03 jebian2 NetworkManager: <info>  (ttyACM1): deactivating 
device (reason: 2).
Feb  6 18:40:03 jebian2 NetworkManager: <info>  (ttyACM1): device state 
change: 2 -> 3 (reason 0)


when removing the device
Feb  6 18:40:33 jebian2 kernel: [  279.107138] usb 1-4: USB disconnect, 
address 6
Feb  6 18:40:33 jebian2 kernel: [  279.116777] ehci_hcd 0000:00:02.1: 
dma_pool_free buffer-2048, ffff880052624000/52624000 (bad dma)
Feb  6 18:40:33 jebian2 modem-manager: Removed modem 
/sys/devices/pci0000:00/0000:00:02.1/usb1/1-4
Feb  6 18:40:33 jebian2 NetworkManager: <info>  (ttyACM1): now unmanaged
Feb  6 18:40:33 jebian2 NetworkManager: <info>  (ttyACM1): device state 
change: 3 -> 1 (reason 36)
Feb  6 18:40:33 jebian2 NetworkManager: <info>  (ttyACM1): cleaning up...
Feb  6 18:40:33 jebian2 NetworkManager: <info>  (ttyACM1): taking down 
device.


dmesg orig:
[  247.240026] usb 1-4: new high speed USB device using ehci_hcd and 
address 6
[  247.376970] usb 1-4: New USB device found, idVendor=0fce, idProduct=d112
[  247.376977] usb 1-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  247.376983] usb 1-4: Product: Sony Ericsson W995
[  247.376987] usb 1-4: Manufacturer: Sony Ericsson
[  247.376991] usb 1-4: SerialNumber: 3582180356368990
[  247.378726] usb 1-4: configuration #1 chosen from 1 choice
[  247.487110] cdc_wdm 1-4:1.7: cdc-wdm0: USB WDM device
[  247.487190] usbcore: registered new interface driver cdc_wdm
[  247.502990] cdc_acm 1-4:1.1: ttyACM0: USB ACM device
[  247.515010] cdc_acm 1-4:1.3: ttyACM1: USB ACM device
[  247.531016] usbcore: registered new interface driver cdc_acm
[  247.531024] cdc_acm: v0.26:USB Abstract Control Model driver for USB 
modems and ISDN adapters
[  247.536755] usbcore: registered new interface driver cdc_ether
[  247.543927] usb 1-4: unsupported MDLM descriptors
[  247.544394] usbcore: registered new interface driver zaurus
[  279.107138] usb 1-4: USB disconnect, address 6
[  279.116777] ehci_hcd 0000:00:02.1: dma_pool_free buffer-2048, 
ffff880052624000/52624000 (bad dma)



I guess you know better whats wrong than me.


cheers

jan

