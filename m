Return-Path: <linux-kernel-owner+w=401wt.eu-S1751361AbZITLbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbZITLbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 07:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZITLbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 07:31:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZITLbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 07:31:17 -0400
Date: Sun, 20 Sep 2009 13:37:41 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.31: crash in tty_io.c
Message-ID: <20090920113741.GA6057@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: private site
X-PGP-Key-Id: 0x3FAF957D
User-Agent: Mutt/1.5.20+20090822 (GNU/Linux 2.6.31 x86_64)
X-Provags-ID: V01U2FsdGVkX1/JRATaIdlKWIFM7jEwcQIcSiDOWASD5LLVr9+
 XJ6yjf71Mp5Mv1Ol3yV8ZUW0D0iChHhFdSQM5Qy/nkviDEawt4
 moJjK0YW8xwt3D3+RP7lg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running the latest stable 2.6.31 kernel, I found this in my logs:

Sep 20 13:22:59 liesel kernel: ------------[ cut here ]------------
Sep 20 13:22:59 liesel kernel: WARNING: at drivers/char/tty_io.c:1267 tty_open+0x421/0x4e0()
Sep 20 13:22:59 liesel kernel: Hardware name:  
Sep 20 13:22:59 liesel kernel: Modules linked in: uhci_hcd rt73usb
rt2x00usb snd_hda_codec_realtek rt2x00lib snd_hda_intel led_class
snd_hda_codec ohci1394 i2c_nforce2 input_polldev ieee1394 snd_pcm
usb_storage snd_timer k8temp mac80211 button snd firewire_ohci hwmon
i2c_core forcedeth pcspkr soundcore sr_mod sg cfg80211 cdrom
snd_page_alloc rfkill xts usbhid ohci_hcd sd_mod ehci_hcd rtc_cmos
rtc_core rtc_lib usbcore hmac dm_snapshot dm_crypt dm_mod gf128mul
twofish_x86_64 twofish_common aes_x86_64 aes_generic cbc tgr192 loop ecb
arc4 fuse edd ide_pci_generic amd74xx ide_core fan pata_amd sata_nv libata
scsi_mod thermal processor
Sep 20 13:22:59 liesel kernel: Pid: 1521, comm: blogd Not tainted 2.6.31 #1
Sep 20 13:22:59 liesel kernel: Call Trace:
Sep 20 13:22:59 liesel kernel:  [<ffffffff812e90b1>] ? tty_open+0x421/0x4e0
Sep 20 13:22:59 liesel kernel:  [<ffffffff812e90b1>] ? tty_open+0x421/0x4e0
Sep 20 13:22:59 liesel kernel:  [<ffffffff81044f69>] ? warn_slowpath_common+0x79/0xd0
Sep 20 13:22:59 liesel kernel:  [<ffffffff812e90b1>] ? tty_open+0x421/0x4e0
Sep 20 13:22:59 liesel kernel:  [<ffffffff81281d52>] ? kobject_get+0x12/0x20
Sep 20 13:22:59 liesel kernel:  [<ffffffff810d1fdd>] ? chrdev_open+0x13d/0x230
Sep 20 13:22:59 liesel kernel:  [<ffffffff810d1ea0>] ? chrdev_open+0x0/0x230
Sep 20 13:22:59 liesel kernel:  [<ffffffff810cd111>] ? __dentry_open+0x111/0x340
Sep 20 13:22:59 liesel kernel:  [<ffffffff810dc474>] ? do_filp_open+0x764/0xb10
Sep 20 13:22:59 liesel kernel:  [<ffffffff81049ade>] ? current_fs_time+0x1e/0x30
Sep 20 13:22:59 liesel kernel:  [<ffffffff810dd6df>] ? vfs_ioctl+0x2f/0xa0
Sep 20 13:22:59 liesel kernel:  [<ffffffff810e64d2>] ? alloc_fd+0x122/0x150
Sep 20 13:22:59 liesel kernel:  [<ffffffff810ccf0f>] ? do_sys_open+0x8f/0x140
Sep 20 13:22:59 liesel kernel:  [<ffffffff8100bdab>] ? system_call_fastpath+0x16/0x1b
Sep 20 13:22:59 liesel kernel: ---[ end trace f0db7f8312cd8bff ]---

Please give me a hint if you need more information/logs/config.

