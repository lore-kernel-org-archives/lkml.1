Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYELPK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYELPK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYELPKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:10:17 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:10427 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbYELPKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:10:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lw6qPpMR2wht/HjLe8A2RCbonF0KGDTGrKQq2StjUTnQRVEDsSMssZ2qYCqAXRhpqZMr+u9Kd0EHX+MmEnm3lsLzi1ZG9eHB6kjy1DurHOrC5gZCjHtooa5oisluY44d7fX6Cugzu1lBjTb0EOr2Xnq9TmtyblSUkrtfEUJTLtU=
Message-ID: <2a6e8c0d0805120810n55cbe046x7b4c07c36b5d4e92@mail.gmail.com>
Date: Mon, 12 May 2008 11:10:11 -0400
From: "Ian E. Morgan" <penguin.wrangler@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: sysfs: duplicate filename (usb unusual dev?)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My wife got a silly little keychain digital photo frame for a gift.
I'm trying to make it work, but no such luck:

(This is on vanilla 2.6.25)

May 12 10:19:21 raptor kernel: usb 3-1: new full speed USB device
using uhci_hcd and address 3
May 12 10:19:21 raptor kernel: usb 3-1: config 1 has an invalid
interface number: 1 but max is 0
May 12 10:19:21 raptor kernel: usb 3-1: config 1 has 2 interfaces,
different from the descriptor's value: 1
May 12 10:19:21 raptor kernel: usb 3-1: configuration #1 chosen from 1 choice
May 12 10:19:21 raptor kernel: scsi7 : SCSI emulation for USB Mass
Storage devices
May 12 10:19:21 raptor kernel: hiddev96hidraw1: USB HID v2.01 Device
[BUILDWIN Photo Frame] on usb-0000:00:1d.2-1
May 12 10:19:21 raptor kernel: sysfs: duplicate filename
'usbdev3.3_ep81' can not be created
May 12 10:19:21 raptor kernel: ------------[ cut here ]------------
May 12 10:19:21 raptor kernel: WARNING: at fs/sysfs/dir.c:424
sysfs_add_one+0x80/0xa0()
May 12 10:19:21 raptor kernel: Modules linked in: usb_storage ctr
twofish twofish_common camellia serp
ent blowfish xcbc sha256_generic autofs4 hidp rfcomm l2cap sunrpc
ipt_REJECT nf_conntrack_ipv4 xt_stat
e xt_tcpudp iptable_filter ip_tables x_tables acpi_cpufreq vfat fat
dm_mirror dm_mod nvram usbhid hci_
usb bluetooth sg mousedev evdev nvidia(P) ohci1394 iwl3945
firmware_class mac80211 ieee1394 pcmcia_cor
e snd_hda_intel snd_pcm snd_timer snd tg3 soundcore 8250_pnp 8250
i2c_core intel_agp snd_page_alloc se
rial_core pcspkr iTCO_wdt agpgart ehci_hcd uhci_hcd usbcore [last
unloaded: parport]
May 12 10:19:21 raptor kernel: Pid: 505, comm: khubd Tainted: P
 2.6.25 #3
