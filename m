Return-Path: <linux-kernel-owner+w=401wt.eu-S965841AbXCVH36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965841AbXCVH36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965851AbXCVH36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:29:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:28088 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965841AbXCVH3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qEBN/aJDbzsCervHnClPQkodzoCu+jsKUOw2dfGTHhVcX49iNh5U4WgWAo1hw4WQSqI2P8168kPZPAodk2qMzMXZmCl/A7mdpUxSwg+eUqSOO/RagLuEOxGEYoqODTQfm/fKqePIIWLP3sc4S/AukdT/iO57gY9bbkDpM89It/Y=
Message-ID: <a44ae5cd0703220029lb4df507ne21da177f7c05008@mail.gmail.com>
Date: Thu, 22 Mar 2007 00:29:54 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc4-mm1 + 4 hotfixes -- BUG: unable to handle kernel paging request at virtual address 6b6b6ceb -- EIP is at module_put+0x7/0x1f
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kobject 0000:01:06.0: cleaning up
kobject firmware: cleaning up
BUG: unable to handle kernel paging request at virtual address 6b6b6ceb
 printing eip:
c0137c22
*pde = 00000000
Oops: 0002 [#1]
last sysfs file:
devices/pci0000:00/0000:00:1e.0/0000:01:06.0/firmware/0000:01:06.0/loading
Modules linked in: intel_rng rng_core ac97_bus snd_pcm_oss
snd_mixer_oss mmc_core ipw2200 snd_pcm snd_seq_dummy snd_seq_oss
fw_ohci fw_core yenta_socket rsrc_nonstatic pcmcia_core ieee80211
ieee80211_crypt snd_seq_midi_event snd_seq snd_timer snd_seq_device
iTCO_wdt tifm_7xx1 tifm_core snd psmouse iTCO_vendor_support intel_agp
agpgart rtc soundcore shpchp pci_hotplug evdev snd_page_alloc ext3 jbd
mbcache sg sr_mod cdrom sd_mod pata_acpi ata_piix ohci1394 ieee1394
8139too mii libata scsi_mod ehci_hcd uhci_hcd usbcore thermal
processor fan
CPU:    0
EIP:    0060:[<c0137c22>]    Not tainted VLI
EFLAGS: 00010202   (2.6.21-rc4-mm1 #4)
EIP is at module_put+0x7/0x1f
eax: 6b6b6b6b   ebx: c34bea98   ecx: c01618d2   edx: 00000001
esi: c3580000   edi: c34ba2fc   ebp: c3597f38   esp: c3597f38
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process firmware_helper (pid: 1895, ti=c3596000 task=c35a40b0 task.ti=c3596000)
Stack: c3597f48 c019db66 00000008 c3569548 c3597f70 c0165eee 00000000 00000000
       c39bc5f8 c1c12118 c3569548 c34ba2fc c3590310 00000000 c3597f80 c0166036
       c34ba2fc c34ba2fc c3597f98 c0163ac6 c3590334 00000003 c3590310 c3590334
Call Trace:
 [<c0104c22>] show_trace_log_lvl+0x1a/0x2f
 [<c0104cd2>] show_stack_log_lvl+0x9b/0xaa
 [<c0104e97>] show_registers+0x1b6/0x288
 [<c010505d>] die+0xf4/0x209
 [<c0114b20>] do_page_fault+0x45d/0x529
 [<c028a10c>] error_code+0x74/0x7c
 [<c019db66>] release+0x2a/0x37
 [<c0165eee>] __fput+0xbe/0x168
 [<c0166036>] fput+0x31/0x35
 [<c0163ac6>] filp_close+0x54/0x5c
 [<c0164a97>] sys_close+0x6f/0xa7
 [<c0103c94>] sysenter_past_esp+0x5d/0x99
 =======================
Code: fe ff 8b 86 c4 00 00 00 e8 42 e4 08 00 89 f8 e8 22 e4 08 00 89
f8 e8 d4 e2 08 00 59 89 d8 5b 5b 5e 5f 5d c3 55 85 c0 89 e5 74 16 <ff>
88 80 01 00 00 83 38 02 75 0b 8b 80 08 02 00 00 e8 9c ee fd
EIP: [<c0137c22>] module_put+0x7/0x1f SS:ESP 0068:c3597f38
kobject sdhci: registering. parent: <NULL>, set: module
kobject holders: registering. parent: sdhci, set: <NULL>
kobject_uevent_env
kobject filter function caused the event to drop!
kobject_uevent_env
fill_kobj_path: path = '/module/sdhci'
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
kobject sdhci: registering. parent: <NULL>, set: drivers
kobject_uevent_env
