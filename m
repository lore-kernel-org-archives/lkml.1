Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbYADTvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbYADTvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 14:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYADTvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 14:51:01 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:42307 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbYADTu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 14:50:59 -0500
Date: Fri, 04 Jan 2008 20:50:18 +0100
Message-Id: <86230258@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: [RFC] Remove clutter from what modules print to dmesg
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX199jNC/XFgTU5CQ7L9+rIGApGwEGYhIUhg+yKsCcIg5GFau4
 f+3ZS2PFl8TtwOnNpFdF6x7lXSPWhPZC9JcgVSiL29OJQSVRkU=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

while insanely looping trough a driver load/unload, i had taken a look at dmesg afterwards (i.e. after each modular driver had been loaded/unloaded once)

besides some other things that probably could be point of discussion, i saw noticeable clutter. (this is an admin`s point of view)

below is a list of that clutter (much of that is in ALSA or drivers/usb/serial btw)

left side as it is now, right side a "cleaned" version as i think it looks better. imho the latter would be more consistent output , since it`s mostly "modulename: ......" when a module has something to tell (if it tells anything at all)

let that be sort of a "standardization approach" to what modules print to dmesg.

cleaning this as proposed would shrink my dmesg output by ~1%

since i`m a such a kernel-hacking rookie and an appropriate patch would poke around in a lot of code, please tell me if such patch would be welcomed at all, so i wouldn`t waste time on this.

regards
roland 


with clutter                                                  |without clutter
3c503.c: Presently autoprobing (not recommended) for a single | 3c503: Presently autoprobing (not recommended) for a single c
3c503.c: No 3c503 card found (i/o = 0x0).                     | 3c503: No 3c503 card found (i/o = 0x0).
3c505.c: warning, using default DMA channel,                  | 3c505: warning, using default DMA channel,
3c505.c: module autoprobe not recommended, give io=xx.        | 3c505: module autoprobe not recommended, give io=xx.
3c505.c: Failed to register card at 0x0.                      | 3c505: Failed to register card at 0x0.
3c515.c:v0.99t-ac 28-Oct-2002 becker@scyld.com and others     | 3c515:v0.99t-ac 28-Oct-2002 becker@scyld.com and others
tms380tr.c: v1.10 30/12/2002 by Christoph Goos, Adam Fritzler | tms380tr: v1.10 30/12/2002 by Christoph Goos, Adam Fritzler
ac3200.c: No ac3200 card found (i/o = 0x0).                   | ac3200: No ac3200 card found (i/o = 0x0).
drivers/input/tablet/acecad.c: v3.2:USB Acecad Flair tablet d | acecad: v3.2:USB Acecad Flair tablet driver
drivers/usb/misc/adutux.c: adutux adutux (see www.ontrak.net) | adutux: adutux adutux (see www.ontrak.net) v0.0.13
drivers/usb/misc/adutux.c: adutux is an experimental driver.  | adutux: adutux is an experimental driver. Use at your own ris
drivers/input/tablet/aiptek.c: v2.3 (May 2, 2007): Bryan W. H | aiptek: v2.3 (May 2, 2007): Bryan W. Headley/Chris Atenasio/C
drivers/input/tablet/aiptek.c: Aiptek HyperPen USB Tablet Dri | aiptek: Aiptek HyperPen USB Tablet Driver (Linux 2.6.x)
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for aircable
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver aircable
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
airo(): Probing for PCI adapters                              | airo: Probing for PCI adapters
airo(): Finished probing for PCI adapters                     | airo: Finished probing for PCI adapters
airo(): Probing for PCI adapters                              | airo: Probing for PCI adapters
airo(): Finished probing for PCI adapters                     | airo: Finished probing for PCI adapters
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for airprime
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver airprime
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for ark3116
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver ark3116
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/input/misc/ati_remote.c: Registered USB driver ATI/X1 | ati_remote: Registered USB driver ATI/X10 RF USB Remote Contr
atp.c:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>    | atp:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Belkin / Peraco
drivers/usb/serial/belkin_sa.c: USB Belkin Serial converter d | belkin_sa: USB Belkin Serial converter driver v1.2
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Belkin / Peracom
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/net/usb/catc.c: v2.8 CATC EL1210A NetMate USB Etherne | catc: v2.8 CATC EL1210A NetMate USB Ethernet driver
drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model | cdc-acm: v0.25:USB Abstract Control Model driver for USB mode
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for ch341-uart
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver ch341-uart
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
cm4000_cs.c v2.4.0gm6 - All bugs added by Harald Welte        | cm4000_cs v2.4.0gm6 - All bugs added by Harald Welte
cops.c:v0.04 6/7/98 Jay Schulist <jschlst@samba.org>          | cops: v0.04 6/7/98 Jay Schulist <jschlst@samba.org>
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for cp2101
drivers/usb/serial/cp2101.c: Silicon Labs CP2101/CP2102 RS232 | cp2101: Silicon Labs CP2101/CP2102 RS232 serial adaptor drive
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver cp2101
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
cs89x0.c: Module autoprobing not allowed.                     | cs89x0: Module autoprobing not allowed.
cs89x0.c: Append io=0xNNN                                     | cs89x0: Append io=0xNNN
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded              | cx88: cx2388x v4l2 driver version 0.0.6 loaded
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded   | cx88: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: blackbird access: sh | cx88: registering cx8802 driver, type: blackbird access: shar
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded   | cx88: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88/2: cx2388x dvb driver version 0.0.6 loaded               | cx88: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared   | cx88: registering cx8802 driver, type: dvb access: shared
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded              | cx88: cx2388x v4l2 driver version 0.0.6 loaded
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded   | cx88: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Reiner SCT Cybe
drivers/usb/serial/cyberjack.c: v1.01 Matthias Bruestle       | cyberjack: v1.01 Matthias Bruestle
drivers/usb/serial/cyberjack.c: REINER SCT cyberJack pinpad/e | cyberjack: REINER SCT cyberJack pinpad/e-com USB Chipcard Rea
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Reiner SCT Cyberj
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for DeLorme Earthma
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for HID->COM RS232
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Nokia CA-42 V2
drivers/usb/serial/cypress_m8.c: Cypress USB to Serial Driver | cypress_m8: Cypress USB to Serial Driver v1.09
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver DeLorme Earthmate
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver HID->COM RS232 Ad
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Nokia CA-42 V2 Ad
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/misc/cytherm.c: v1.0:Cypress USB Thermometer driv | cytherm: v1.0:Cypress USB Thermometer driver
drivers/media/video/dabusb.c: v1.54:DAB-USB Interface Driver  | dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Digi 2 port USB
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Digi 4 port USB
drivers/usb/serial/digi_acceleport.c: v1.80.1.2:Digi AccelePo | digi_acceleport: v1.80.1.2:Digi AccelePort USB-2/USB-4 Serial
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Digi 2 port USB a
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Digi 4 port USB a
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/media/radio/dsbr100.c: v0.41:D-Link DSB-R100 USB FM r | dsbr100: v0.41:D-Link DSB-R100 USB FM radio driver
e2100.c: Presently autoprobing (not recommended) for a single | e2100: Presently autoprobing (not recommended) for a single c
e2100.c: No E2100 card found (i/o = 0x0).                     | e2100: No E2100 card found (i/o = 0x0).
eepro100.c:v1.09j-t 9/29/99 Donald Becker                     | eepro100: v1.09j-t 9/29/99 Donald Becker
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V | eepro100: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V.
eexpress.c: Module autoprobe not recommended, give io=xx.     | eexpress: Module autoprobe not recommended, give io=xx.
eexpress.c: Failed to register card at 0x0.                   | eexpress: Failed to register card at 0x0.
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for empeg
drivers/usb/serial/empeg.c: v1.2:USB Empeg Mark I/II Driver   | empeg: v1.2:USB Empeg Mark I/II Driver
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver empeg
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
epic100.c:v1.11 1/7/2001 Written by Donald Becker <becker@scy | epic100: v1.11 1/7/2001 Written by Donald Becker <becker@scyl
eth16i.c: Presently autoprobing (not recommended) for a singl | eth16i: Presently autoprobing (not recommended) for a single
eth16i.c No Eth16i card found (i/o = 0x0).                    | eth16i: No Eth16i card found (i/o = 0x0).
fealnx.c:v2.52 Sep-11-2006                                    | fealnx: v2.52 Sep-11-2006
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for FTDI USB Serial
drivers/usb/serial/ftdi_sio.c: v1.4.3:USB FTDI Serial Convert | ftdi_sio: v1.4.3:USB FTDI Serial Converters Driver
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver FTDI USB Serial D
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for funsoft
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver funsoft
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Garmin GPS usb/
drivers/usb/serial/garmin_gps.c: garmin gps driver v0.31      | garmin_gps: garmin gps driver v0.31
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Garmin GPS usb/tt
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
hamachi.c:v2.1 Sept 11, 2006  Written by Donald Becker        | hamachi: v2.1 Sept 11, 2006  Written by Donald Becker
hp.c: Presently autoprobing (not recommended) for a single ca | hp: Presently autoprobing (not recommended) for a single card
hp.c: No HP card found (i/o = 0x0).                           | hp: No HP card found (i/o = 0x0).
hp-plus.c: Presently autoprobing (not recommended) for a sing | hp-plus: Presently autoprobing (not recommended) for a single
hp-plus.c: No HP-Plus card found (i/o = 0x0).                 | hp-plus: No HP-Plus card found (i/o = 0x0).
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for hp4X
drivers/usb/serial/hp4x.c: HP4x (48/49) Generic Serial driver | hp4x: HP4x (48/49) Generic Serial driver v1.00
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver hp4X
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/misc/idmouse.c: Siemens ID Mouse FingerTIP Sensor | idmouse: Siemens ID Mouse FingerTIP Sensor Driver 0.6
inport.c: Didn't find InPort mouse at 0x23c                   | inport: Didn't find InPort mouse at 0x23c
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Edgeport 2 port
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Edgeport 4 port
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Edgeport 8 port
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for EPiC device
drivers/usb/serial/io_edgeport.c: Edgeport USB Serial Driver  | io_edgeport: Edgeport USB Serial Driver v2.7
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Edgeport 2 port a
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Edgeport 4 port a
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Edgeport 8 port a
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver EPiC device
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Edgeport TI 1 p
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Edgeport TI 2 p
drivers/usb/serial/io_ti.c: Edgeport USB Serial Driver v0.7mo | io_ti: Edgeport USB Serial Driver v0.7mode043006
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Edgeport TI 1 por
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Edgeport TI 2 por
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for PocketPC PDA
drivers/usb/serial/ipaq.c: USB PocketPC PDA driver v0.5       | ipaq: USB PocketPC PDA driver v0.5
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver PocketPC PDA
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc | ipddp: v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for IPWireless conv
drivers/usb/serial/ipw.c: IPWireless tty driver v0.3          | ipw: IPWireless tty driver v0.3
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver IPWireless conver
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for IR Dongle
drivers/usb/serial/ir-usb.c: USB IR Dongle driver v0.4        | ir-usb: USB IR Dongle driver v0.4
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver IR Dongle
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/input/tablet/kbtab.c: v0.0.2:USB KB Gear JamStudio Ta | kbtab: v0.0.2:USB KB Gear JamStudio Tablet driver
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Keyspan - (with
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Keyspan 1 port
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Keyspan 2 port
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Keyspan 4 port
drivers/usb/serial/keyspan.c: v1.1.5:Keyspan USB to Serial Co | keyspan: v1.1.5:Keyspan USB to Serial Converter Driver
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Keyspan - (withou
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Keyspan 1 port ad
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Keyspan 2 port ad
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Keyspan 4 port ad
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Keyspan PDA
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Keyspan PDA - (
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Xircom / Entreg
drivers/usb/serial/keyspan_pda.c: USB Keyspan PDA Converter d | keyspan_pda: USB Keyspan PDA Converter driver v1.1
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Keyspan PDA
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Keyspan PDA - (pr
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Xircom / Entregra
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for KL5KUSB105D / P
drivers/usb/serial/kl5kusb105.c: KLSI KL5KUSB105 chipset USB- | kl5kusb105: KLSI KL5KUSB105 chipset USB->Serial Converter dri
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver KL5KUSB105D / Pal
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for KOBIL USB smart
drivers/usb/serial/kobil_sct.c: 21/05/2004 KOBIL Systems GmbH | kobil_sct: 21/05/2004 KOBIL Systems GmbH - http://www.kobil.c
drivers/usb/serial/kobil_sct.c: KOBIL USB Smart Card Terminal | kobil_sct: KOBIL USB Smart Card Terminal Driver (experimental
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver KOBIL USB smart c
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/media/video/usbvideo/konicawc.c: Konica Webcam driver | konicawc: Konica Webcam driver v1.4
lance.c: Module autoprobing not allowed. Append "io=0xNNN" va | lance: Module autoprobing not allowed. Append "io=0xNNN" valu
lec.c: Jan  2 2008 19:21:42 initialized                       | lec: Jan  2 2008 19:21:42 initialized
drivers/usb/misc/legousbtower.c: LEGO USB Tower Driver v0.96  | legousbtower: LEGO USB Tower Driver v0.96
logibm.c: Didn't find Logitech busmouse at 0x23c              | logibm: Didn't find Logitech busmouse at 0x23c
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for MCT U232
drivers/usb/serial/mct_u232.c: Magic Control Technology USB-R | mct_u232: Magic Control Technology USB-RS232 converter driver
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver MCT U232
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/image/mdc800.c: v0.7.5 (30/10/2000):USB Driver fo | mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digi
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Moschip 2 port
drivers/usb/serial/mos7720.c: Moschip USB Serial Driver 1.0.0 | mos7720: Moschip USB Serial Driver 1.0.0.4F
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Moschip 2 port ad
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Moschip 7840/78
drivers/usb/serial/mos7840.c: Moschip 7840/7820 USB Serial Dr | mos7840: Moschip 7840/7820 USB Serial Driver 1.3.1
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Moschip 7840/7820
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
mpc.c: Jan  2 2008 19:21:38 initialized                       | mpc: Jan  2 2008 19:21:38 initialized
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for navman
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver navman
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
ne.c: You must supply "io=0xNNN" value(s) for ISA cards.      | ne: You must supply "io=0xNNN" value(s) for ISA cards.
ne2k-pci.c:v1.03 9/22/2003 D. Becker/P. Gortmaker             | ne2k-pci: v1.03 9/22/2003 D. Becker/P. Gortmaker
ns83820.c: National Semiconductor DP83820 10/100/1000 driver. | ns83820: National Semiconductor DP83820 10/100/1000 driver.
nsc-ircc, Found chip at base=0x02e                            | nsc-ircc: Found chip at base=0x02e
nsc-ircc, Wrong chip version 0c                               | nsc-ircc: Wrong chip version 0c
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for ZyXEL - omni.ne
drivers/usb/serial/omninet.c: v1.1:USB ZyXEL omni.net LCD PLU | omninet: v1.1:USB ZyXEL omni.net LCD PLUS Driver
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver ZyXEL - omni.net
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for GSM modem (1-po
drivers/usb/serial/option.c: USB Driver for GSM modems: v0.7. | option: USB Driver for GSM modems: v0.7.1
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver GSM modem (1-port
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for oti6858
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver oti6858
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/media/video/ov511.c: v1.64 for Linux 2.5 : ov511 USB  | ov511: v1.64 for Linux 2.5 : ov511 USB Camera Driver
drivers/media/video/ov511.c: driver deregistered              | ov511: driver deregistered
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for pl2303
drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial ad | pl2303: Prolific PL2303 USB to serial adaptor driver
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver pl2303
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
tms380tr.c: v1.10 30/12/2002 by Christoph Goos, Adam Fritzler | tms380tr: v1.10 30/12/2002 by Christoph Goos, Adam Fritzler
proteon.c: 0 cards found.                                     | proteon: 0 cards found.
proteon.c: No cards found.                                    | proteon: No cards found.
drivers/media/video/pvrusb2/pvrusb2-main.c: Hauppauge WinTV-P | pvrusb2-main: Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/
drivers/media/video/pvrusb2/pvrusb2-main.c: Debug mask is 31  | pvrusb2-main: Debug mask is 31 (0x1f)
drivers/media/video/usbvideo/quickcam_messenger.c: Logitech Q | quickcam_messenger: Logitech Quickcam Messenger USB v0.01
drivers/usb/host/r8a66597-hcd.c: driver r8a66597_hcd, 29 May  | r8a66597-hcd: driver r8a66597_hcd, 29 May 2007
drivers/usb/misc/rio500.c: v1.1:USB Rio 500 driver            | rio500: v1.1:USB Rio 500 driver
drivers/net/usb/rtl8150.c: rtl8150 based usb-ethernet driver  | rtl8150: rtl8150 based usb-ethernet driver v0.6.2 (2004/08/27
saa7130/34: v4l2 driver version 0.2.14 loaded                 | saa7130: v4l2 driver version 0.2.14 loaded
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/safe_serial.c: v0.0b sl@lineo.com, tbr@lin | safe_serial: v0.0b sl@lineo.com, tbr@lineo.com
drivers/usb/serial/safe_serial.c: USB Safe Encapsulated Seria | safe_serial: USB Safe Encapsulated Serial
drivers/usb/serial/safe_serial.c: vendor: 0 product: 0 safe:  | safe_serial: vendor: 0 product: 0 safe: 1 padded: 1
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver safe_serial
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/media/video/se401.c: SE401 usb camera driver version  | se401: SE401 usb camera driver version 0.24 registering
drivers/media/video/se401.c: SE401 driver deregistered        | se401: SE401 driver deregistered
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Sierra USB mode
drivers/usb/serial/sierra.c: USB Driver for Sierra Wireless U | sierra: USB Driver for Sierra Wireless USB modems: v.1.2.5b
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Sierra USB modem
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
sis900.c: v1.08.10 Apr. 2 2006                                | sis900: v1.08.10 Apr. 2 2006
tms380tr.c: v1.10 30/12/2002 by Christoph Goos, Adam Fritzler | tms380tr: v1.10 30/12/2002 by Christoph Goos, Adam Fritzler
skisa.c: 0 cards found.                                       | skisa: 0 cards found.
skisa.c: No cards found.                                      | skisa: No cards found.
smc-ultra.c: Presently autoprobing (not recommended) for a si | smc-ultra: Presently autoprobing (not recommended) for a sing
smc-ultra.c: No SMC Ultra card found (i/o = 0x0).             | smc-ultra: No SMC Ultra card found (i/o = 0x0).
smctr.c: v1.4 7/12/00 by jschlst@samba.org                    | smctr: v1.4 7/12/00 by jschlst@samba.org
ALSA sound/isa/ad1848/ad1848.c:74: ad1848.0: please specify p | ALSA ad1848: ad1848.0: please specify port
ALSA sound/isa/adlib.c:40: adlib.0: please specify port       | ALSA adlib: adlib.0: please specify port
ALSA sound/isa/als100.c:360: no ALS100 based soundcards found | ALSA als100: no ALS100 based soundcards found
ALSA sound/isa/azt2320.c:387: no AZT2320 based soundcards fou | ALSA azt2320: no AZT2320 based soundcards found
ALSA sound/isa/cs423x/cs4231.c:78: cs4231.0: please specify p | ALSA cs4231: cs4231.0: please specify port
ALSA sound/isa/dt019x.c:350: no DT-019X / ALS-007 based sound | ALSA dt019x: no DT-019X / ALS-007 based soundcards found
ALSA sound/isa/es1688/es1688_lib.c:113: ess_reset at 0x220: f | ALSA es1688_lib: ess_reset at 0x220: failed!!!
ALSA sound/isa/es1688/es1688_lib.c:113: ess_reset at 0x240: f | ALSA es1688_lib:113: ess_reset at 0x240: failed!!!
ALSA sound/isa/es1688/es1688_lib.c:113: ess_reset at 0x240: f | ALSA es1688_lib: ess_reset at 0x240: failed!!!
ALSA sound/isa/es1688/es1688_lib.c:113: ess_reset at 0x260: f | ALSA es1688_lib: ess_reset at 0x260: failed!!!
ALSA sound/isa/sb/es968.c:258: no ES968 based soundcards foun | ALSA es968: no ES968 based soundcards found
ALSA sound/isa/es1688/es1688_lib.c:113: ess_reset at 0x220: f | ALSA es1688_lib: ess_reset at 0x220: failed!!!
ALSA sound/isa/es1688/es1688_lib.c:113: ess_reset at 0x240: f | ALSA es1688_lib: ess_reset at 0x240: failed!!!
ALSA sound/isa/es1688/es1688_lib.c:113: ess_reset at 0x260: f | ALSA es1688_lib: ess_reset at 0x260: failed!!!
ALSA sound/isa/opti9xx/miro.c:179: aci_busy_wait() time out   | ALSA miro: aci_busy_wait() time out
ALSA sound/isa/opti9xx/miro.c:189: aci busy, aci_write(0xdf)  | ALSA miro: aci busy, aci_write(0xdf) stopped.
ALSA sound/isa/opti9xx/miro.c:1167: can't force aci into know | ALSA miro: can't force aci into known state.
ALSA sound/isa/opti9xx/miro.c:1233: unable to detect aci chip | ALSA miro: unable to detect aci chip
ALSA sound/drivers/mtpav.c:589: MTVAP port 0x378 is busy      | mtpav: MTVAP port 0x378 is busy
ALSA sound/isa/sb/sb8.c:89: sb8.0: please specify irq         | ALSA sb8: sb8.0: please specify irq
ALSA sound/isa/sgalaxy.c:225: sgalaxy: specify SB port        | ALSA sgalaxy: sgalaxy: specify SB port
starfire.c:v1.03 7/26/2000  Written by Donald Becker <becker@ | starfire:v1.03 7/26/2000  Written by Donald Becker <becker@sc
drivers/media/video/stv680.c: [usb_stv680_init:1546] STV(i):  | stv680: [usb_stv680_init:1546] STV(i): usb camera driver vers
drivers/media/video/stv680.c: STV0680 USB Camera Driver v0.25 | stv680: STV0680 USB Camera Driver v0.25
drivers/media/video/stv680.c: [usb_stv680_exit:1555] STV(i):  | stv680: [usb_stv680_exit:1555] STV(i): driver deregistered
sundance.c:v1.2 11-Sep-2006  Written by Donald Becker         | sundance:v1.2 11-Sep-2006  Written by Donald Becker
sym53c416.c: Version 1.0.0-ac                                 | sym53c416: Version 1.0.0-ac
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for TI USB 3410 1 p
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for TI USB 5052 2 p
drivers/usb/serial/ti_usb_3410_5052.c: TI USB 3410/5052 Seria | ti_usb_3410_5052: TI USB 3410/5052 Serial Driver v0.9
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver TI USB 3410 1 por
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver TI USB 5052 2 por
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
tms380tr.c: v1.10 30/12/2002 by Christoph Goos, Adam Fritzler | tms380tr: v1.10 30/12/2002 by Christoph Goos, Adam Fritzler
drivers/usb/misc/trancevibrator.c: v1.1:PlayStation 2 Trance  | trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for debug
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver debug
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver       | hid-core: v2.6:USB HID core driver
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/usb/misc/uss720.c: v0.6:USB Parport Cable driver for  | uss720: v0.6:USB Parport Cable driver for Cables using the Lu
drivers/usb/misc/uss720.c: NOTE: this is a special purpose dr | uss720: NOTE: this is a special purpose driver to allow nonst
drivers/usb/misc/uss720.c: protocols (eg. bitbang) over USS72 | uss720: protocols (eg. bitbang) over USS720 usb to parallel c
drivers/usb/misc/uss720.c: If you just want to connect to a p | uss720: If you just want to connect to a printer, use usblp i
via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker | via-rhine:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Handspring Viso
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Sony Clie 3.5
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Sony Clie 5.0
drivers/usb/serial/visor.c: USB HandSpring Visor / Palm OS dr | visor: USB HandSpring Visor / Palm OS driver
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Handspring Visor
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Sony Clie 3.5
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Sony Clie 5.0
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
w83627hf/thf/hg WDT: Watchdog already running. Resetting time | w83627hf WDT: Watchdog already running. Resetting timeout to
w83627hf/thf/hg WDT: initialized. timeout=60 sec (nowayout=0) | w83627hf WDT: initialized. timeout=60 sec (nowayout=0)
w83697hf/hg WDT: WDT driver for W83697HF/HG initializing      | w83697hf WDT: WDT driver for W83697HF/HG initializing
w83697hf/hg WDT: Looking for watchdog at address 0x2e         | w83697hf WDT: Looking for watchdog at address 0x2e
w83697hf/hg WDT: watchdog not found at address 0x2e           | w83697hf WDT: watchdog not found at address 0x2e
w83697hf/hg WDT: No W83697HF/HG could be found                | w83697hf WDT: No W83697HF/HG could be found
drivers/input/tablet/wacom_sys.c: v1.47:USB Wacom Graphire an | wacom_sys: v1.47:USB Wacom Graphire and Wacom Intuos tablet d
WaveLAN init_module(): doing device probing (bad !)           | WaveLAN init_module: doing device probing (bad !)
WaveLAN init_module(): no device found                        | WaveLAN init_module: no device found
wd.c: Presently autoprobing (not recommended) for a single ca | wd: Presently autoprobing (not recommended) for a single card
wd.c: No wd80x3 card found (i/o = 0x0).                       | wd: No wd80x3 card found (i/o = 0x0).
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core       | usb-serial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registere | usb-serial: USB Serial support registered for Connect Tech -
drivers/usb/serial/whiteheat.c: USB ConnectTech WhiteHEAT dri | whiteheat: USB ConnectTech WhiteHEAT driver v2.0
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver Connect Tech - Wh
drivers/usb/serial/usb-serial.c: USB Serial deregistering dri | usb-serial: USB Serial deregistering driver generic
drivers/input/joystick/xpad.c: X-Box pad driver:v0.0.6        | xpad: X-Box pad driver:v0.0.6
drivers/usb/atm/xusbatm.c: malformed module parameters        | xusbatm: malformed module parameters
drivers/input/misc/yealink.c: Yealink phone driver:yld-200512 | yealink: Yealink phone driver:yld-20051230
yellowfin.c:v1.05  1/09/2001  Written by Donald Becker <becke | yellowfin: v1.05  1/09/2001  Written by Donald Becker <becker
drivers/media/video/zr364xx.c: Zoran 364xx module loaded      | zr364xx: Zoran 364xx module loaded
drivers/media/video/zr364xx.c: Zoran 364xx module unloaded    | zr364xx: Zoran 364xx module unloaded






______________________________________________________________________________
Jetzt neu! Im riesigen WEB.DE Club SmartDrive Dateien freigeben und mit 
Freunden teilen! http://www.freemail.web.de/club/smartdrive_ttc.htm/?mc=021134

