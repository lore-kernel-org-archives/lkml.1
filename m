Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbZBHRkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbZBHRkb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 12:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZBHRkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 12:40:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:5335 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZBHRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 12:40:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=IjM4EKQl7fhG3s94ddqgjgo6aEKEgiisFw8PUFuBl/UuKUGN9DbNgYmFipRJAuf0HG
         /4fO+DxWfHr02zoJbX6tjDJ4Jy4GyqHsik5NF4v7Jv07P0QT3I8bJw+8iAihMbjRlWIf
         iAs3H7dY8ulyPH933/Th54d2dpMNsn4f/7JQk=
MIME-Version: 1.0
Date: Sun, 8 Feb 2009 18:40:16 +0100
Message-ID: <8db1092f0902080940i390efc72i18046210931606a9@mail.gmail.com>
Subject: WARNING: at drivers/usb/storage/transport.c:584 last_sector_hacks+0x12a/0x190 
	[usb_storage]()
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mdharm-usb@one-eyed-alien.net, USB list <linux-usb@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pendrive 1GB, in 2.6.28 works without any problems (also in XP and Vista)

2.6.29-rc3:

[ 7737.804065] usb 5-4: new high speed USB device using ehci_hcd and address 4
[ 7737.939363] usb 5-4: configuration #1 chosen from 1 choice
[ 7737.939969] scsi7 : SCSI emulation for USB Mass Storage devices
[ 7737.949340] usb-storage: device found at 4
[ 7737.949346] usb-storage: waiting for device to settle before scanning
[ 7742.950197] scsi 7:0:0:0: Direct-Access     pqi
IntelligentStick 0.00 PQ: 0 ANSI: 2
[ 7742.951269] sd 7:0:0:0: [sdb] 2015231 512-byte hardware sectors:
(1.03 GB/983 MiB)
[ 7742.952431] sd 7:0:0:0: [sdb] Write Protect is off
[ 7742.952439] sd 7:0:0:0: [sdb] Mode Sense: 00 00 00 00
[ 7742.952445] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[ 7742.954890] sd 7:0:0:0: [sdb] 2015231 512-byte hardware sectors:
(1.03 GB/983 MiB)
[ 7742.955761] sd 7:0:0:0: [sdb] Write Protect is off
[ 7742.955768] sd 7:0:0:0: [sdb] Mode Sense: 00 00 00 00
[ 7742.955773] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[ 7742.955779]  sdb: sdb1
[ 7743.063563] sd 7:0:0:0: [sdb] Attached SCSI removable disk
[ 7743.063657] sd 7:0:0:0: Attached scsi generic sg2 type 0
[ 7743.063914] usb-storage: device scan complete
[ 7743.201999] ------------[ cut here ]------------
[ 7743.202005] WARNING: at drivers/usb/storage/transport.c:584
last_sector_hacks+0x12a/0x190 [usb_storage]()
[ 7743.202009] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
[ 7743.202012] sdb: Successful last sector success at 2015230, device
3538:0054:0100
[ 7743.202015] Modules linked in: usb_storage iwl3945 mac80211 btusb
i915 drm i2c_algo_bit i2c_core rfcomm l2cap bluetooth vboxnetflt
vboxdrv arc4 ecb rfkill firmware_class led_class lib80211 cfg80211
xt_tcpudp xt_limit xt_state iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables aes_i586
aes_generic cbc dm_crypt dm_snapshot dm_mirror dm_region_hash dm_log
dm_mod fuse sbp2 loop snd_hda_codec_si3054 snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
pcmcia snd_seq snd_timer snd_seq_device psmouse snd b44 ssb ohci1394
ehci_hcd uhci_hcd serio_raw rtc_cmos soundcore pcspkr mii ieee1394
yenta_socket rsrc_nonstatic pcmcia_core fan usbcore rtc_core rtc_lib
snd_page_alloc intel_agp ac button battery agpgart sg evdev [last
unloaded: mac80211]
[ 7743.202102] Pid: 10122, comm: usb-storage Tainted: G        W  2.6.29-rc3 #1
[ 7743.202105] Call Trace:
[ 7743.202117]  [<c012e783>] warn_slowpath+0x73/0xd0
[ 7743.202126]  [<c0394f00>] ? wait_for_common+0x60/0x110
[ 7743.202131]  [<c0128ac0>] ? default_wake_function+0x0/0x10
[ 7743.202135]  [<c0394fed>] ?
wait_for_completion_interruptible_timeout+0xd/0x10
[ 7743.202143]  [<f8dd1f43>] ? usb_stor_msg_common+0xd3/0x120 [usb_storage]
[ 7743.202150]  [<f8dd1e0a>] last_sector_hacks+0x12a/0x190 [usb_storage]
[ 7743.202167]  [<f8dd26b2>] usb_stor_invoke_transport+0x1a2/0x310 [usb_storage]
[ 7743.202171]  [<c012309b>] ? check_preempt_wakeup+0x1bb/0x1d0
[ 7743.202175]  [<c0128a43>] ? try_to_wake_up+0x113/0x190
[ 7743.202179]  [<c0394f96>] ? wait_for_common+0xf6/0x110
[ 7743.202183]  [<c0128ac0>] ? default_wake_function+0x0/0x10
[ 7743.202190]  [<f8dd1b88>]
usb_stor_transparent_scsi_command+0x8/0x10 [usb_storage]
[ 7743.202198]  [<f8dd3d50>] usb_stor_control_thread+0x120/0x1b0 [usb_storage]
[ 7743.202202]  [<c0122848>] ? complete+0x48/0x60
[ 7743.202209]  [<f8dd3c30>] ? usb_stor_control_thread+0x0/0x1b0 [usb_storage]
[ 7743.202214]  [<c0142c5c>] kthread+0x3c/0x70
[ 7743.202217]  [<c0142c20>] ? kthread+0x0/0x70
[ 7743.202221]  [<c0103c0b>] kernel_thread_helper+0x7/0x1c
[ 7743.202224] ---[ end trace 676bbe351870c93d ]---

After this works OK

It isn't clean 2.6.29-rc3; I add virtualbox module, but in another
machine I have the same problem.

Dmesg, lsusb and config:
http://unixy.pl/maciek/download/kernel/2.6.29-rc3/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