May 12 10:19:21 raptor kernel:  [<c013b684>] warn_on_slowpath+0x54/0x70
May 12 10:19:21 raptor kernel:  [<c013be8b>] ? wake_up_klogd+0x3b/0x40
May 12 10:19:21 raptor kernel:  [<c013c058>] ? release_console_sem+0x1c8/0x1e0
May 12 10:19:21 raptor kernel:  [<c022dc3c>] ? ida_get_new_above+0x7c/0x170
May 12 10:19:21 raptor kernel:  [<c01aa7be>] ? find_inode+0x3e/0x70
May 12 10:19:21 raptor kernel:  [<c01da970>] ? sysfs_ilookup_test+0x0/0x20
May 12 10:19:21 raptor kernel:  [<c01da970>] ? sysfs_ilookup_test+0x0/0x20
May 12 10:19:21 raptor kernel:  [<c01aa8f5>] ? ifind+0x45/0x90
May 12 10:19:21 raptor kernel:  [<c013c64b>] ? printk+0x1b/0x20
May 12 10:19:21 raptor kernel:  [<c01dad00>] sysfs_add_one+0x80/0xa0
May 12 10:19:21 raptor kernel:  [<c01dbaeb>] sysfs_create_link+0x8b/0x110
May 12 10:19:21 raptor kernel:  [<c02960c0>] device_add+0x240/0x430
May 12 10:19:21 raptor kernel:  [<c02962c2>] device_register+0x12/0x20
May 12 10:19:21 raptor kernel:  [<f89248b6>]
usb_create_ep_files+0x166/0x2e0 [usbcore]
May 12 10:19:21 raptor kernel:  [<f8923cd5>]
usb_create_sysfs_intf_files+0xa5/0xe0 [usbcore]
May 12 10:19:21 raptor kernel:  [<f891f86c>]
usb_set_configuration+0x33c/0x590 [usbcore]
May 12 10:19:21 raptor kernel:  [<f8927e9b>] generic_probe+0x6b/0xa0 [usbcore]
May 12 10:19:21 raptor kernel:  [<f8921483>]
usb_probe_device+0x33/0x40 [usbcore]
May 12 10:19:21 raptor kernel:  [<c0298057>] driver_probe_device+0x87/0x160
May 12 10:19:21 raptor kernel:  [<c0366723>] ? klist_next+0x63/0xb0
May 12 10:19:21 raptor kernel:  [<c0298138>] __device_attach+0x8/0x10
May 12 10:19:21 raptor kernel:  [<c0297307>] bus_for_each_drv+0x47/0x70
May 12 10:19:21 raptor kernel:  [<c02981ea>] device_attach+0x7a/0x80
May 12 10:19:21 raptor kernel:  [<c0298130>] ? __device_attach+0x0/0x10
May 12 10:19:21 raptor kernel:  [<c029728f>] bus_attach_device+0x4f/0x80
May 12 10:19:21 raptor kernel:  [<c02961ab>] device_add+0x32b/0x430
May 12 10:19:21 raptor kernel:  [<f891a276>] usb_new_device+0x56/0xb0 [usbcore]
May 12 10:19:21 raptor kernel:  [<f891b7ff>] hub_thread+0x44f/0xc50 [usbcore]
May 12 10:19:21 raptor kernel:  [<c01347a7>] ? hrtick_set+0xa7/0x110
May 12 10:19:21 raptor kernel:  [<c014ed60>] ? autoremove_wake_function+0x0/0x40
May 12 10:19:21 raptor kernel:  [<f891b3b0>] ? hub_thread+0x0/0xc50 [usbcore]
May 12 10:19:21 raptor kernel:  [<c014ea62>] kthread+0x42/0x70
May 12 10:19:21 raptor kernel:  [<c014ea20>] ? kthread+0x0/0x70
May 12 10:19:21 raptor kernel:  [<c011895b>] kernel_thread_helper+0x7/0x1c
May 12 10:19:21 raptor kernel:  =======================
May 12 10:19:21 raptor kernel: ---[ end trace ab65a9098e25b754 ]---
May 12 10:19:21 raptor kernel: sysfs: duplicate filename
'usbdev3.3_ep01' can not be created
May 12 10:19:21 raptor kernel: ------------[ cut here ]------------
May 12 10:19:21 raptor kernel: WARNING: at fs/sysfs/dir.c:424
sysfs_add_one+0x80/0xa0()
May 12 10:19:21 raptor kernel: Modules linked in: usb_storage ctr
twofish twofish_common camellia serp
ent blowfish xcbc sha256_generic autofs4 hidp rfcomm l2cap sunrpc
ipt_REJECT nf_conntrack_ipv4 xt_stat
e xt_tcpudp iptable_filter ip_tables x_tables acpi_cpufreq vfat fat
dm_mirror dm_mod nvram usbhid hci_
usb bluetooth sg mousedev evdev nvidia(P) ohci1394 iwl3945
firmware_class mac80211 ieee1394 pcmcia_cor
e snd_hda_intel snd_pcm snd_timer snd tg3 soundcore 8250_pnp 8250
i2c_core intel_agp snd_page_alloc se
rial_core pcspkr iTCO_wdt agpgart ehci_hcd uhci_hcd usbcore [last
unloaded: parport]
May 12 10:19:21 raptor kernel: Pid: 505, comm: khubd Tainted: P
 2.6.25 #3
