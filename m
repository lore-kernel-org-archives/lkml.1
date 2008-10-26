Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbYJZN2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbYJZN2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 09:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYJZN2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 09:28:21 -0400
Received: from yergi.telenet-ops.be ([195.130.132.36]:36386 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYJZN2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 09:28:13 -0400
Subject: 2.6.27.3: usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd pcscd rqt
 161 rq 3 len 1024 ret -110
From: Frederik Himpe <fhimpe@vub.ac.be>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-mzNX1vn72wjsX8HFBHOi"
Organization: Vrije Universiteit Brussel
Date: Sun, 26 Oct 2008 15:17:18 +0100
Message-Id: <1225030638.7218.9.camel@defected>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0-2mdv2009.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mzNX1vn72wjsX8HFBHOi
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

When trying to get the Broadcom 5800 Smartcard reader in my Dell
Latitude E6400 working with pcscd and the latest svn version of the ccid
driver, I get the error
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd pcscd rqt 161 rq 3 len 1024
ret -110

in my demsg log.

I attached usbmon trace, the output of pcscd -f -d and dmesg and lsusb
-v.

I have succeeded in using this smartcard reader successfully once, but
it seems to fail most of the time with these errors. Even when it
worked, restarting pcscd was enough to trigger the same errors and get
the smartcard reader inaccessible again.

-- 
Frederik Himpe <fhimpe@vub.ac.be>

--=-mzNX1vn72wjsX8HFBHOi
Content-Disposition: attachment; filename="bcm5800-usbmon.txt"
Content-Type: text/plain; name="bcm5800-usbmon.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

ffff8800b8424900 406827483 S Ci:5:002:0 s a1 03 0000 0001 0400 1024 <
ffff8800b8424900 408828955 C Ci:5:002:0 -2 0
ffff8800b657dd80 408829218 S Bo:5:002:2 -115 10 = 65000000 00000000 0000
ffff8800b657dd80 408829947 C Bo:5:002:2 0 10 >
ffff8800b657dd80 408830548 S Bi:5:002:2 -115 10 <
ffff8800b657dd80 410831954 C Bi:5:002:2 -2 0
ffff8800b657dd80 410832029 S Bo:5:002:2 -115 10 = 65000000 00000100 0000
ffff8800b657dd80 410832947 C Bo:5:002:2 0 10 >
ffff8800b657dd80 410833548 S Bi:5:002:2 -115 10 <
ffff8800b657dd80 412834954 C Bi:5:002:2 -2 0
ffff8800b8424000 412835087 S Bo:5:002:2 -115 10 = 65000000 00000200 0000
ffff8800b8424000 412836948 C Bo:5:002:2 0 10 >
ffff8800b8424000 412837546 S Bi:5:002:2 -115 10 <
ffff8800b8424000 412837948 C Bi:5:002:2 0 10 = 81000000 00000241 fb00
ffff8800b8424000 412838958 S Co:5:002:0 s 01 0b 0000 0001 0000 0
ffff8800b8424000 412839948 C Co:5:002:0 -32 0
ffff8800b8424000 412839973 S Co:5:002:0 s 02 01 0000 0082 0000 0
ffff8800b8424000 412840948 C Co:5:002:0 -32 0
ffff8800b8424000 412840971 S Co:5:002:0 s 02 01 0000 0002 0000 0
ffff8800b8424000 412841948 C Co:5:002:0 -32 0
ffff8800b8424000 412841972 S Co:5:002:0 s 02 01 0000 0086 0000 0
ffff8800b8424000 412842948 C Co:5:002:0 -32 0
ffff8800ce452300 414188715 S Ci:5:002:0 s a1 03 0000 0001 0400 1024 <
ffff8800ce452300 416189957 C Ci:5:002:0 -2 0
ffff8800ce4986c0 416190180 S Bo:5:002:2 -115 10 = 65000000 00000000 0000
ffff8800ce4986c0 416190950 C Bo:5:002:2 0 10 >
ffff8800ce4986c0 416191597 S Bi:5:002:2 -115 10 <
ffff8800ce4986c0 418192955 C Bi:5:002:2 -2 0
ffff8800b1594540 418193083 S Bo:5:002:2 -115 10 = 65000000 00000100 0000
ffff8800b1594540 418193949 C Bo:5:002:2 0 10 >
ffff8800b1594540 418194553 S Bi:5:002:2 -115 10 <
ffff8800b1594540 420195956 C Bi:5:002:2 -2 0
ffff8800b00f5900 420196087 S Bo:5:002:2 -115 10 = 65000000 00000200 0000
ffff8800b00f5900 420196949 C Bo:5:002:2 0 10 >
ffff8800b00f5900 420197552 S Bi:5:002:2 -115 10 <
ffff8800b00f5900 420197948 C Bi:5:002:2 0 10 = 81000000 00000241 fb00
ffff8800b00f5900 420198959 S Co:5:002:0 s 01 0b 0000 0001 0000 0
ffff8800b00f5900 420199950 C Co:5:002:0 -32 0
ffff8800b00f5900 420199975 S Co:5:002:0 s 02 01 0000 0082 0000 0
ffff8800b00f5900 420200949 C Co:5:002:0 -32 0
ffff8800b00f5900 420200973 S Co:5:002:0 s 02 01 0000 0002 0000 0
ffff8800b00f5900 420201949 C Co:5:002:0 -32 0
ffff8800b00f5900 420201972 S Co:5:002:0 s 02 01 0000 0086 0000 0
ffff8800b00f5900 420202949 C Co:5:002:0 -32 0

--=-mzNX1vn72wjsX8HFBHOi
Content-Disposition: attachment; filename="pcscd-debug.txt"
Content-Type: text/plain; name="pcscd-debug.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

# pcscd -f -d
00000000 pcscdaemon.c:280:main() pcscd set to foreground with debug send to stderr
00000020 debuglog.c:239:DebugLogSetLevel() debug level=debug
00000338 pcscdaemon.c:498:main() pcsc-lite 1.4.102 daemon ready.
00126004 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x413C, PID: 0x8156
00000761 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x413C, PID: 0x8156
00000729 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x413C, PID: 0x8156
00000739 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x413C, PID: 0x8156
00013881 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0002
00000941 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0001
00000940 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0001
00000966 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0001
00001846 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0002
00000930 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x0A5C, PID: 0x5800
00000042 hotplug_libhal.c:342:HPAddDevice() Adding USB device: usb_device_a5c_5800_0123456789ABCD_if1
01000659 readerfactory.c:1082:RFInitializeReader() Attempting startup of Broadcom 5880 00 00 using /usr/lib64/pcsc/drivers//ifd-ccid.bundle/Contents/Linux/libccid.so
00000247 readerfactory.c:949:RFBindFunctions() Loading IFD Handler 3.0
00000055 ifdhandler.c:1352:init_driver() Driver version: 1.3.8
00000285 ifdhandler.c:1365:init_driver() LogLevel: 0x0003
00000232 ifdhandler.c:1385:init_driver() DriverOptions: 0x0000
00000033 ifdhandler.c:81:IFDHCreateChannelByName() lun: 0, device: usb:0a5c/5800:libhal:/org/freedesktop/Hal/devices/usb_device_a5c_5800_0123456789ABCD_if1
00228867 ccid_usb.c:236:OpenUSBByName() Manufacturer: Ludovic Rousseau (ludovic.rousseau@free.fr)
00000247 ccid_usb.c:246:OpenUSBByName() ProductString: Generic CCID driver
00000229 ccid_usb.c:252:OpenUSBByName() Copyright: This driver is protected by terms of the GNU Lesser General Public License version 2.1, or (at your option) any later version.
00084827 ccid_usb.c:408:OpenUSBByName() Found Vendor/Product: 0A5C/5800 (Broadcom 5880)
00000074 ccid_usb.c:410:OpenUSBByName() Using USB bus/device: 005/002
02000817 ccid_usb.c:780:get_data_rates() IFD does not support GET_DATA_RATES request: Connection timed out
02003888 ccid_usb.c:526:ReadUSB() usb_bulk_read(005/002): Resource temporarily unavailable
02002999 ccid_usb.c:526:ReadUSB() usb_bulk_read(005/002): Resource temporarily unavailable
00001970 commands.c:945:CmdGetSlotStatus Hardware error
00000031 ifdhandler.c:119:IFDHCreateChannelByName() failed
00004982 readerfactory.c:1121:RFInitializeReader() Open Port 200000 Failed (usb:0a5c/5800:libhal:/org/freedesktop/Hal/devices/usb_device_a5c_5800_0123456789ABCD_if1)
00000031 readerfactory.c:994:RFUnloadReader() Unloading reader driver.
00000060 readerfactory.c:249:RFAddReader() Broadcom 5880 init failed.
00000032 hotplug_libhal.c:395:HPAddDevice() Failed adding USB device: usb_device_a5c_5800_0123456789ABCD_if1
00000844 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x0A5C, PID: 0x5800
00000035 hotplug_libhal.c:342:HPAddDevice() Adding USB device: usb_device_a5c_5800_0123456789ABCD_if0
01000669 readerfactory.c:1082:RFInitializeReader() Attempting startup of Broadcom 5880 00 00 using /usr/lib64/pcsc/drivers//ifd-ccid.bundle/Contents/Linux/libccid.so
00000175 readerfactory.c:949:RFBindFunctions() Loading IFD Handler 3.0
00000025 ifdhandler.c:1352:init_driver() Driver version: 1.3.8
00000240 ifdhandler.c:1365:init_driver() LogLevel: 0x0003
00000205 ifdhandler.c:1385:init_driver() DriverOptions: 0x0000
00000007 ifdhandler.c:81:IFDHCreateChannelByName() lun: 0, device: usb:0a5c/5800:libhal:/org/freedesktop/Hal/devices/usb_device_a5c_5800_0123456789ABCD_if0
00235171 ccid_usb.c:236:OpenUSBByName() Manufacturer: Ludovic Rousseau (ludovic.rousseau@free.fr)
00000266 ccid_usb.c:246:OpenUSBByName() ProductString: Generic CCID driver
00000230 ccid_usb.c:252:OpenUSBByName() Copyright: This driver is protected by terms of the GNU Lesser General Public License version 2.1, or (at your option) any later version.
00078135 ccid_usb.c:408:OpenUSBByName() Found Vendor/Product: 0A5C/5800 (Broadcom 5880)
00000042 ccid_usb.c:410:OpenUSBByName() Using USB bus/device: 005/002
02000923 ccid_usb.c:780:get_data_rates() IFD does not support GET_DATA_RATES request: Connection timed out
02002933 ccid_usb.c:526:ReadUSB() usb_bulk_read(005/002): Resource temporarily unavailable
02002995 ccid_usb.c:526:ReadUSB() usb_bulk_read(005/002): Resource temporarily unavailable
00001971 commands.c:945:CmdGetSlotStatus Hardware error
00000031 ifdhandler.c:119:IFDHCreateChannelByName() failed
00004979 readerfactory.c:1121:RFInitializeReader() Open Port 200000 Failed (usb:0a5c/5800:libhal:/org/freedesktop/Hal/devices/usb_device_a5c_5800_0123456789ABCD_if0)
00000032 readerfactory.c:994:RFUnloadReader() Unloading reader driver.
00000061 readerfactory.c:249:RFAddReader() Broadcom 5880 init failed.
00000032 hotplug_libhal.c:395:HPAddDevice() Failed adding USB device: usb_device_a5c_5800_0123456789ABCD_if0
00001033 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0001
00001041 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0001
00003169 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x0A5C, PID: 0x4500
00000677 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x413C, PID: 0x8158
00000860 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x413C, PID: 0x8157
00001068 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0001
^C51374917 pcscdaemon.c:563:signal_trap() Preparing for suicide
01000062 readerfactory.c:1348:RFCleanupReaders() entering cleaning function
00000080 pcscdaemon.c:523:at_exit() cleaning /var/run/pcscd
[root@defected frederik]# pcscd -f -d
00000000 pcscdaemon.c:280:main() pcscd set to foreground with debug send to stderr
00000020 debuglog.c:239:DebugLogSetLevel() debug level=debug
00000347 pcscdaemon.c:498:main() pcsc-lite 1.4.102 daemon ready.
00165111 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x413C, PID: 0x8156
00000785 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x413C, PID: 0x8156
00000734 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x413C, PID: 0x8156
00000753 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x413C, PID: 0x8156
00036189 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0002
00004089 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0001
00001033 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0001
00000974 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0001
00001906 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0002
00000975 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x0A5C, PID: 0x5800
00000033 hotplug_libhal.c:342:HPAddDevice() Adding USB device: usb_device_a5c_5800_0123456789ABCD_if1
01000486 readerfactory.c:1082:RFInitializeReader() Attempting startup of Broadcom 5880 00 00 using /usr/lib64/pcsc/drivers//ifd-ccid.bundle/Contents/Linux/libccid.so
00000197 readerfactory.c:949:RFBindFunctions() Loading IFD Handler 3.0
00000024 ifdhandler.c:1352:init_driver() Driver version: 1.3.8
00000243 ifdhandler.c:1365:init_driver() LogLevel: 0x0003
00000204 ifdhandler.c:1385:init_driver() DriverOptions: 0x0000
00000007 ifdhandler.c:81:IFDHCreateChannelByName() lun: 0, device: usb:0a5c/5800:libhal:/org/freedesktop/Hal/devices/usb_device_a5c_5800_0123456789ABCD_if1
00254393 ccid_usb.c:236:OpenUSBByName() Manufacturer: Ludovic Rousseau (ludovic.rousseau@free.fr)
00000279 ccid_usb.c:246:OpenUSBByName() ProductString: Generic CCID driver
00000229 ccid_usb.c:252:OpenUSBByName() Copyright: This driver is protected by terms of the GNU Lesser General Public License version 2.1, or (at your option) any later version.
00113982 ccid_usb.c:408:OpenUSBByName() Found Vendor/Product: 0A5C/5800 (Broadcom 5880)
00000066 ccid_usb.c:410:OpenUSBByName() Using USB bus/device: 005/002
02001678 ccid_usb.c:780:get_data_rates() IFD does not support GET_DATA_RATES request: Connection timed out
02002880 ccid_usb.c:526:ReadUSB() usb_bulk_read(005/002): Resource temporarily unavailable
02002998 ccid_usb.c:526:ReadUSB() usb_bulk_read(005/002): Resource temporarily unavailable
00002973 commands.c:945:CmdGetSlotStatus Hardware error
00000030 ifdhandler.c:119:IFDHCreateChannelByName() failed
00004981 readerfactory.c:1121:RFInitializeReader() Open Port 200000 Failed (usb:0a5c/5800:libhal:/org/freedesktop/Hal/devices/usb_device_a5c_5800_0123456789ABCD_if1)
00000030 readerfactory.c:994:RFUnloadReader() Unloading reader driver.
00000058 readerfactory.c:249:RFAddReader() Broadcom 5880 init failed.
00000031 hotplug_libhal.c:395:HPAddDevice() Failed adding USB device: usb_device_a5c_5800_0123456789ABCD_if1
00000844 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x0A5C, PID: 0x5800
00000035 hotplug_libhal.c:342:HPAddDevice() Adding USB device: usb_device_a5c_5800_0123456789ABCD_if0
01000659 readerfactory.c:1082:RFInitializeReader() Attempting startup of Broadcom 5880 00 00 using /usr/lib64/pcsc/drivers//ifd-ccid.bundle/Contents/Linux/libccid.so
00000224 readerfactory.c:949:RFBindFunctions() Loading IFD Handler 3.0
00000054 ifdhandler.c:1352:init_driver() Driver version: 1.3.8
00000271 ifdhandler.c:1365:init_driver() LogLevel: 0x0003
00000232 ifdhandler.c:1385:init_driver() DriverOptions: 0x0000
00000033 ifdhandler.c:81:IFDHCreateChannelByName() lun: 0, device: usb:0a5c/5800:libhal:/org/freedesktop/Hal/devices/usb_device_a5c_5800_0123456789ABCD_if0
00228444 ccid_usb.c:236:OpenUSBByName() Manufacturer: Ludovic Rousseau (ludovic.rousseau@free.fr)
00000283 ccid_usb.c:246:OpenUSBByName() ProductString: Generic CCID driver
00000230 ccid_usb.c:252:OpenUSBByName() Copyright: This driver is protected by terms of the GNU Lesser General Public License version 2.1, or (at your option) any later version.
00114181 ccid_usb.c:408:OpenUSBByName() Found Vendor/Product: 0A5C/5800 (Broadcom 5880)
00000082 ccid_usb.c:410:OpenUSBByName() Using USB bus/device: 005/002
02001405 ccid_usb.c:780:get_data_rates() IFD does not support GET_DATA_RATES request: Connection timed out
02002920 ccid_usb.c:526:ReadUSB() usb_bulk_read(005/002): Resource temporarily unavailable
02003004 ccid_usb.c:526:ReadUSB() usb_bulk_read(005/002): Resource temporarily unavailable
00001971 commands.c:945:CmdGetSlotStatus Hardware error
00000031 ifdhandler.c:119:IFDHCreateChannelByName() failed
00004978 readerfactory.c:1121:RFInitializeReader() Open Port 200000 Failed (usb:0a5c/5800:libhal:/org/freedesktop/Hal/devices/usb_device_a5c_5800_0123456789ABCD_if0)
00000032 readerfactory.c:994:RFUnloadReader() Unloading reader driver.
00000061 readerfactory.c:249:RFAddReader() Broadcom 5880 init failed.
00000032 hotplug_libhal.c:395:HPAddDevice() Failed adding USB device: usb_device_a5c_5800_0123456789ABCD_if0
00001042 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0001
00001052 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0001
00002827 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x0A5C, PID: 0x4500
00000658 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x413C, PID: 0x8158
00000856 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x413C, PID: 0x8157
00001058 hotplug_libhal.c:305:get_driver() Looking a driver for VID: 0x1D6B, PID: 0x0001
^C10871136 pcscdaemon.c:563:signal_trap() Preparing for suicide
01000043 readerfactory.c:1348:RFCleanupReaders() entering cleaning function
00000086 pcscdaemon.c:523:at_exit() cleaning /var/run/pcscd

--=-mzNX1vn72wjsX8HFBHOi
Content-Disposition: attachment; filename="dmesg.txt"
Content-Type: text/plain; name="dmesg.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Linux version 2.6.27.3-1mdv (mandrake@celeste.mandriva.com) (gcc version 4.3.2 (GCC) ) #1 Wed Oct 22 21:53:22 EDT 2008
Command line: BOOT_IMAGE=2.6.27.3-1 root=/dev/Linux/root splash=silent intel_iommu=off vga=788
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dd04d400 (usable)
 BIOS-e820: 00000000dd04d400 - 00000000dd04f400 (ACPI NVS)
 BIOS-e820: 00000000dd04f400 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffe60000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
last_pfn = 0x120000 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xdd04d max_arch_pfn = 0x3ffffffff
init_memory_mapping
 0000000000 - 00dd000000 page 2M
 00dd000000 - 00dd04d000 page 4k
kernel direct mapping tables up to dd04d000 @ 8000-e000
last_map_addr: dd04d000 end: dd04d000
init_memory_mapping
 0100000000 - 0120000000 page 2M
kernel direct mapping tables up to 120000000 @ c000-12000
last_map_addr: 120000000 end: 120000000
RAMDISK: 37b64000 - 37fef9c0
DMI 2.4 present.
ACPI: RSDP 000FB990, 0024 (r2 DELL  )
ACPI: XSDT DD051E00, 006C (r1 DELL    M09     27D80901 ASL        61)
ACPI: FACP DD051C9C, 00F4 (r4 DELL    M09     27D80901 ASL        61)
ACPI: DSDT DD052400, 6977 (r2 INT430 SYSFexxx     1001 INTL 20050624)
ACPI: FACS DD060C00, 0040
ACPI: HPET DD051F00, 0038 (r1 DELL    M09            1 ASL        61)
ACPI: DMAR DD060400, 00F8 (r1 DELL    M09     27D80901 ASL        61)
ACPI: APIC DD052000, 0068 (r1 DELL    M09     27D80901 ASL        47)
ACPI: ASF! DD051C00, 006A (r32 DELL    M09     27D80901 ASL        61)
ACPI: MCFG DD051FC0, 003E (r16 DELL    M09     27D80901 ASL        61)
ACPI: SLIC DD05209C, 0176 (r1 DELL    M09     27D80901 ASL        61)
ACPI: TCPA DD052300, 0032 (r1                        0 ASL         0)
ACPI: SSDT DD05032D, 066C (r1  PmRef    CpuPm     3000 INTL 20050624)
(7 early reservations) ==> bootmem [0000000000 - 0120000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 000070b598]    TEXT DATA BSS ==> [0000200000 - 000070b598]
  #3 [0037b64000 - 0037fef9c0]          RAMDISK ==> [0037b64000 - 0037fef9c0]
  #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
  #6 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
 [ffffe20000000000-ffffe20003ffffff] PMD -> [ffff880028200000-ffff88002c1fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00120000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000dd04d
    0: 0x00100000 -> 0x00120000
On node 0 totalpages: 1036268
  DMA zone: 2547 pages, LIFO batch:0
  DMA32 zone: 886917 pages, LIFO batch:31
  Normal zone: 129280 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
WARNING: NR_CPUS limit of 1 reached. Processor ignored.
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
PM: Registered nosave memory: 00000000dd04d000 - 00000000dd04e000
PM: Registered nosave memory: 00000000dd04e000 - 00000000dd04f000
PM: Registered nosave memory: 00000000dd04f000 - 00000000dd050000
PM: Registered nosave memory: 00000000dd050000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000
PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000
PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000
PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
PM: Registered nosave memory: 00000000fee10000 - 00000000ffe60000
PM: Registered nosave memory: 00000000ffe60000 - 0000000100000000
Allocating PCI resources starting at e2000000 (gap: e0000000:18000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1018744
Kernel command line: BOOT_IMAGE=2.6.27.3-1 root=/dev/Linux/root splash=silent intel_iommu=off vga=788
Intel-IOMMU: disabled
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PMTIMER calibration value
Detected 2260.978 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x20000000 - 0x24000000
Memory: 3996444k/4718592k available (2748k kernel code, 147644k reserved, 1460k data, 396k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 4521.95 BogoMIPS (lpj=2260978)
Security Framework initialized
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 3072K
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
CPU: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz stepping 06
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Using local APIC timer interrupts.
APIC timer calibration result 16624849
Detected 16.624 MHz APIC timer.
net_namespace: 1536 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: MCFG area at f8000000 reserved in E820
PCI: Using MMCONFIG at f8000000 - fbffffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: DMI System Vendor: Dell Inc.
ACPI: DMI Product Name: Latitude E6400                  
ACPI: DMI Product Version: 
ACPI: DMI Board Name: 0RX493
ACPI: DMI BIOS Vendor: Dell Inc.
ACPI: DMI BIOS Date: 09/01/2008
ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:02.0 reg 10 64bit mmio: [f6c00000, f6ffffff]
PCI: 0000:00:02.0 reg 18 32bit mmio: [e0000000, efffffff]
PCI: 0000:00:02.0 reg 20 io port: [ef98, ef9f]
PCI: 0000:00:02.1 reg 10 64bit mmio: [f6b00000, f6bfffff]
PCI: 0000:00:19.0 reg 10 32bit mmio: [f6ae0000, f6afffff]
PCI: 0000:00:19.0 reg 14 32bit mmio: [f6adb000, f6adbfff]
PCI: 0000:00:19.0 reg 18 io port: [efe0, efff]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
PCI: 0000:00:1a.0 reg 20 io port: [6f60, 6f7f]
PCI: 0000:00:1a.1 reg 20 io port: [6f80, 6f9f]
PCI: 0000:00:1a.2 reg 20 io port: [6fa0, 6fbf]
PCI: 0000:00:1a.7 reg 10 32bit mmio: [fed1c400, fed1c7ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
PCI: 0000:00:1b.0 reg 10 64bit mmio: [f6adc000, f6adffff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [6f00, 6f1f]
PCI: 0000:00:1d.1 reg 20 io port: [6f20, 6f3f]
PCI: 0000:00:1d.2 reg 20 io port: [6f40, 6f5f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [fed1c000, fed1c3ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
PCI: 0000:00:1f.2 reg 10 io port: [6e70, 6e77]
PCI: 0000:00:1f.2 reg 14 io port: [6e78, 6e7b]
PCI: 0000:00:1f.2 reg 18 io port: [6e80, 6e87]
PCI: 0000:00:1f.2 reg 1c io port: [6e88, 6e8b]
PCI: 0000:00:1f.2 reg 20 io port: [6ea0, 6ebf]
PCI: 0000:00:1f.2 reg 24 32bit mmio: [fed1c800, fed1cfff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
PCI: 0000:00:1f.3 reg 10 64bit mmio: [f6adaf00, f6adafff]
PCI: 0000:00:1f.3 reg 20 io port: [1100, 111f]
PCI: 0000:0c:00.0 reg 10 64bit mmio: [f69fe000, f69fffff]
pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0c:00.0: PME# disabled
PCI: bridge 0000:00:1c.1 32bit mmio: [f6900000, f69fffff]
PCI: 0000:03:01.0 reg 10 32bit mmio: [0, fff]
pci 0000:03:01.0: supports D1
pci 0000:03:01.0: supports D2
pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:01.0: PME# disabled
PCI: 0000:03:01.1 reg 10 32bit mmio: [f68ff800, f68fffff]
pci 0000:03:01.1: supports D1
pci 0000:03:01.1: supports D2
pci 0000:03:01.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:01.1: PME# disabled
PCI: 0000:03:01.2 reg 10 32bit mmio: [f68ff700, f68ff7ff]
pci 0000:03:01.2: supports D1
pci 0000:03:01.2: supports D2
pci 0000:03:01.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:01.2: PME# disabled
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 32bit mmio: [f6800000, f68fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *3
ACPI: PCI Interrupt Link [LNKC] (IRQs 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
system 00:05: ioport range 0xc80-0xcaf has been reserved
system 00:05: ioport range 0xcc0-0xcff could not be reserved
system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
system 00:0a: ioport range 0xcb0-0xcbb has been reserved
system 00:0a: iomem range 0xfed40000-0xfed44fff could not be reserved
system 00:0b: ioport range 0x900-0x92f has been reserved
system 00:0b: ioport range 0x931-0x933 has been reserved
system 00:0b: ioport range 0x935-0x97f has been reserved
system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
system 00:0b: ioport range 0x1000-0x1005 has been reserved
system 00:0b: ioport range 0x1008-0x100f has been reserved
system 00:0c: ioport range 0xf400-0xf4fe has been reserved
system 00:0c: ioport range 0x1006-0x1007 has been reserved
system 00:0c: ioport range 0x100a-0x1059 could not be reserved
system 00:0c: ioport range 0x1060-0x107f has been reserved
system 00:0c: ioport range 0x1080-0x10bf has been reserved
system 00:0c: ioport range 0x1100-0x111f has been reserved
system 00:0c: ioport range 0x1010-0x102f has been reserved
system 00:0c: ioport range 0x809-0x809 has been reserved
system 00:0d: iomem range 0x0-0x9efff could not be reserved
system 00:0d: iomem range 0x9f000-0x9ffff could not be reserved
system 00:0d: iomem range 0xc0000-0xcffff has been reserved
system 00:0d: iomem range 0xe0000-0xfffff has been reserved
system 00:0d: iomem range 0x100000-0xdd04d3ff could not be reserved
system 00:0d: iomem range 0xdd04d400-0xddafffff could not be reserved
system 00:0d: iomem range 0xddb00000-0xddbfffff could not be reserved
system 00:0d: iomem range 0xffe00000-0xffffffff could not be reserved
system 00:0d: iomem range 0xffa00000-0xffbfffff has been reserved
system 00:0d: iomem range 0xfec00000-0xfec0ffff could not be reserved
system 00:0d: iomem range 0xfee00000-0xfee0ffff could not be reserved
system 00:0d: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:0d: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:0d: iomem range 0xfeda0000-0xfeda3fff could not be reserved
system 00:0d: iomem range 0xfeda4000-0xfeda4fff could not be reserved
system 00:0d: iomem range 0xfeda5000-0xfeda5fff could not be reserved
system 00:0d: iomem range 0xfeda6000-0xfeda6fff has been reserved
system 00:0d: iomem range 0xfed1c800-0xfed1cfff has been reserved
system 00:0d: iomem range 0xfed18000-0xfed1bfff could not be reserved
system 00:0d: iomem range 0xf8000000-0xfbffffff could not be reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0xf6900000-0xf69fffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:0d
pci 0000:00:1c.2:   IO window: disabled
pci 0000:00:1c.2:   MEM window: disabled
pci 0000:00:1c.2:   PREFETCH window: disabled
pci 0000:03:01.0: CardBus bridge, secondary bus 0000:04
pci 0000:03:01.0:   IO window: 0x002000-0x0020ff
pci 0000:03:01.0:   IO window: 0x002400-0x0024ff
pci 0000:03:01.0:   PREFETCH window: 0xf0000000-0xf3ffffff
pci 0000:03:01.0:   MEM window: 0x120000000-0x123ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
pci 0000:00:1e.0:   MEM window: 0xf6800000-0xf68fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000f0000000-0x000000f3ffffff
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:03:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 0b index 0 mmio: [0, 0]
bus: 0b index 1 mmio: [0, 0]
bus: 0b index 2 mmio: [0, 0]
bus: 0b index 3 mmio: [0, 0]
bus: 0c index 0 mmio: [0, 0]
bus: 0c index 1 mmio: [f6900000, f69fffff]
bus: 0c index 2 mmio: [0, 0]
bus: 0c index 3 mmio: [0, 0]
bus: 0d index 0 mmio: [0, 0]
bus: 0d index 1 mmio: [0, 0]
bus: 0d index 2 mmio: [0, 0]
bus: 0d index 3 mmio: [0, 0]
bus: 03 index 0 io port: [2000, 2fff]
bus: 03 index 1 mmio: [f6800000, f68fffff]
bus: 03 index 2 mmio: [f0000000, f3ffffff]
bus: 03 index 3 io port: [0, ffff]
bus: 03 index 4 mmio: [0, ffffffffffffffff]
bus: 04 index 0 io port: [2000, 20ff]
bus: 04 index 1 io port: [2400, 24ff]
bus: 04 index 2 mmio: [f0000000, f3ffffff]
bus: 04 index 3 mmio: [120000000, 123ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Switched to high resolution mode on CPU 0
Freeing initrd memory: 4654k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1225032143.641:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7816
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pci_express 0000:00:1c.2:pcie03: allocate port service
vesafb: framebuffer at 0xe0000000, mapped to 0xffffc20004100000, using 1875k, total 32704k
vesafb: mode is 800x600x16, linelength=1600, pages=33
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel Mobile Intel? GM45 Express Chipset
agpgart-intel 0000:00:00.0: detected 32252K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
input: Macintosh mouse button emulation as /class/input/input0
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Warning: Keylock active.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
registered taskstats version 1
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Freeing unused kernel memory: 396k freed
input: AT Translated Set 2 keyboard as /class/input/input1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27.3-1mdv ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
input: PS/2 Generic Mouse as /class/input/input2
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27.3-1mdv ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f60
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27.3-1mdv uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f80
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27.3-1mdv uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 22, io base 0x00006fa0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
hub 3-1:1.0: USB hub found
hub 3-1:1.0: 3 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27.3-1mdv uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f00
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.27.3-1mdv uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f20
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 3-1: New USB device found, idVendor=0a5c, idProduct=4500
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: BCM2046B1
usb 3-1: Manufacturer: Broadcom
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.27.3-1mdv uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
usb 5-1: new full speed USB device using uhci_hcd and address 2
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.27.3-1mdv uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
No dock devices found.
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c900 irq 284
ata2: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1c980 irq 284
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1cb00 irq 284
ata6: SATA max UDMA/133 abar m2048@0xfed1c800 port 0xfed1cb80 irq 284
usb 5-1: configuration #0 chosen from 1 choice
usb 5-1: config 0 descriptor??
usb 5-1: New USB device found, idVendor=0a5c, idProduct=5800
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 5-1: Product: 5880
usb 5-1: Manufacturer: Broadcom Corp
usb 5-1: SerialNumber: 0123456789ABCD
usb 3-1.1: new full speed USB device using uhci_hcd and address 3
usb 3-1.1: configuration #1 chosen from 1 choice
usb 3-1.1: New USB device found, idVendor=413c, idProduct=8157
usb 3-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 3-1.2: new full speed USB device using uhci_hcd and address 4
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
usb 3-1.2: configuration #1 chosen from 1 choice
usb 3-1.2: New USB device found, idVendor=413c, idProduct=8158
usb 3-1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
ata1.00: ATA-8: ST9160411ASG, DE13, max UDMA/133
ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: PLDS DVD+/-RW DU-8A2S, 4D12, max UDMA/100
ata2.00: configured for UDMA/100
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST9160411ASG     DE13 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            PLDS     DVD+-RW DU-8A2S  4D12 PQ: 0 ANSI: 5
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Filesystem "dm-0": Disabling barriers, trial barrier write failed
XFS mounting filesystem dm-0
Ending clean XFS mount for filesystem: dm-0
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/6x writer dvd-ram cd/rw xa/form2 cdda pop-up
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
ACPI: SSDT DD050999, 0281 (r1  PmRef   BspIst     3000 INTL 20050624)
ACPI: SSDT DD050DF1, 05C6 (r1  PmRef   BspCst     3001 INTL 20050624)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
Marking TSC unstable due to TSC halts in idle
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
e1000e 0000:00:19.0: setting latency timer to 64
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:21:70:ac:b0:8a
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 5, PHY: 8, PBA No: 1004ff-0ff
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, hpet irqs
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM] (41 C)
ACPI: AC Adapter [AC] (on-line)
Yenta: CardBus bridge found at 0000:03:01.0 [1028:0233]
ACPI: EC: non-query interrupt received, switching to interrupt mode
Yenta: ISA IRQ mask 0x0cb8, PCI irq 19
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#03) from #04 to #07
pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
pcmcia: parent PCI bridge Memory window: 0xf6800000 - 0xf68fffff
pcmcia: parent PCI bridge Memory window: 0xf0000000 - 0xf3ffffff
ohci1394 0000:03:01.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[f68ff800-f68fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ACPI: Battery Slot [BAT0] (battery present)
ACPI: Battery Slot [BAT1] (battery absent)
input: Lid Switch as /class/input/input3
ACPI: Lid Switch [LID]
input: Power Button (CM) as /class/input/input4
acpi device:37: registered as cooling_device1
input: Video Bus as /class/input/input5
ACPI: Power Button (CM) [PBTN]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SBTN]
ACPI: WMI: Mapper loaded
sdhci-pci 0000:03:01.2: SDHCI controller found [1180:0822] (rev 21)
sdhci-pci 0000:03:01.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
mmc0: SDHCI controller on PCI [0000:03:01.2] using DMA
acpi device:3e: registered as cooling_device2
input: Video Bus as /class/input/input7
ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
input: Video Bus as /class/input/input8
ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
usbcore: registered new interface driver hiddev
input: HID 413c:8157 as /class/input/input9
input,hidraw0: USB HID v1.11 Keyboard [HID 413c:8157] on usb-0000:00:1a.0-1.1
input: HID 413c:8158 as /class/input/input10
input,hidraw1: USB HID v1.11 Mouse [HID 413c:8158] on usb-0000:00:1a.0-1.2
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
iwlagn: Copyright(c) 2003-2008 Intel Corporation
iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:0c:00.0: setting latency timer to 64
iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=0x24
iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:0c:00.0: PCI INT A disabled
phy0: Selected rate control algorithm 'iwl-agn-rs'
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
HDA Intel 0000:00:1b.0: setting latency timer to 64
i8k: unable to get SMM BIOS version
Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)
Non-volatile memory driver v1.2
loop: module loaded
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[464fc0001aa6f870]
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Filesystem "dm-1": Disabling barriers, trial barrier write failed
XFS mounting filesystem dm-1
Ending clean XFS mount for filesystem: dm-1
FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
fuse init (API version 7.9)
Adding 2047992k swap on /dev/mapper/Linux-swap.  Priority:-1 extents:1 across:2047992k
vboxdrv: Trying to deactivate the NMI watchdog permanently...
vboxdrv: Successfully done.
vboxdrv: Found 1 processor cores.
vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
vboxdrv: Successfully loaded version 2.0.2_OSE (interface 0x00090000).
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
usb 3-1.2: usbfs: process 3611 (hid2hci) did not claim interface 0 before use
virbr0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
virbr0: starting userspace STP failed, starting kernel STP
usb 3-1.3: new full speed USB device using uhci_hcd and address 5
usb 3-1.3: configuration #1 chosen from 1 choice
usb 3-1.3: New USB device found, idVendor=413c, idProduct=8156
usb 3-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1.3: Product: Dell Wireless 370 Bluetooth Mini-card
usb 3-1.3: Manufacturer: Dell Computer Corp
ip_tables: (C) 2000-2006 Netfilter Core Team
Bluetooth: Generic Bluetooth USB driver ver 0.3
usbcore: registered new interface driver btusb
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ADDRCONF(NETDEV_UP): eth0: link is not ready
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:0c:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
firmware: requesting iwlwifi-5000-1.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
NET: Registered protocol family 17
Clocksource tsc unstable (delta = -255968219 ns)
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
set status page addr 0x02220000
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd pcscd rqt 161 rq 3 len 1024 ret -110
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd pcscd rqt 161 rq 3 len 1024 ret -110
virbr0: no IPv6 routers present
wlan0: authenticate with AP 00:15:f2:0a:ab:43
wlan0: authenticate with AP 00:15:f2:0a:ab:43
wlan0: authenticate with AP 00:15:f2:0a:ab:43
wlan0: authenticated
wlan0: associate with AP 00:15:f2:0a:ab:43
wlan0: RX AssocResp from 00:15:f2:0a:ab:43 (capab=0x431 status=0 aid=3)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd pcscd rqt 161 rq 3 len 1024 ret -110
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd pcscd rqt 161 rq 3 len 1024 ret -110
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd pcscd rqt 161 rq 3 len 1024 ret -110
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd pcscd rqt 161 rq 3 len 1024 ret -110
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd pcscd rqt 161 rq 3 len 1024 ret -110
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd pcscd rqt 161 rq 3 len 1024 ret -110
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd pcscd rqt 161 rq 3 len 1024 ret -110
usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd pcscd rqt 161 rq 3 len 1024 ret -110

--=-mzNX1vn72wjsX8HFBHOi
Content-Disposition: attachment; filename="lsusb.txt"
Content-Type: text/plain; name="lsusb.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit


Bus 002 Device 001: ID 1d6b:0002  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b 
  idProduct          0x0002 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.27.3-1mdv ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:1d.7
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 008 Device 001: ID 1d6b:0001  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b 
  idProduct          0x0001 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.27.3-1mdv uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 007 Device 001: ID 1d6b:0001  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b 
  idProduct          0x0001 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.27.3-1mdv uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 006 Device 001: ID 1d6b:0001  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b 
  idProduct          0x0001 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.27.3-1mdv uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 001 Device 001: ID 1d6b:0002  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b 
  idProduct          0x0002 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.27.3-1mdv ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:1a.7
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 005 Device 002: ID 0a5c:5800 Broadcom Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0a5c Broadcom Corp.
  idProduct          0x5800 
  bcdDevice            1.01
  iManufacturer           1 Broadcom Corp
  iProduct                2 5880
  iSerial                 3 0123456789ABCD
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          139
    bNumInterfaces          2
    bConfigurationValue     0
    iConfiguration          0 
    bmAttributes         0xc0
      Self Powered
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       254 Application Specific Interface
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              4 Broadcom USH
      ** UNRECOGNIZED:  10 25 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass        11 Chip/SmartCard
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              5 Contacted SmartCard
      ChipCard Interface Descriptor:
        bLength                54
        bDescriptorType        33
        bcdCCID              1.00
        nMaxSlotIndex           0
        bVoltageSupport         7  5.0V 3.0V 1.8V 
        dwProtocols             3  T=0 T=1
        dwDefaultClock       4000
        dwMaxiumumClock      4000
        bNumClockSupported      0
        dwDataRate           9600 bps
        dwMaxDataRate      250000 bps
        bNumDataRatesSupp.      0
        dwMaxIFSD             247
        dwSyncProtocols  00000000 
        dwMechanical     00000000 
        dwFeatures       000102BA
          Auto configuration based on ATR
          Auto voltage selection
          Auto clock change
          Auto baud rate change
          Auto PPS made by CCID
          NAD value other than 0x00 accpeted
          TPDU level exchange
        dwMaxCCIDMsgLen       271
        bClassGetResponse      00
        bClassEnvelope         00
        wlcdLayout           none
        bPINSupport             0 
        bMaxCCIDBusySlots       1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
Device Status:     0x0000
  (Bus Powered)

Bus 005 Device 001: ID 1d6b:0001  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b 
  idProduct          0x0001 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.27.3-1mdv uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1a.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 004 Device 001: ID 1d6b:0001  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b 
  idProduct          0x0001 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.27.3-1mdv uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1a.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 003 Device 005: ID 413c:8156 Dell Computer Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth
  bMaxPacketSize0        64
  idVendor           0x413c Dell Computer Corp.
  idProduct          0x8156 
  bcdDevice            4.56
  iManufacturer           1 Dell Computer Corp
  iProduct                2 Dell Wireless 370 Bluetooth Mini-card
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          216
    bNumInterfaces          4
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass       254 Application Specific Interface
      bInterfaceSubClass      1 Device Firmware Update
      bInterfaceProtocol      0 
      iInterface              0 
      ** UNRECOGNIZED:  07 21 07 88 13 40 00
Device Status:     0x0001
  Self Powered

Bus 003 Device 004: ID 413c:8158 Dell Computer Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x413c Dell Computer Corp.
  idProduct          0x8158 
  bcdDevice            1.00
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           62
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                2mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     113
          Report Descriptor: (length is 113)
            Item(Global): Usage Page, data= [ 0x01 ] 1
                            Generic Desktop Controls
            Item(Local ): Usage, data= [ 0x02 ] 2
                            Mouse
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Report ID, data= [ 0x02 ] 2
            Item(Local ): Usage, data= [ 0x01 ] 1
                            Pointer
            Item(Main  ): Collection, data= [ 0x00 ] 0
                            Physical
            Item(Global): Usage Page, data= [ 0x09 ] 9
                            Buttons
            Item(Local ): Usage Minimum, data= [ 0x01 ] 1
                            Button 1 (Primary)
            Item(Local ): Usage Maximum, data= [ 0x03 ] 3
                            Button 3 (Tertiary)
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0x01 ] 1
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Global): Report Count, data= [ 0x03 ] 3
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x01 ] 1
            Item(Global): Report Size, data= [ 0x05 ] 5
            Item(Main  ): Input, data= [ 0x01 ] 1
                            Constant Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Usage Page, data= [ 0x01 ] 1
                            Generic Desktop Controls
            Item(Local ): Usage, data= [ 0x30 ] 48
                            Direction-X
            Item(Local ): Usage, data= [ 0x31 ] 49
                            Direction-Y
            Item(Global): Logical Minimum, data= [ 0x81 ] 129
            Item(Global): Logical Maximum, data= [ 0x7f ] 127
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Global): Report Count, data= [ 0x02 ] 2
            Item(Main  ): Input, data= [ 0x06 ] 6
                            Data Variable Relative No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
            Item(Main  ): End Collection, data=none
            Item(Global): Usage Page, data= [ 0x0c ] 12
                            Consumer
            Item(Local ): Usage, data= [ 0x01 ] 1
                            Consumer Control
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Report ID, data= [ 0x7f ] 127
            Item(Global): Usage Page, data= [ 0x00 0xff ] 65280
                            (null)
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Global): Report Count, data= [ 0x03 ] 3
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0xff 0x00 ] 255
            Item(Local ): Usage Minimum, data= [ 0x40 0xfc ] 64576
                            (null)
            Item(Local ): Usage Maximum, data= [ 0x42 0xfc ] 64578
                            (null)
            Item(Main  ): Feature, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x7e ] 126
            Item(Global): Report Count, data= [ 0x1b ] 27
            Item(Local ): Usage Minimum, data= [ 0x44 0xfc ] 64580
                            (null)
            Item(Local ): Usage Maximum, data= [ 0x5e 0xfc ] 64606
                            (null)
            Item(Main  ): Feature, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report ID, data= [ 0x7d ] 125
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Global): Report Count, data= [ 0x0a ] 10
            Item(Global): Logical Maximum, data= [ 0x01 ] 1
            Item(Local ): Usage Minimum, data= [ 0x5f 0xfc ] 64607
                            (null)
            Item(Local ): Usage Maximum, data= [ 0x68 0xfc ] 64616
                            (null)
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x06 ] 6
            Item(Main  ): Input, data= [ 0x01 ] 1
                            Constant Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              10
        ** UNRECOGNIZED:  1c ff 42 49 53 54 00 01 03 08 05 00 00 00 00 00 01 09 f4 01 02 0a f4 01 03 0b f4 01
Device Status:     0x0001
  Self Powered

Bus 003 Device 003: ID 413c:8157 Dell Computer Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x413c Dell Computer Corp.
  idProduct          0x8157 
  bcdDevice            1.00
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                2mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      56
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0001
  Self Powered

Bus 003 Device 002: ID 0a5c:4500 Broadcom Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0         8
  idVendor           0x0a5c Broadcom Corp.
  idProduct          0x4500 
  bcdDevice            1.00
  iManufacturer           1 Broadcom
  iProduct                2 BCM2046B1
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower               94mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             3
  wHubCharacteristic 0x0004
    Ganged power switching
    Compound device
    Ganged overcurrent protection
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent    100 milli Ampere
  DeviceRemovable    0x0e
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0103 power enable connect
   Port 3: 0000.0103 power enable connect
Device Status:     0x0001
  Self Powered

Bus 003 Device 001: ID 1d6b:0001  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b 
  idProduct          0x0001 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.27.3-1mdv uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1a.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

--=-mzNX1vn72wjsX8HFBHOi--