May 12 10:19:21 raptor kernel:  [<c013b684>] warn_on_slowpath+0x54/0x70
May 12 10:19:21 raptor kernel:  [<c013ba00>] ? early_printk+0x0/0x10
May 12 10:19:21 raptor kernel:  [<c013badc>] ? _call_console_drivers+0x4c/0x90
May 12 10:19:21 raptor kernel:  [<c013c058>] ? release_console_sem+0x1c8/0x1e0
May 12 10:19:21 raptor kernel:  [<c022dc3c>] ? ida_get_new_above+0x7c/0x170
May 12 10:19:21 raptor kernel:  [<c01aa7be>] ? find_inode+0x3e/0x70
May 12 10:19:21 raptor kernel:  [<c01da970>] ? sysfs_ilookup_test+0x0/0x20
May 12 10:19:21 raptor kernel:  [<c01da970>] ? sysfs_ilookup_test+0x0/0x20
May 12 10:19:21 raptor kernel:  [<c01aa8f5>] ? ifind+0x45/0x90
May 12 10:19:21 raptor kernel:  [<c013c64b>] ? printk+0x1b/0x20
May 12 10:19:21 raptor kernel:  [<c01dad00>] sysfs_add_one+0x80/0xa0
May 12 10:19:21 raptor kernel:  [<c01dbaeb>] sysfs_create_link+0x8b/0x110
May 12 10:19:21 raptor kernel:  [<c02960c0>] device_add+0x240/0x430
May 12 10:19:21 raptor kernel:  [<c022d8b3>] ? free_layer+0x33/0x40
May 12 10:19:21 raptor kernel:  [<c02962c2>] device_register+0x12/0x20
May 12 10:19:21 raptor kernel:  [<f89248b6>]
usb_create_ep_files+0x166/0x2e0 [usbcore]
May 12 10:19:21 raptor kernel:  [<f8923cd5>]
usb_create_sysfs_intf_files+0xa5/0xe0 [usbcore]
May 12 10:19:21 raptor kernel:  [<f891f86c>]
usb_set_configuration+0x33c/0x590 [usbcore]
May 12 10:19:21 raptor kernel:  [<f8927e9b>] generic_probe+0x6b/0xa0 [usbcore]
May 12 10:19:21 raptor kernel:  [<f8921483>]
usb_probe_device+0x33/0x40 [usbcore]
May 12 10:19:21 raptor kernel:  [<c0298057>] driver_probe_device+0x87/0x160
May 12 10:19:21 raptor kernel:  [<c0366723>] ? klist_next+0x63/0xb0
May 12 10:19:21 raptor kernel:  [<c0298138>] __device_attach+0x8/0x10
May 12 10:19:21 raptor kernel:  [<c0297307>] bus_for_each_drv+0x47/0x70
May 12 10:19:21 raptor kernel:  [<c02981ea>] device_attach+0x7a/0x80
May 12 10:19:21 raptor kernel:  [<c0298130>] ? __device_attach+0x0/0x10
May 12 10:19:21 raptor kernel:  [<c029728f>] bus_attach_device+0x4f/0x80
May 12 10:19:21 raptor kernel:  [<c02961ab>] device_add+0x32b/0x430
May 12 10:19:21 raptor kernel:  [<f891a276>] usb_new_device+0x56/0xb0 [usbcore]
May 12 10:19:21 raptor kernel:  [<f891b7ff>] hub_thread+0x44f/0xc50 [usbcore]
May 12 10:19:21 raptor kernel:  [<c01347a7>] ? hrtick_set+0xa7/0x110
May 12 10:19:21 raptor kernel:  [<c014ed60>] ? autoremove_wake_function+0x0/0x40
May 12 10:19:21 raptor kernel:  [<f891b3b0>] ? hub_thread+0x0/0xc50 [usbcore]
May 12 10:19:21 raptor kernel:  [<c014ea62>] kthread+0x42/0x70
May 12 10:19:21 raptor kernel:  [<c014ea20>] ? kthread+0x0/0x70
May 12 10:19:21 raptor kernel:  [<c011895b>] kernel_thread_helper+0x7/0x1c
May 12 10:19:21 raptor kernel:  =======================
May 12 10:19:21 raptor kernel: ---[ end trace ab65a9098e25b754 ]---
May 12 10:19:26 raptor kernel: usb 3-1: reset full speed USB device
using uhci_hcd and address 3
May 12 10:19:27 raptor last message repeated 3 times

The devise does show up in usb_storage:

# cat /proc/scsi/usb-storage/6
   Host scsi6: usb-storage
       Vendor: BUILDWIN
      Product: Photo Frame
Serial Number: None
     Protocol: Transparent SCSI
    Transport: Bulk
       Quirks:

And lsusb -v reveals:

Bus 004 Device 002: ID 1908:1315
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x1908
  idProduct          0x1315
  bcdDevice            0.00
  iManufacturer           1 BUILDWIN
  iProduct                2 Photo Frame
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           64
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              3 DPF Mate
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

So I don't get the reason for duplicate sysfs nodes, and the scsi
device for mass storage never shows up (no /dev/sdb is registered,
etc)

Does this look like something that would be resolved with a new
unusual-devs.h entry? Can I find out from this info what type of
unusual-devs macro I might need to get this device working?

-- 
Ian Morgan
