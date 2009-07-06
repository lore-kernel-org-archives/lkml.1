Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbZGFJvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbZGFJvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 05:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZGFJvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 05:51:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:54581 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752644AbZGFJvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:51:39 -0400
X-Authenticated: #1512929
X-Provags-ID: V01U2FsdGVkX1+WczFt3H2W+wNIYhFsHvJy/xifluhkCz6egvsod0
	LE6lCEQ6kK5UXo
Message-ID: <4A51C929.5010909@warlich.name>
Date: Mon, 06 Jul 2009 11:51:37 +0200
From: Christof Warlich <christof@warlich.name>
Organization: Warlich Consulting
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name> <4A495C2D.1040706@gmail.com> <4A49A49C.10104@warlich.name> <4A4C42E2.6030305@gmail.com>
In-Reply-To: <4A4C42E2.6030305@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060109030703060106070603"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060109030703060106070603
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Robert Hancock schrieb:
> There should definitely be some libata messages from the 
> suspend/resume process, they might not end up in that file though. You 
> might want to try changing the console loglevel before suspend so that 
> all kernel messages get displayed..

Ok, I got the suspend / resume process logged quite complete now, it 
took me some time though to save the data due to the inaccessibility of 
the root filesystem after resume. But  (a modified version of) netcat 
finally was my friend :-).

So below you'll find all messages from "kern.*" between the point when 
calling "s2ram -f -p" up to the point when the system is back. The 
requested libata messages are included. Please let me know if any 
additional data would help.

OT: The timestamps are strange: They are right for the first four lines, 
but then get a negative offset by two hours. This is probably because I 
am two hours away from Greenwich and the system fails to get this right 
after resume. But anyhow, this is not the (main ) problem here.

Thanks for your advice so far,

Christof

Jul  6 11:15:26 fossie kernel: [  313.200646] PM: Syncing filesystems 
... done.
Jul  6 11:15:26 fossie kernel: [  313.200646] PM: Syncing filesystems 
... done.
Jul  6 11:15:26 fossie kernel: [  313.205721] PM: Preparing system for 
mem sleep
Jul  6 11:15:26 fossie kernel: [  313.205721] PM: Preparing system for 
mem sleep
Jul  6 09:15:40 fossie acpid: client 2495[0:0] has disconnected
Jul  6 09:15:40 fossie acpid: execl(): No such file or directory
Jul  6 09:15:40 fossie kernel: [  313.211764] Freezing user space 
processes ... (elapsed 0.01 seconds) done.
Jul  6 09:15:40 fossie kernel: [  313.211764] Freezing user space 
processes ... (elapsed 0.01 seconds) done.
Jul  6 09:15:40 fossie kernel: [  313.229625] Freezing remaining 
freezable tasks ... (elapsed 0.00 seconds) done.
Jul  6 09:15:40 fossie kernel: [  313.229625] Freezing remaining 
freezable tasks ... (elapsed 0.00 seconds) done.
Jul  6 09:15:40 fossie kernel: [  313.229736] PM: Entering mem sleep
Jul  6 09:15:40 fossie kernel: [  313.229736] PM: Entering mem sleep
Jul  6 09:15:40 fossie kernel: [  313.229763] Suspending console(s) (use 
no_console_suspend to debug)
Jul  6 09:15:40 fossie kernel: [  313.229763] Suspending console(s) (use 
no_console_suspend to debug)
Jul  6 09:15:40 fossie kernel: [  313.231475] btusb_bulk_complete: hci0 
urb f669dc80 failed to resubmit (1)
Jul  6 09:15:40 fossie kernel: [  313.232465] btusb_bulk_complete: hci0 
urb f669dc00 failed to resubmit (1)
Jul  6 09:15:40 fossie kernel: [  313.233463] btusb_intr_complete: hci0 
urb f669d500 failed to resubmit (1)
Jul  6 09:15:40 fossie kernel: [  313.248237] b44: eth0: powering down PHY
Jul  6 09:15:40 fossie kernel: [  313.248237] b44: eth0: powering down PHY
Jul  6 09:15:40 fossie kernel: [  313.388085] sd 0:0:0:0: [sda] 
Synchronizing SCSI cache
Jul  6 09:15:40 fossie kernel: [  313.388085] sd 0:0:0:0: [sda] 
Synchronizing SCSI cache
Jul  6 09:15:40 fossie kernel: [  313.388358] sd 0:0:0:0: [sda] Stopping 
disk
Jul  6 09:15:40 fossie kernel: [  313.388358] sd 0:0:0:0: [sda] Stopping 
disk
Jul  6 09:15:40 fossie kernel: [  313.788067] serial 00:06: disabled
Jul  6 09:15:40 fossie kernel: [  313.788067] serial 00:06: disabled
Jul  6 09:15:40 fossie avahi-daemon[2535]: Files changed, reloading.
Jul  6 09:15:40 fossie avahi-daemon[2535]: Failed to read 
/etc/avahi/services.
Jul  6 09:15:40 fossie bluetoothd[2453]: Stopping security manager 0
Jul  6 09:15:40 fossie bluetoothd[2453]: HCI dev 0 down
Jul  6 09:15:40 fossie bluetoothd[2453]: Adapter /org/bluez/2453/hci0 
has been disabled
Jul  6 09:15:40 fossie bluetoothd[2453]: HCI dev 0 unregistered
Jul  6 09:15:40 fossie bluetoothd[2453]: Unregister path: 
/org/bluez/2453/hci0
Jul  6 09:15:40 fossie bluetoothd[2453]: Unregistered interface 
org.bluez.NetworkPeer on path /org/bluez/2453/hci0
Jul  6 09:15:40 fossie bluetoothd[2453]: Unregistered interface 
org.bluez.NetworkHub on path /org/bluez/2453/hci0
Jul  6 09:15:40 fossie bluetoothd[2453]: Unregistered interface 
org.bluez.NetworkRouter on path /org/bluez/2453/hci0
Jul  6 09:15:40 fossie nm-system-settings:    SCPlugin-Ifupdown: 
update_system_hostname
Jul  6 09:15:40 fossie dbus-daemon: Unable to reload configuration: 
Failed to open "/etc/dbus-1/system.conf": No such file or directory
Jul  6 09:15:40 fossie NetworkManager: <info>  (eth0): carrier now OFF 
(device state 8)
Jul  6 09:15:40 fossie NetworkManager: <info>  (eth0): device state 
change: 8 -> 2
Jul  6 09:15:40 fossie NetworkManager: <info>  (eth0): deactivating 
device (reason: 40).
Jul  6 09:15:40 fossie kernel: [  313.788150] b44 0000:02:07.0: PCI INT 
A disabled
Jul  6 09:15:40 fossie kernel: [  313.788150] b44 0000:02:07.0: PCI INT 
A disabled
Jul  6 09:15:40 fossie kernel: [  313.912216] ipw2100 0000:02:05.0: PCI 
INT A disabled
Jul  6 09:15:40 fossie kernel: [  313.912216] ipw2100 0000:02:05.0: PCI 
INT A disabled
Jul  6 09:15:40 fossie kernel: [  313.928357] Intel ICH 0000:00:1f.5: 
PCI INT B disabled
Jul  6 09:15:40 fossie kernel: [  313.928357] Intel ICH 0000:00:1f.5: 
PCI INT B disabled
Jul  6 09:15:40 fossie kernel: [  313.928466] ACPI: Cannot set device to 
a higher-powered state than parent
Jul  6 09:15:40 fossie kernel: [  313.928466] ACPI: Cannot set device to 
a higher-powered state than parent
Jul  6 09:15:40 fossie kernel: [  313.928606] ata2: port disabled. ignoring.
Jul  6 09:15:40 fossie kernel: [  313.928606] ata2: port disabled. ignoring.
Jul  6 09:15:40 fossie kernel: [  313.928694] ata_piix 0000:00:1f.1: PCI 
INT A disabled
Jul  6 09:15:40 fossie kernel: [  313.928694] ata_piix 0000:00:1f.1: PCI 
INT A disabled
Jul  6 09:15:40 fossie kernel: [  313.928713] ehci_hcd 0000:00:1d.7: PCI 
INT D disabled
Jul  6 09:15:40 fossie kernel: [  313.928713] ehci_hcd 0000:00:1d.7: PCI 
INT D disabled
Jul  6 09:15:40 fossie bluetoothd[2453]: HCI dev 0 registered
Jul  6 09:15:40 fossie avahi-daemon[2536]: chroot.c: open() failed: No 
such file or directory
Jul  6 09:15:40 fossie avahi-daemon[2535]: Failed to open 
/etc/resolv.conf: Invalid argument
Jul  6 09:15:40 fossie nm-system-settings: <WARN>  
update_system_hostname(): update_system_hostname() - couldn't read 
/etc/hostname (4/Failed to open file '/etc/hostname': No such file or 
directory)
Jul  6 09:15:40 fossie kernel: [  313.928771] ehci_hcd 0000:00:1d.7: 
PME# disabled
Jul  6 09:15:40 fossie kernel: [  313.928771] ehci_hcd 0000:00:1d.7: 
PME# disabled
Jul  6 09:15:40 fossie kernel: [  313.944147] uhci_hcd 0000:00:1d.2: PCI 
INT C disabled
Jul  6 09:15:40 fossie kernel: [  313.944147] uhci_hcd 0000:00:1d.2: PCI 
INT C disabled
Jul  6 09:15:40 fossie kernel: [  313.944189] uhci_hcd 0000:00:1d.1: PCI 
INT B disabled
Jul  6 09:15:40 fossie kernel: [  313.944189] uhci_hcd 0000:00:1d.1: PCI 
INT B disabled
Jul  6 09:15:40 fossie kernel: [  313.944231] uhci_hcd 0000:00:1d.0: PCI 
INT A disabled
Jul  6 09:15:40 fossie kernel: [  313.944231] uhci_hcd 0000:00:1d.0: PCI 
INT A disabled
Jul  6 09:15:40 fossie kernel: [  313.944616] ACPI: Device [FAN2] failed 
to transition to D0
Jul  6 09:15:40 fossie kernel: [  313.944616] ACPI: Device [FAN2] failed 
to transition to D0
Jul  6 09:15:40 fossie kernel: [  313.944925] ACPI: Device [FAN1] failed 
to transition to D0
Jul  6 09:15:40 fossie kernel: [  313.944925] ACPI: Device [FAN1] failed 
to transition to D0
Jul  6 09:15:40 fossie kernel: [  313.945210] ACPI: Device [FAN0] failed 
to transition to D0
Jul  6 09:15:40 fossie kernel: [  313.945210] ACPI: Device [FAN0] failed 
to transition to D0
Jul  6 09:15:40 fossie kernel: [  313.945271] PM: suspend devices took 
0.716 seconds
Jul  6 09:15:40 fossie kernel: [  313.945271] PM: suspend devices took 
0.716 seconds
Jul  6 09:15:40 fossie kernel: [  313.946019] ACPI: Preparing to enter 
system sleep state S3
Jul  6 09:15:40 fossie kernel: [  313.946019] ACPI: Preparing to enter 
system sleep state S3
Jul  6 09:15:40 fossie kernel: [  314.072582] Disabling non-boot CPUs ...
Jul  6 09:15:40 fossie kernel: [  314.072582] Disabling non-boot CPUs ...
Jul  6 09:15:40 fossie kernel: [  314.072688] ------------[ cut here 
]------------
Jul  6 09:15:40 fossie kernel: [  314.072688] ------------[ cut here 
]------------
Jul  6 09:15:40 fossie kernel: [  314.072707] WARNING: at 
/home/kernel-ppa/mainline/build/kernel/smp.c:289 
smp_call_function_single+0xa9/0x100()
Jul  6 09:15:40 fossie kernel: [  314.072707] WARNING: at 
/home/kernel-ppa/mainline/build/kernel/smp.c:289 
smp_call_function_single+0xa9/0x100()
Jul  6 09:15:40 fossie kernel: [  314.072715] Hardware name: HP Tablet 
PC Tx1100
Jul  6 09:15:40 fossie kernel: [  314.072715] Hardware name: HP Tablet 
PC Tx1100
Jul  6 09:15:40 fossie kernel: [  314.072720] Modules linked in: 
michael_mic arc4 ecb lib80211_crypt_tkip aes_i586 aes_generic 
lib80211_crypt_ccmp binfmt_misc ppdev bridge stp bnep lp parport 
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
snd_seq snd_timer snd_seq_device pcmcia ipw2100 snd soundcore libipw 
pcspkr irda lib80211 yenta_socket rsrc_nonstatic pcmcia_core video 
snd_page_alloc iTCO_wdt iTCO_vendor_support output crc_ccitt intel_agp 
agpgart shpchp btusb usbhid b44 ssb mii
Jul  6 09:15:40 fossie kernel: [  314.072720] Modules linked in: 
michael_mic arc4 ecb lib80211_crypt_tkip aes_i586 aes_generic 
lib80211_crypt_ccmp binfmt_misc ppdev bridge stp bnep lp parport 
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
snd_seq snd_timer snd_seq_device pcmcia ipw2100 snd soundcore libipw 
pcspkr irda lib80211 yenta_socket rsrc_nonstatic pcmcia_core video 
snd_page_alloc iTCO_wdt iTCO_vendor_support output crc_ccitt intel_agp 
agpgart shpchp btusb usbhid b44 ssb mii
Jul  6 09:15:40 fossie kernel: [  314.072820] Pid: 3593, comm: s2ram Not 
tainted 2.6.30-020630-generic #020630
Jul  6 09:15:40 fossie kernel: [  314.072820] Pid: 3593, comm: s2ram Not 
tainted 2.6.30-020630-generic #020630
Jul  6 09:15:40 fossie kernel: [  314.072826] Call Trace:
Jul  6 09:15:40 fossie kernel: [  314.072826] Call Trace:
Jul  6 09:15:40 fossie kernel: [  314.072839]  [<c0161709>] ? 
smp_call_function_single+0xa9/0x100
Jul  6 09:15:40 fossie kernel: [  314.072839]  [<c0161709>] ? 
smp_call_function_single+0xa9/0x100
Jul  6 09:15:40 fossie kernel: [  314.072854]  [<c013b7fc>] 
warn_slowpath_common+0x7c/0xa0
Jul  6 09:15:40 fossie kernel: [  314.072854]  [<c013b7fc>] 
warn_slowpath_common+0x7c/0xa0
Jul  6 09:15:40 fossie kernel: [  314.072866]  [<c0161709>] ? 
smp_call_function_single+0xa9/0x100
Jul  6 09:15:40 fossie kernel: [  314.072866]  [<c0161709>] ? 
smp_call_function_single+0xa9/0x100
Jul  6 09:15:40 fossie kernel: [  314.072877]  [<c013b835>] 
warn_slowpath_null+0x15/0x20
Jul  6 09:15:40 fossie kernel: [  314.072877]  [<c013b835>] 
warn_slowpath_null+0x15/0x20
Jul  6 09:15:40 fossie kernel: [  314.072888]  [<c0161709>] 
smp_call_function_single+0xa9/0x100
Jul  6 09:15:40 fossie kernel: [  314.072888]  [<c0161709>] 
smp_call_function_single+0xa9/0x100
Jul  6 09:15:40 fossie kernel: [  314.072901]  [<c0111b90>] ? 
do_drv_read+0x0/0x70
Jul  6 09:15:40 fossie kernel: [  314.072901]  [<c0111b90>] ? 
do_drv_read+0x0/0x70
Jul  6 09:15:40 fossie kernel: [  314.072912]  [<c0111a00>] 
drv_read+0x30/0x40
Jul  6 09:15:40 fossie kernel: [  314.072912]  [<c0111a00>] 
drv_read+0x30/0x40
Jul  6 09:15:40 fossie kernel: [  314.072923]  [<c0111a88>] 
get_cur_val+0x78/0xa0
Jul  6 09:15:40 fossie kernel: [  314.072923]  [<c0111a88>] 
get_cur_val+0x78/0xa0
Jul  6 09:15:40 fossie kernel: [  314.072934]  [<c0111b4a>] 
get_cur_freq_on_cpu+0x4a/0x70
Jul  6 09:15:40 fossie kernel: [  314.072934]  [<c0111b4a>] 
get_cur_freq_on_cpu+0x4a/0x70
Jul  6 09:15:40 fossie kernel: [  314.072947]  [<c04162ad>] 
cpufreq_suspend+0x7d/0x100
Jul  6 09:15:40 fossie kernel: [  314.072947]  [<c04162ad>] 
cpufreq_suspend+0x7d/0x100
Jul  6 09:15:40 fossie kernel: [  314.072960]  [<c015be3c>] ? 
clockevents_notify+0x1c/0x70
Jul  6 09:15:40 fossie kernel: [  314.072960]  [<c015be3c>] ? 
clockevents_notify+0x1c/0x70
Jul  6 09:15:40 fossie kernel: [  314.072973]  [<c035a4ce>] 
sysdev_suspend+0x8e/0x1f0
Jul  6 09:15:40 fossie kernel: [  314.072973]  [<c035a4ce>] 
sysdev_suspend+0x8e/0x1f0
Jul  6 09:15:40 fossie kernel: [  314.072986]  [<c0174dec>] ? 
stop_machine_destroy+0x3c/0x40
Jul  6 09:15:40 fossie kernel: [  314.072986]  [<c0174dec>] ? 
stop_machine_destroy+0x3c/0x40
Jul  6 09:15:40 fossie kernel: [  314.072997]  [<c0166962>] 
suspend_enter+0xc2/0x120
Jul  6 09:15:40 fossie kernel: [  314.072997]  [<c0166962>] 
suspend_enter+0xc2/0x120
Jul  6 09:15:40 fossie kernel: [  314.073007]  [<c0166b05>] 
suspend_devices_and_enter+0xb5/0xc0
Jul  6 09:15:40 fossie kernel: [  314.073007]  [<c0166b05>] 
suspend_devices_and_enter+0xb5/0xc0
Jul  6 09:15:40 fossie kernel: [  314.073016]  [<c0166d43>] 
enter_state+0xc3/0xe0
Jul  6 09:15:40 fossie kernel: [  314.073016]  [<c0166d43>] 
enter_state+0xc3/0xe0
Jul  6 09:15:40 fossie kernel: [  314.073025]  [<c0166df1>] 
state_store+0x91/0xd0
Jul  6 09:15:40 fossie kernel: [  314.073025]  [<c0166df1>] 
state_store+0x91/0xd0
Jul  6 09:15:40 fossie kernel: [  314.073034]  [<c0166d60>] ? 
state_store+0x0/0xd0
Jul  6 09:15:40 fossie kernel: [  314.073034]  [<c0166d60>] ? 
state_store+0x0/0xd0
Jul  6 09:15:40 fossie kernel: [  314.073046]  [<c02cca34>] 
kobj_attr_store+0x24/0x30
Jul  6 09:15:40 fossie kernel: [  314.073046]  [<c02cca34>] 
kobj_attr_store+0x24/0x30
Jul  6 09:15:40 fossie kernel: [  314.073059]  [<c021358b>] 
flush_write_buffer+0x4b/0x70
Jul  6 09:15:40 fossie kernel: [  314.073059]  [<c021358b>] 
flush_write_buffer+0x4b/0x70
Jul  6 09:15:40 fossie kernel: [  314.073070]  [<c0213672>] 
sysfs_write_file+0x42/0x70
Jul  6 09:15:40 fossie kernel: [  314.073070]  [<c0213672>] 
sysfs_write_file+0x42/0x70
Jul  6 09:15:40 fossie kernel: [  314.073083]  [<c01c7ec6>] 
vfs_write+0x96/0x160
Jul  6 09:15:40 fossie kernel: [  314.073083]  [<c01c7ec6>] 
vfs_write+0x96/0x160
Jul  6 09:15:40 fossie kernel: [  314.073093]  [<c0213630>] ? 
sysfs_write_file+0x0/0x70
Jul  6 09:15:40 fossie kernel: [  314.073093]  [<c0213630>] ? 
sysfs_write_file+0x0/0x70
Jul  6 09:15:40 fossie kernel: [  314.073104]  [<c01c804d>] 
sys_write+0x3d/0x70
Jul  6 09:15:40 fossie kernel: [  314.073104]  [<c01c804d>] 
sys_write+0x3d/0x70
Jul  6 09:15:40 fossie kernel: [  314.073114]  [<c0102ebc>] 
sysenter_do_call+0x12/0x28
Jul  6 09:15:40 fossie kernel: [  314.073114]  [<c0102ebc>] 
sysenter_do_call+0x12/0x28
Jul  6 09:15:40 fossie kernel: [  314.073122] ---[ end trace 
888c80804185d326 ]---
Jul  6 09:15:40 fossie kernel: [  314.073122] ---[ end trace 
888c80804185d326 ]---
Jul  6 09:15:40 fossie kernel: [  314.073122] Back to C!
Jul  6 09:15:40 fossie kernel: [  314.073122] Back to C!
Jul  6 09:15:40 fossie kernel: [  314.073122] ACPI: Waking up from 
system sleep state S3
Jul  6 09:15:40 fossie kernel: [  314.073122] ACPI: Waking up from 
system sleep state S3
Jul  6 09:15:40 fossie kernel: [  314.512314] agpgart-intel 
0000:00:00.0: restoring config space at offset 0x4 (was 0xe0000008, 
writing 0xe2000008)
Jul  6 09:15:40 fossie kernel: [  314.512314] agpgart-intel 
0000:00:00.0: restoring config space at offset 0x4 (was 0xe0000008, 
writing 0xe2000008)
Jul  6 09:15:40 fossie kernel: [  314.512329] agpgart-intel 
0000:00:00.0: restoring config space at offset 0x1 (was 0x20900106, 
writing 0x30900106)
Jul  6 09:15:40 fossie kernel: [  314.512329] agpgart-intel 
0000:00:00.0: restoring config space at offset 0x1 (was 0x20900106, 
writing 0x30900106)
Jul  6 09:15:40 fossie kernel: [  314.512362] pci 0000:00:01.0: 
restoring config space at offset 0x7 (was 0x2a000f0, writing 0x22a000f0)
Jul  6 09:15:40 fossie kernel: [  314.512362] pci 0000:00:01.0: 
restoring config space at offset 0x7 (was 0x2a000f0, writing 0x22a000f0)
Jul  6 09:15:40 fossie kernel: [  314.512405] uhci_hcd 0000:00:1d.0: 
restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
Jul  6 09:15:40 fossie kernel: [  314.512405] uhci_hcd 0000:00:1d.0: 
restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
Jul  6 09:15:40 fossie kernel: [  314.512445] uhci_hcd 0000:00:1d.1: 
restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
Jul  6 09:15:40 fossie kernel: [  314.512445] uhci_hcd 0000:00:1d.1: 
restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
Jul  6 09:15:40 fossie kernel: [  314.512484] uhci_hcd 0000:00:1d.2: 
restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
Jul  6 09:15:40 fossie kernel: [  314.512484] uhci_hcd 0000:00:1d.2: 
restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
Jul  6 09:15:40 fossie kernel: [  314.512536] ehci_hcd 0000:00:1d.7: 
restoring config space at offset 0x1 (was 0x2900006, writing 0x2900102)
Jul  6 09:15:40 fossie kernel: [  314.512536] ehci_hcd 0000:00:1d.7: 
restoring config space at offset 0x1 (was 0x2900006, writing 0x2900102)
Jul  6 09:15:40 fossie bluetoothd[2453]: HCI dev 0 up
Jul  6 09:15:40 fossie acpid: execl(): No such file or directory
Jul  6 09:15:40 fossie bluetoothd[2453]: Starting security manager 0
Jul  6 09:15:40 fossie kernel: [  314.512572] pci 0000:00:1e.0: 
restoring config space at offset 0x9 (was 0xfff0, writing 0x79f07000)
Jul  6 09:15:40 fossie kernel: [  314.512572] pci 0000:00:1e.0: 
restoring config space at offset 0x9 (was 0xfff0, writing 0x79f07000)
Jul  6 09:15:40 fossie kernel: [  314.512584] pci 0000:00:1e.0: 
restoring config space at offset 0x8 (was 0xfff0, writing 0xe050e000)
Jul  6 09:15:40 fossie kernel: [  314.512584] pci 0000:00:1e.0: 
restoring config space at offset 0x8 (was 0xfff0, writing 0xe050e000)
Jul  6 09:15:40 fossie kernel: [  314.512596] pci 0000:00:1e.0: 
restoring config space at offset 0x7 (was 0x228000f0, writing 0x2804030)
Jul  6 09:15:40 fossie kernel: [  314.512596] pci 0000:00:1e.0: 
restoring config space at offset 0x7 (was 0x228000f0, writing 0x2804030)
Jul  6 09:15:40 fossie kernel: [  314.512609] pci 0000:00:1e.0: 
restoring config space at offset 0x6 (was 0x40020200, writing 0x400a0200)
Jul  6 09:15:40 fossie kernel: [  314.512609] pci 0000:00:1e.0: 
restoring config space at offset 0x6 (was 0x40020200, writing 0x400a0200)
Jul  6 09:15:41 fossie kernel: [  314.512627] pci 0000:00:1e.0: 
restoring config space at offset 0x1 (was 0x80800005, writing 0x88800107)
Jul  6 09:15:41 fossie kernel: [  314.512627] pci 0000:00:1e.0: 
restoring config space at offset 0x1 (was 0x80800005, writing 0x88800107)
Jul  6 09:15:41 fossie acpid: execl(): No such file or directory
Jul  6 09:15:41 fossie kernel: [  314.512674] ata_piix 0000:00:1f.1: 
restoring config space at offset 0xf (was 0x100, writing 0x1ff)
Jul  6 09:15:41 fossie kernel: [  314.512674] ata_piix 0000:00:1f.1: 
restoring config space at offset 0xf (was 0x100, writing 0x1ff)
Jul  6 09:15:41 fossie kernel: [  314.512694] ata_piix 0000:00:1f.1: 
restoring config space at offset 0x9 (was 0x0, writing 0x7a000000)
Jul  6 09:15:41 fossie kernel: [  314.512694] ata_piix 0000:00:1f.1: 
restoring config space at offset 0x9 (was 0x0, writing 0x7a000000)
Jul  6 09:15:41 fossie kernel: [  314.512716] ata_piix 0000:00:1f.1: 
restoring config space at offset 0x1 (was 0x2800005, writing 0x2800007)
Jul  6 09:15:41 fossie kernel: [  314.512716] ata_piix 0000:00:1f.1: 
restoring config space at offset 0x1 (was 0x2800005, writing 0x2800007)
Jul  6 09:15:41 fossie kernel: [  314.512768] Intel ICH 0000:00:1f.5: 
restoring config space at offset 0xf (was 0x200, writing 0x20a)
Jul  6 09:15:41 fossie kernel: [  314.512768] Intel ICH 0000:00:1f.5: 
restoring config space at offset 0xf (was 0x200, writing 0x20a)
Jul  6 09:15:41 fossie kernel: [  314.512790] Intel ICH 0000:00:1f.5: 
restoring config space at offset 0x7 (was 0x0, writing 0xd0000800)
Jul  6 09:15:41 fossie kernel: [  314.512790] Intel ICH 0000:00:1f.5: 
restoring config space at offset 0x7 (was 0x0, writing 0xd0000800)
Jul  6 09:15:41 fossie kernel: [  314.512801] Intel ICH 0000:00:1f.5: 
restoring config space at offset 0x6 (was 0x0, writing 0xd0000c00)
Jul  6 09:15:41 fossie kernel: [  314.512801] Intel ICH 0000:00:1f.5: 
restoring config space at offset 0x6 (was 0x0, writing 0xd0000c00)
Jul  6 09:15:41 fossie acpid: execl(): No such file or directory
Jul  6 09:15:41 fossie NetworkManager: <info>  eth0: canceled DHCP 
transaction, dhcp client pid 3020
Jul  6 09:15:41 fossie NetworkManager: <WARN>  
nm_named_manager_remove_ip4_config(): Could not commit DNS changes.  
Error: 'Could not open /etc/resolv.conf.tmp: Read-only file system '
Jul  6 09:15:41 fossie NetworkManager: <WARN>  
nm_named_manager_add_ip4_config(): Could not commit DNS changes.  Error: 
'Could not open /etc/resolv.conf.tmp: Read-only file system '
Jul  6 09:15:41 fossie NetworkManager: <info>  Policy set 'Auto 
FRITZ!Box Fon WLAN 7270' (eth1) as default for routing and DNS.
Jul  6 09:15:41 fossie avahi-daemon[2535]: Withdrawing address record 
for 192.168.0.64 on eth0.
Jul  6 09:15:41 fossie avahi-daemon[2535]: Leaving mDNS multicast group 
on interface eth0.IPv4 with address 192.168.0.64.
Jul  6 09:15:41 fossie avahi-daemon[2535]: Interface eth0.IPv4 no longer 
relevant for mDNS.
Jul  6 09:15:41 fossie NetworkManager: <info>  (eth1): supplicant 
connection state:  completed -> disconnected
Jul  6 09:15:41 fossie NetworkManager: <info>  (eth1): supplicant 
connection state:  disconnected -> associated
Jul  6 09:15:41 fossie kernel: [  314.512813] Intel ICH 0000:00:1f.5: 
restoring config space at offset 0x5 (was 0x1301, writing 0x18c1)
Jul  6 09:15:41 fossie kernel: [  314.512813] Intel ICH 0000:00:1f.5: 
restoring config space at offset 0x5 (was 0x1301, writing 0x18c1)
Jul  6 09:15:41 fossie kernel: [  314.512825] Intel ICH 0000:00:1f.5: 
restoring config space at offset 0x4 (was 0x1201, writing 0x1c01)
Jul  6 09:15:41 fossie kernel: [  314.512825] Intel ICH 0000:00:1f.5: 
restoring config space at offset 0x4 (was 0x1201, writing 0x1c01)
Jul  6 09:15:41 fossie kernel: [  314.512840] Intel ICH 0000:00:1f.5: 
restoring config space at offset 0x1 (was 0x2900005, writing 0x2900003)
Jul  6 09:15:41 fossie kernel: [  314.512840] Intel ICH 0000:00:1f.5: 
restoring config space at offset 0x1 (was 0x2900005, writing 0x2900003)
Jul  6 09:15:41 fossie kernel: [  314.512867] pci 0000:00:1f.6: 
restoring config space at offset 0xf (was 0x200, writing 0x20a)
Jul  6 09:15:41 fossie kernel: [  314.512867] pci 0000:00:1f.6: 
restoring config space at offset 0xf (was 0x200, writing 0x20a)
Jul  6 09:15:41 fossie kernel: [  314.512891] pci 0000:00:1f.6: 
restoring config space at offset 0x5 (was 0x1501, writing 0x2001)
Jul  6 09:15:41 fossie kernel: [  314.512891] pci 0000:00:1f.6: 
restoring config space at offset 0x5 (was 0x1501, writing 0x2001)
Jul  6 09:15:41 fossie kernel: [  314.512902] pci 0000:00:1f.6: 
restoring config space at offset 0x4 (was 0x1401, writing 0x2401)
Jul  6 09:15:41 fossie kernel: [  314.512902] pci 0000:00:1f.6: 
restoring config space at offset 0x4 (was 0x1401, writing 0x2401)
Jul  6 09:15:41 fossie kernel: [  314.512917] pci 0000:00:1f.6: 
restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
Jul  6 09:15:41 fossie kernel: [  314.512917] pci 0000:00:1f.6: 
restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
Jul  6 09:15:41 fossie bluetoothd[2453]: Registered interface 
org.bluez.Service on path /org/bluez/2453/hci0
Jul  6 09:15:41 fossie bluetoothd[2453]: Registered interface 
org.bluez.SerialProxyManager on path /org/bluez/2453/hci0
Jul  6 09:15:41 fossie kernel: [  314.512958] pci 0000:01:00.0: 
restoring config space at offset 0x3 (was 0x0, writing 0x4000)
Jul  6 09:15:41 fossie kernel: [  314.512958] pci 0000:01:00.0: 
restoring config space at offset 0x3 (was 0x0, writing 0x4000)
Jul  6 09:15:41 fossie bluetoothd[2453]: Registered interface 
org.bluez.NetworkPeer on path /org/bluez/2453/hci0
Jul  6 09:15:41 fossie kernel: [  314.512989] ipw2100 0000:02:05.0: 
restoring config space at offset 0xf (was 0x22020100, writing 0x2202010a)
Jul  6 09:15:41 fossie kernel: [  314.512989] ipw2100 0000:02:05.0: 
restoring config space at offset 0xf (was 0x22020100, writing 0x2202010a)
Jul  6 09:15:41 fossie bluetoothd[2453]: Registered interface 
org.bluez.NetworkHub on path /org/bluez/2453/hci0
Jul  6 09:15:41 fossie bluetoothd[2453]: Registered interface 
org.bluez.NetworkRouter on path /org/bluez/2453/hci0
Jul  6 09:15:41 fossie bluetoothd[2453]: rfcomm_bind: Address already in 
use (98)
Jul  6 09:15:41 fossie bluetoothd[2453]: audio-headset: Operation not 
permitted (1)
Jul  6 09:15:41 fossie bluetoothd[2453]: l2cap_bind: Address already in 
use (98)
Jul  6 09:15:41 fossie bluetoothd[2453]: audio-a2dp: Operation not 
permitted (1)
Jul  6 09:15:41 fossie kernel: [  314.513015] ipw2100 0000:02:05.0: 
restoring config space at offset 0x4 (was 0x0, writing 0xe0002000)
Jul  6 09:15:41 fossie kernel: [  314.513015] ipw2100 0000:02:05.0: 
restoring config space at offset 0x4 (was 0x0, writing 0xe0002000)
Jul  6 09:15:41 fossie kernel: [  314.513027] ipw2100 0000:02:05.0: 
restoring config space at offset 0x3 (was 0x0, writing 0x4008)
Jul  6 09:15:41 fossie kernel: [  314.513027] ipw2100 0000:02:05.0: 
restoring config space at offset 0x3 (was 0x0, writing 0x4008)
Jul  6 09:15:41 fossie bluetoothd[2453]: Adapter /org/bluez/2453/hci0 
has been enabled
Jul  6 09:15:41 fossie kernel: [  314.513041] ipw2100 0000:02:05.0: 
restoring config space at offset 0x1 (was 0x2900000, writing 0x2900116)
Jul  6 09:15:41 fossie kernel: [  314.513041] ipw2100 0000:02:05.0: 
restoring config space at offset 0x1 (was 0x2900000, writing 0x2900116)
Jul  6 09:15:41 fossie kernel: [  314.513070] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0xf (was 0x34001ff, 
writing 0x5c001ff)
Jul  6 09:15:41 fossie kernel: [  314.513070] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0xf (was 0x34001ff, 
writing 0x5c001ff)
Jul  6 09:15:41 fossie kernel: [  314.513082] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0xe (was 0x0, writing 0x34fc)
Jul  6 09:15:41 fossie kernel: [  314.513082] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0xe (was 0x0, writing 0x34fc)
Jul  6 09:15:41 fossie kernel: [  314.513094] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0xd (was 0x0, writing 0x3400)
Jul  6 09:15:41 fossie kernel: [  314.513094] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0xd (was 0x0, writing 0x3400)
Jul  6 09:15:41 fossie kernel: [  314.513106] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0xc (was 0x0, writing 0x30fc)
Jul  6 09:15:41 fossie kernel: [  314.513106] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0xc (was 0x0, writing 0x30fc)
Jul  6 09:15:41 fossie kernel: [  314.513118] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0xb (was 0x0, writing 0x3000)
Jul  6 09:15:41 fossie kernel: [  314.513118] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0xb (was 0x0, writing 0x3000)
Jul  6 09:15:41 fossie kernel: [  314.513130] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0xa (was 0x0, writing 
0x7ffff000)
Jul  6 09:15:41 fossie kernel: [  314.513130] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0xa (was 0x0, writing 
0x7ffff000)
Jul  6 09:15:41 fossie kernel: [  314.513142] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x9 (was 0x0, writing 
0x7c000000)
Jul  6 09:15:41 fossie kernel: [  314.513142] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x9 (was 0x0, writing 
0x7c000000)
Jul  6 09:15:41 fossie kernel: [  314.513154] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x8 (was 0x0, writing 
0x73fff000)
Jul  6 09:15:41 fossie kernel: [  314.513154] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x8 (was 0x0, writing 
0x73fff000)
Jul  6 09:15:41 fossie kernel: [  314.513166] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x7 (was 0x0, writing 
0x70000000)
Jul  6 09:15:41 fossie kernel: [  314.513166] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x7 (was 0x0, writing 
0x70000000)
Jul  6 09:15:41 fossie kernel: [  314.513178] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x6 (was 0x0, writing 
0xb0060302)
Jul  6 09:15:41 fossie kernel: [  314.513178] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x6 (was 0x0, writing 
0xb0060302)
Jul  6 09:15:41 fossie kernel: [  314.513192] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x4 (was 0x0, writing 
0xe0003000)
Jul  6 09:15:41 fossie kernel: [  314.513192] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x4 (was 0x0, writing 
0xe0003000)
Jul  6 09:15:41 fossie kernel: [  314.513204] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x3 (was 0x820000, 
writing 0x82a808)
Jul  6 09:15:41 fossie kernel: [  314.513204] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x3 (was 0x820000, 
writing 0x82a808)
Jul  6 09:15:41 fossie kernel: [  314.513218] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x1 (was 0x2100000, 
writing 0x2100007)
Jul  6 09:15:41 fossie kernel: [  314.513218] yenta_cardbus 
0000:02:06.0: restoring config space at offset 0x1 (was 0x2100000, 
writing 0x2100007)
Jul  6 09:15:41 fossie kernel: [  314.513248] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0xf (was 0x34002ff, 
writing 0x5c002ff)
Jul  6 09:15:41 fossie kernel: [  314.513248] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0xf (was 0x34002ff, 
writing 0x5c002ff)
Jul  6 09:15:41 fossie kernel: [  314.513261] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0xe (was 0x0, writing 0x3cfc)
Jul  6 09:15:41 fossie kernel: [  314.513261] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0xe (was 0x0, writing 0x3cfc)
Jul  6 09:15:41 fossie kernel: [  314.513272] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0xd (was 0x0, writing 0x3c00)
Jul  6 09:15:41 fossie kernel: [  314.513272] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0xd (was 0x0, writing 0x3c00)
Jul  6 09:15:41 fossie kernel: [  314.513284] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0xc (was 0x0, writing 0x38fc)
Jul  6 09:15:41 fossie kernel: [  314.513284] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0xc (was 0x0, writing 0x38fc)
Jul  6 09:15:41 fossie kernel: [  314.513296] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0xb (was 0x0, writing 0x3800)
Jul  6 09:15:41 fossie kernel: [  314.513296] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0xb (was 0x0, writing 0x3800)
Jul  6 09:15:41 fossie kernel: [  314.513308] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0xa (was 0x0, writing 
0x83fff000)
Jul  6 09:15:41 fossie kernel: [  314.513308] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0xa (was 0x0, writing 
0x83fff000)
Jul  6 09:15:41 fossie kernel: [  314.513320] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x9 (was 0x0, writing 
0x80000000)
Jul  6 09:15:41 fossie kernel: [  314.513320] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x9 (was 0x0, writing 
0x80000000)
Jul  6 09:15:41 fossie kernel: [  314.513333] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x8 (was 0x0, writing 
0x77fff000)
Jul  6 09:15:41 fossie kernel: [  314.513333] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x8 (was 0x0, writing 
0x77fff000)
Jul  6 09:15:41 fossie kernel: [  314.513345] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x7 (was 0x0, writing 
0x74000000)
Jul  6 09:15:41 fossie kernel: [  314.513345] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x7 (was 0x0, writing 
0x74000000)
Jul  6 09:15:41 fossie kernel: [  314.513357] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x6 (was 0x0, writing 
0xb00a0702)
Jul  6 09:15:41 fossie kernel: [  314.513357] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x6 (was 0x0, writing 
0xb00a0702)
Jul  6 09:15:41 fossie kernel: [  314.513370] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x4 (was 0x0, writing 
0xe0004000)
Jul  6 09:15:41 fossie kernel: [  314.513370] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x4 (was 0x0, writing 
0xe0004000)
Jul  6 09:15:41 fossie kernel: [  314.513383] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x3 (was 0x820000, 
writing 0x82a808)
Jul  6 09:15:41 fossie kernel: [  314.513383] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x3 (was 0x820000, 
writing 0x82a808)
Jul  6 09:15:41 fossie kernel: [  314.513397] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x1 (was 0x2100000, 
writing 0x2100007)
Jul  6 09:15:41 fossie kernel: [  314.513397] yenta_cardbus 
0000:02:06.1: restoring config space at offset 0x1 (was 0x2100000, 
writing 0x2100007)
Jul  6 09:15:41 fossie kernel: [  314.513441] pci 0000:02:06.2: 
restoring config space at offset 0x4 (was 0x1, writing 0x4001)
Jul  6 09:15:41 fossie kernel: [  314.513441] pci 0000:02:06.2: 
restoring config space at offset 0x4 (was 0x1, writing 0x4001)
Jul  6 09:15:41 fossie kernel: [  314.513452] pci 0000:02:06.2: 
restoring config space at offset 0x3 (was 0x0, writing 0x4008)
Jul  6 09:15:41 fossie kernel: [  314.513452] pci 0000:02:06.2: 
restoring config space at offset 0x3 (was 0x0, writing 0x4008)
Jul  6 09:15:41 fossie kernel: [  314.513466] pci 0000:02:06.2: 
restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
Jul  6 09:15:41 fossie kernel: [  314.513466] pci 0000:02:06.2: 
restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
Jul  6 09:15:41 fossie kernel: [  314.513512] b44 0000:02:07.0: 
restoring config space at offset 0x1 (was 0x100106, writing 0x8100106)
Jul  6 09:15:41 fossie kernel: [  314.513512] b44 0000:02:07.0: 
restoring config space at offset 0x1 (was 0x100106, writing 0x8100106)
Jul  6 09:15:41 fossie kernel: [  315.913489] PM: Device LNXPOWER:01 
failed to resume: error -8
Jul  6 09:15:41 fossie kernel: [  315.914002] PM: Device LNXPOWER:02 
failed to resume: error -8
Jul  6 09:15:41 fossie kernel: [  315.923424] agpgart-intel 
0000:00:00.0: restoring config space at offset 0x4 (was 0xe0000008, 
writing 0xe2000008)
Jul  6 09:15:41 fossie kernel: [  315.923424] agpgart-intel 
0000:00:00.0: restoring config space at offset 0x4 (was 0xe0000008, 
writing 0xe2000008)
Jul  6 09:15:41 fossie kernel: [  315.923439] agpgart-intel 
0000:00:00.0: restoring config space at offset 0x1 (was 0x900106, 
writing 0x30900106)
Jul  6 09:15:41 fossie kernel: [  315.923439] agpgart-intel 
0000:00:00.0: restoring config space at offset 0x1 (was 0x900106, 
writing 0x30900106)
Jul  6 09:15:41 fossie kernel: [  315.923510] uhci_hcd 0000:00:1d.0: PCI 
INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
Jul  6 09:15:41 fossie kernel: [  315.923510] uhci_hcd 0000:00:1d.0: PCI 
INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
Jul  6 09:15:41 fossie kernel: [  315.923523] uhci_hcd 0000:00:1d.0: 
setting latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.923523] uhci_hcd 0000:00:1d.0: 
setting latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.923551] usb usb2: root hub lost 
power or was reset
Jul  6 09:15:41 fossie kernel: [  315.923551] usb usb2: root hub lost 
power or was reset
Jul  6 09:15:41 fossie kernel: [  315.923625] uhci_hcd 0000:00:1d.1: PCI 
INT B -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
Jul  6 09:15:41 fossie kernel: [  315.923625] uhci_hcd 0000:00:1d.1: PCI 
INT B -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
Jul  6 09:15:41 fossie kernel: [  315.923637] uhci_hcd 0000:00:1d.1: 
setting latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.923637] uhci_hcd 0000:00:1d.1: 
setting latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.923661] usb usb3: root hub lost 
power or was reset
Jul  6 09:15:41 fossie kernel: [  315.923661] usb usb3: root hub lost 
power or was reset
Jul  6 09:15:41 fossie kernel: [  315.923712] uhci_hcd 0000:00:1d.2: PCI 
INT C -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
Jul  6 09:15:41 fossie kernel: [  315.923712] uhci_hcd 0000:00:1d.2: PCI 
INT C -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
Jul  6 09:15:41 fossie kernel: [  315.923724] uhci_hcd 0000:00:1d.2: 
setting latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.923724] uhci_hcd 0000:00:1d.2: 
setting latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.923748] usb usb4: root hub lost 
power or was reset
Jul  6 09:15:41 fossie kernel: [  315.923748] usb usb4: root hub lost 
power or was reset
Jul  6 09:15:41 fossie kernel: [  315.923828] ehci_hcd 0000:00:1d.7: 
PME# disabled
Jul  6 09:15:41 fossie kernel: [  315.923828] ehci_hcd 0000:00:1d.7: 
PME# disabled
Jul  6 09:15:41 fossie kernel: [  315.923841] ehci_hcd 0000:00:1d.7: PCI 
INT D -> Link[LNKH] -> GSI 10 (level, low) -> IRQ 10
Jul  6 09:15:41 fossie kernel: [  315.923841] ehci_hcd 0000:00:1d.7: PCI 
INT D -> Link[LNKH] -> GSI 10 (level, low) -> IRQ 10
Jul  6 09:15:41 fossie kernel: [  315.923853] ehci_hcd 0000:00:1d.7: 
setting latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.923853] ehci_hcd 0000:00:1d.7: 
setting latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.923866] ehci_hcd 0000:00:1d.7: 
PME# disabled
Jul  6 09:15:41 fossie kernel: [  315.923866] ehci_hcd 0000:00:1d.7: 
PME# disabled
Jul  6 09:15:41 fossie kernel: [  315.923901] pci 0000:00:1e.0: setting 
latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.923901] pci 0000:00:1e.0: setting 
latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.923948] ata_piix 0000:00:1f.1: PCI 
INT A -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
Jul  6 09:15:41 fossie kernel: [  315.923948] ata_piix 0000:00:1f.1: PCI 
INT A -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
Jul  6 09:15:41 fossie kernel: [  315.923959] ata_piix 0000:00:1f.1: 
setting latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.923959] ata_piix 0000:00:1f.1: 
setting latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.924061] ata2: port disabled. ignoring.
Jul  6 09:15:41 fossie kernel: [  315.924061] ata2: port disabled. ignoring.
Jul  6 09:15:41 fossie kernel: [  315.926376] Intel ICH 0000:00:1f.5: 
PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
Jul  6 09:15:41 fossie kernel: [  315.926376] Intel ICH 0000:00:1f.5: 
PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
Jul  6 09:15:41 fossie kernel: [  315.926389] Intel ICH 0000:00:1f.5: 
setting latency timer to 64
Jul  6 09:15:41 fossie kernel: [  315.926389] Intel ICH 0000:00:1f.5: 
setting latency timer to 64
Jul  6 09:15:41 fossie kernel: [  316.648468] ata1.00: ACPI cmd 
ef/03:0c:00:00:00:a0 filtered out
Jul  6 09:15:41 fossie kernel: [  316.648468] ata1.00: ACPI cmd 
ef/03:0c:00:00:00:a0 filtered out
Jul  6 09:15:41 fossie kernel: [  316.648480] ata1.00: ACPI cmd 
ef/03:45:00:00:00:a0 filtered out
Jul  6 09:15:41 fossie kernel: [  316.648480] ata1.00: ACPI cmd 
ef/03:45:00:00:00:a0 filtered out
Jul  6 09:15:41 fossie kernel: [  316.659047] ata1.00: n_sectors 
mismatch 268435456 != 312581808
Jul  6 09:15:41 fossie kernel: [  316.659047] ata1.00: n_sectors 
mismatch 268435456 != 312581808
Jul  6 09:15:41 fossie kernel: [  316.659054] ata1.00: revalidation 
failed (errno=-19)
Jul  6 09:15:41 fossie kernel: [  316.938005] pci 0000:00:1f.6: PME# 
disabled
Jul  6 09:15:41 fossie kernel: [  316.938005] pci 0000:00:1f.6: PME# 
disabled
Jul  6 09:15:41 fossie kernel: [  316.938015] pci 0000:01:00.0: PME# 
disabled
Jul  6 09:15:41 fossie kernel: [  316.938015] pci 0000:01:00.0: PME# 
disabled
Jul  6 09:15:41 fossie kernel: [  316.938032] ipw2100 0000:02:05.0: PCI 
INT A -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
Jul  6 09:15:41 fossie kernel: [  316.938032] ipw2100 0000:02:05.0: PCI 
INT A -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
Jul  6 09:15:41 fossie kernel: [  317.512152] pci 0000:02:06.2: PME# 
disabled
Jul  6 09:15:41 fossie kernel: [  317.512152] pci 0000:02:06.2: PME# 
disabled
Jul  6 09:15:41 fossie kernel: [  317.512171] b44 0000:02:07.0: PCI INT 
A -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
Jul  6 09:15:41 fossie kernel: [  317.512171] b44 0000:02:07.0: PCI INT 
A -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
Jul  6 09:15:41 fossie kernel: [  317.512207] b44 0000:02:07.0: 
restoring config space at offset 0x1 (was 0x100106, writing 0x8100106)
Jul  6 09:15:41 fossie kernel: [  317.512207] b44 0000:02:07.0: 
restoring config space at offset 0x1 (was 0x100106, writing 0x8100106)
Jul  6 09:15:41 fossie kernel: [  317.534808] serial 00:06: activated
Jul  6 09:15:41 fossie kernel: [  317.534808] serial 00:06: activated
Jul  6 09:15:41 fossie kernel: [  318.280292] sd 0:0:0:0: [sda] Starting 
disk
Jul  6 09:15:41 fossie kernel: [  318.280292] sd 0:0:0:0: [sda] Starting 
disk
Jul  6 09:15:41 fossie kernel: [  321.857418] ata1.00: n_sectors 
mismatch 268435456 != 312581808
Jul  6 09:15:41 fossie kernel: [  321.857418] ata1.00: n_sectors 
mismatch 268435456 != 312581808
Jul  6 09:15:41 fossie kernel: [  321.857426] ata1.00: revalidation 
failed (errno=-19)
Jul  6 09:15:41 fossie kernel: [  321.857434] ata1.00: disabled
Jul  6 09:15:41 fossie kernel: [  321.857434] ata1.00: disabled
Jul  6 09:15:41 fossie kernel: [  321.860043] sd 0:0:0:0: rejecting I/O 
to offline device
Jul  6 09:15:41 fossie kernel: [  321.860191] sd 0:0:0:0: [sda] 
START_STOP FAILED
Jul  6 09:15:41 fossie kernel: [  321.860191] sd 0:0:0:0: [sda] 
START_STOP FAILED
Jul  6 09:15:41 fossie kernel: [  321.860197] sd 0:0:0:0: [sda] Result: 
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  6 09:15:41 fossie kernel: [  321.860197] sd 0:0:0:0: [sda] Result: 
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul  6 09:15:41 fossie kernel: [  321.860211] PM: Device 0:0:0:0 failed 
to resume: error 65536
Jul  6 09:15:41 fossie kernel: [  322.035083] ata1.00: ATA-8: WDC 
WD1600BEVE-00WZT0, 01.01A01, max UDMA/100
Jul  6 09:15:41 fossie kernel: [  322.035083] ata1.00: ATA-8: WDC 
WD1600BEVE-00WZT0, 01.01A01, max UDMA/100
Jul  6 09:15:41 fossie kernel: [  322.035093] ata1.00: 312581808 
sectors, multi 0: LBA48
Jul  6 09:15:41 fossie kernel: [  322.035093] ata1.00: 312581808 
sectors, multi 0: LBA48
Jul  6 09:15:41 fossie kernel: [  322.048775] ata1.00: configured for 
UDMA/100
Jul  6 09:15:41 fossie kernel: [  322.048775] ata1.00: configured for 
UDMA/100
Jul  6 09:15:41 fossie kernel: [  322.048801] ata1.00: detaching (SCSI 
0:0:0:0)
Jul  6 09:15:41 fossie kernel: [  322.048801] ata1.00: detaching (SCSI 
0:0:0:0)
Jul  6 09:15:41 fossie kernel: [  322.049377] Aborting journal on device 
sda3.
Jul  6 09:15:41 fossie kernel: [  322.049417] journal commit I/O error
Jul  6 09:15:41 fossie kernel: [  322.112839] sd 0:0:0:0: [sda] 
Synchronizing SCSI cache
Jul  6 09:15:41 fossie kernel: [  322.112839] sd 0:0:0:0: [sda] 
Synchronizing SCSI cache
Jul  6 09:15:41 fossie kernel: [  322.113151] sd 0:0:0:0: [sda] Stopping 
disk
Jul  6 09:15:41 fossie kernel: [  322.113151] sd 0:0:0:0: [sda] Stopping 
disk
Jul  6 09:15:41 fossie kernel: [  322.168091] usb 2-2: reset low speed 
USB device using uhci_hcd and address 2
Jul  6 09:15:41 fossie kernel: [  322.168091] usb 2-2: reset low speed 
USB device using uhci_hcd and address 2
Jul  6 09:15:41 fossie kernel: [  322.492648] scsi 0:0:0:0: 
Direct-Access     ATA      WDC WD1600BEVE-0 01.0 PQ: 0 ANSI: 5
Jul  6 09:15:41 fossie kernel: [  322.492648] scsi 0:0:0:0: 
Direct-Access     ATA      WDC WD1600BEVE-0 01.0 PQ: 0 ANSI: 5
Jul  6 09:15:41 fossie kernel: [  322.493044] sd 0:0:0:0: Attached scsi 
generic sg0 type 0
Jul  6 09:15:41 fossie kernel: [  322.493044] sd 0:0:0:0: Attached scsi 
generic sg0 type 0
Jul  6 09:15:41 fossie kernel: [  322.493239] sd 0:0:0:0: [sdb] 
312581808 512-byte hardware sectors: (160 GB/149 GiB)
Jul  6 09:15:41 fossie kernel: [  322.493239] sd 0:0:0:0: [sdb] 
312581808 512-byte hardware sectors: (160 GB/149 GiB)
Jul  6 09:15:41 fossie kernel: [  322.493286] sd 0:0:0:0: [sdb] Write 
Protect is off
Jul  6 09:15:41 fossie kernel: [  322.493286] sd 0:0:0:0: [sdb] Write 
Protect is off
Jul  6 09:15:41 fossie kernel: [  322.493294] sd 0:0:0:0: [sdb] Mode 
Sense: 00 3a 00 00
Jul  6 09:15:41 fossie kernel: [  322.493294] sd 0:0:0:0: [sdb] Mode 
Sense: 00 3a 00 00
Jul  6 09:15:41 fossie kernel: [  322.493368] sd 0:0:0:0: [sdb] Write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  6 09:15:41 fossie kernel: [  322.493368] sd 0:0:0:0: [sdb] Write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  6 09:15:41 fossie kernel: [  322.493632]  sdb:<6>usb 4-2: reset 
full speed USB device using uhci_hcd and address 2
Jul  6 09:15:41 fossie kernel: [  322.493632]  sdb:<6>usb 4-2: reset 
full speed USB device using uhci_hcd and address 2
Jul  6 09:15:41 fossie kernel: [  322.989283] btusb 4-2:1.0: no 
reset_resume for driver btusb?
Jul  6 09:15:41 fossie kernel: [  322.989283] btusb 4-2:1.0: no 
reset_resume for driver btusb?
Jul  6 09:15:41 fossie kernel: [  322.989291] btusb 4-2:1.1: no 
reset_resume for driver btusb?
Jul  6 09:15:41 fossie kernel: [  322.989291] btusb 4-2:1.1: no 
reset_resume for driver btusb?
Jul  6 09:15:41 fossie kernel: [  323.240598] PM: resume devices took 
8.728 seconds
Jul  6 09:15:41 fossie kernel: [  323.240598] PM: resume devices took 
8.728 seconds
Jul  6 09:15:41 fossie kernel: [  323.240604] ------------[ cut here 
]------------
Jul  6 09:15:41 fossie kernel: [  323.240604] ------------[ cut here 
]------------
Jul  6 09:15:41 fossie kernel: [  323.240622] WARNING: at 
/home/kernel-ppa/mainline/build/kernel/power/main.c:176 
suspend_test_finish+0x83/0x90()
Jul  6 09:15:41 fossie kernel: [  323.240622] WARNING: at 
/home/kernel-ppa/mainline/build/kernel/power/main.c:176 
suspend_test_finish+0x83/0x90()
Jul  6 09:15:41 fossie kernel: [  323.240630] Hardware name: HP Tablet 
PC Tx1100
Jul  6 09:15:41 fossie kernel: [  323.240630] Hardware name: HP Tablet 
PC Tx1100
Jul  6 09:15:41 fossie kernel: [  323.240635] Component: resume devices
Jul  6 09:15:41 fossie kernel: [  323.240635] Component: resume devices
Jul  6 09:15:41 fossie kernel: [  323.240639] Modules linked in: 
michael_mic arc4 ecb lib80211_crypt_tkip aes_i586 aes_generic 
lib80211_crypt_ccmp binfmt_misc ppdev bridge stp bnep lp parport 
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
snd_seq snd_timer snd_seq_device pcmcia ipw2100 snd soundcore libipw 
pcspkr irda lib80211 yenta_socket rsrc_nonstatic pcmcia_core video 
snd_page_alloc iTCO_wdt iTCO_vendor_support output crc_ccitt intel_agp 
agpgart shpchp btusb usbhid b44 ssb mii
Jul  6 09:15:41 fossie kernel: [  323.240639] Modules linked in: 
michael_mic arc4 ecb lib80211_crypt_tkip aes_i586 aes_generic 
lib80211_crypt_ccmp binfmt_misc ppdev bridge stp bnep lp parport 
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
snd_seq snd_timer snd_seq_device pcmcia ipw2100 snd soundcore libipw 
pcspkr irda lib80211 yenta_socket rsrc_nonstatic pcmcia_core video 
snd_page_alloc iTCO_wdt iTCO_vendor_support output crc_ccitt intel_agp 
agpgart shpchp btusb usbhid b44 ssb mii
Jul  6 09:15:41 fossie kernel: [  323.240740] Pid: 3593, comm: s2ram 
Tainted: G        W  2.6.30-020630-generic #020630
Jul  6 09:15:41 fossie kernel: [  323.240740] Pid: 3593, comm: s2ram 
Tainted: G        W  2.6.30-020630-generic #020630
Jul  6 09:15:41 fossie kernel: [  323.240746] Call Trace:
Jul  6 09:15:41 fossie kernel: [  323.240746] Call Trace:
Jul  6 09:15:41 fossie kernel: [  323.240758]  [<c0166a43>] ? 
suspend_test_finish+0x83/0x90
Jul  6 09:15:41 fossie kernel: [  323.240758]  [<c0166a43>] ? 
suspend_test_finish+0x83/0x90
Jul  6 09:15:41 fossie kernel: [  323.240767]  [<c0166a43>] ? 
suspend_test_finish+0x83/0x90
Jul  6 09:15:41 fossie kernel: [  323.240767]  [<c0166a43>] ? 
suspend_test_finish+0x83/0x90
Jul  6 09:15:41 fossie kernel: [  323.240784]  [<c013b7fc>] 
warn_slowpath_common+0x7c/0xa0
Jul  6 09:15:41 fossie kernel: [  323.240784]  [<c013b7fc>] 
warn_slowpath_common+0x7c/0xa0
Jul  6 09:15:41 fossie kernel: [  323.240794]  [<c0166a43>] ? 
suspend_test_finish+0x83/0x90
Jul  6 09:15:41 fossie kernel: [  323.240794]  [<c0166a43>] ? 
suspend_test_finish+0x83/0x90
Jul  6 09:15:41 fossie kernel: [  323.240804]  [<c013b866>] 
warn_slowpath_fmt+0x26/0x30
Jul  6 09:15:41 fossie kernel: [  323.240804]  [<c013b866>] 
warn_slowpath_fmt+0x26/0x30
Jul  6 09:15:41 fossie kernel: [  323.240814]  [<c0166a43>] 
suspend_test_finish+0x83/0x90
Jul  6 09:15:41 fossie kernel: [  323.240814]  [<c0166a43>] 
suspend_test_finish+0x83/0x90
Jul  6 09:15:41 fossie kernel: [  323.240824]  [<c0166adf>] 
suspend_devices_and_enter+0x8f/0xc0
Jul  6 09:15:41 fossie kernel: [  323.240824]  [<c0166adf>] 
suspend_devices_and_enter+0x8f/0xc0
Jul  6 09:15:41 fossie kernel: [  323.240834]  [<c0166d43>] 
enter_state+0xc3/0xe0
Jul  6 09:15:41 fossie kernel: [  323.240834]  [<c0166d43>] 
enter_state+0xc3/0xe0
Jul  6 09:15:41 fossie kernel: [  323.240844]  [<c0166df1>] 
state_store+0x91/0xd0
Jul  6 09:15:41 fossie kernel: [  323.240844]  [<c0166df1>] 
state_store+0x91/0xd0
Jul  6 09:15:41 fossie kernel: [  323.240853]  [<c0166d60>] ? 
state_store+0x0/0xd0
Jul  6 09:15:41 fossie kernel: [  323.240853]  [<c0166d60>] ? 
state_store+0x0/0xd0
Jul  6 09:15:41 fossie kernel: [  323.240866]  [<c02cca34>] 
kobj_attr_store+0x24/0x30
Jul  6 09:15:41 fossie kernel: [  323.240866]  [<c02cca34>] 
kobj_attr_store+0x24/0x30
Jul  6 09:15:41 fossie kernel: [  323.240879]  [<c021358b>] 
flush_write_buffer+0x4b/0x70
Jul  6 09:15:41 fossie kernel: [  323.240879]  [<c021358b>] 
flush_write_buffer+0x4b/0x70
Jul  6 09:15:41 fossie kernel: [  323.240891]  [<c0213672>] 
sysfs_write_file+0x42/0x70
Jul  6 09:15:41 fossie kernel: [  323.240891]  [<c0213672>] 
sysfs_write_file+0x42/0x70
Jul  6 09:15:41 fossie kernel: [  323.240905]  [<c01c7ec6>] 
vfs_write+0x96/0x160
Jul  6 09:15:41 fossie kernel: [  323.240905]  [<c01c7ec6>] 
vfs_write+0x96/0x160
Jul  6 09:15:41 fossie kernel: [  323.240916]  [<c0213630>] ? 
sysfs_write_file+0x0/0x70
Jul  6 09:15:41 fossie kernel: [  323.240916]  [<c0213630>] ? 
sysfs_write_file+0x0/0x70
Jul  6 09:15:41 fossie kernel: [  323.240926]  [<c01c804d>] 
sys_write+0x3d/0x70
Jul  6 09:15:41 fossie kernel: [  323.240926]  [<c01c804d>] 
sys_write+0x3d/0x70
Jul  6 09:15:41 fossie kernel: [  323.240938]  [<c0102ebc>] 
sysenter_do_call+0x12/0x28
Jul  6 09:15:41 fossie kernel: [  323.240938]  [<c0102ebc>] 
sysenter_do_call+0x12/0x28
Jul  6 09:15:41 fossie kernel: [  323.240946] ---[ end trace 
888c80804185d327 ]---
Jul  6 09:15:41 fossie kernel: [  323.240946] ---[ end trace 
888c80804185d327 ]---
Jul  6 09:15:41 fossie kernel: [  323.241612] PM: Finishing wakeup.
Jul  6 09:15:41 fossie kernel: [  323.241612] PM: Finishing wakeup.
Jul  6 09:15:41 fossie kernel: [  323.241618] Restarting tasks ... 
<2>EXT3-fs error (device sda3): ext3_find_entry: reading directory 
#417793 offset 0
Jul  6 09:15:41 fossie kernel: [  323.241618] Restarting tasks ... 
<2>EXT3-fs error (device sda3): ext3_find_entry: reading directory 
#417793 offset 0
Jul  6 09:15:41 fossie kernel: [  323.245766] Remounting filesystem 
read-only
Jul  6 09:15:41 fossie kernel: [  323.262583] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:41 fossie kernel: [  323.263841] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #16399 offset 0
Jul  6 09:15:41 fossie kernel: [  323.264256] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #16399 offset 0
Jul  6 09:15:41 fossie kernel: [  323.368157] done.
Jul  6 09:15:41 fossie kernel: [  323.368157] done.
Jul  6 09:15:41 fossie kernel: [  323.395046] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #229397 offset 0
Jul  6 09:15:41 fossie kernel: [  323.420779] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:41 fossie kernel: [  323.421194] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:41 fossie kernel: [  323.421426] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #868353 offset 0
Jul  6 09:15:41 fossie kernel: [  323.421963] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1064961 offset 0
Jul  6 09:15:41 fossie kernel: [  323.422200] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #417793 offset 0
Jul  6 09:15:41 fossie kernel: [  323.422399] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #868353 offset 0
Jul  6 09:15:41 fossie kernel: [  323.435365] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #2 offset 0
Jul  6 09:15:41 fossie kernel: [  323.479387] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1064961 offset 0
Jul  6 09:15:41 fossie kernel: [  323.484110]  sdb1 sdb2 sdb3
Jul  6 09:15:41 fossie kernel: [  323.484110]  sdb1 sdb2 sdb3
Jul  6 09:15:41 fossie kernel: [  323.499741] sd 0:0:0:0: [sdb] Attached 
SCSI disk
Jul  6 09:15:41 fossie kernel: [  323.499741] sd 0:0:0:0: [sdb] Attached 
SCSI disk
Jul  6 09:15:41 fossie kernel: [  323.613764] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #565249 offset 0
Jul  6 09:15:41 fossie kernel: [  323.680052] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:41 fossie kernel: [  323.695533] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #885877 offset 0
Jul  6 09:15:41 fossie kernel: [  323.695751] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #885877 offset 0
Jul  6 09:15:41 fossie kernel: [  323.781533] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:41 fossie kernel: [  323.942261] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:41 fossie kernel: [  324.160064] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:41 fossie kernel: [  324.160532] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #868353 offset 0
Jul  6 09:15:41 fossie kernel: [  324.162652] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #893923 offset 0
Jul  6 09:15:41 fossie kernel: [  324.209018] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #229410 offset 0
Jul  6 09:15:41 fossie kernel: [  324.209728] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #229639 offset 0
Jul  6 09:15:42 fossie kernel: [  324.444147] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #885877 offset 0
Jul  6 09:15:42 fossie kernel: [  324.800771] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #868353 offset 0
Jul  6 09:15:42 fossie kernel: [  325.241180] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #229377 offset 0
Jul  6 09:15:42 fossie kernel: [  325.247216] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #2 offset 0
Jul  6 09:15:43 fossie NetworkManager: <info>  (eth0): carrier now ON 
(device state 2)
Jul  6 09:15:43 fossie NetworkManager: <info>  (eth0): device state 
change: 2 -> 3
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) 
starting connection 'Auto eth0'
Jul  6 09:15:43 fossie kernel: [  326.000211] b44: eth0: Link is up at 
100 Mbps, full duplex.
Jul  6 09:15:43 fossie kernel: [  326.000211] b44: eth0: Link is up at 
100 Mbps, full duplex.
Jul  6 09:15:43 fossie kernel: [  326.000222] b44: eth0: Flow control is 
off for TX and off for RX.
Jul  6 09:15:43 fossie kernel: [  326.000222] b44: eth0: Flow control is 
off for TX and off for RX.
Jul  6 09:15:43 fossie NetworkManager: <info>  (eth0): device state 
change: 3 -> 4
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) Stage 1 
of 5 (Device Prepare) scheduled...
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) Stage 1 
of 5 (Device Prepare) started...
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) Stage 2 
of 5 (Device Configure) scheduled...
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) Stage 1 
of 5 (Device Prepare) complete.
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) Stage 2 
of 5 (Device Configure) starting...
Jul  6 09:15:43 fossie NetworkManager: <info>  (eth0): device state 
change: 4 -> 5
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) Stage 2 
of 5 (Device Configure) successful.
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) Stage 3 
of 5 (IP Configure Start) scheduled.
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) Stage 2 
of 5 (Device Configure) complete.
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) Stage 3 
of 5 (IP Configure Start) started...
Jul  6 09:15:43 fossie NetworkManager: <info>  (eth0): device state 
change: 5 -> 7
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) 
Beginning DHCP transaction.
Jul  6 09:15:43 fossie NetworkManager: <WARN>  nm_dhcp_client_start(): 
/sbin/dhclient does not exist.
Jul  6 09:15:43 fossie NetworkManager: <info>  (eth0): device state 
change: 7 -> 9
Jul  6 09:15:43 fossie kernel: [  326.014853] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1064961 offset 0
Jul  6 09:15:43 fossie NetworkManager: <info>  Marking connection 'Auto 
eth0' invalid.
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) failed.
Jul  6 09:15:43 fossie NetworkManager: <info>  Activation (eth0) Stage 3 
of 5 (IP Configure Start) complete.
Jul  6 09:15:43 fossie NetworkManager: <info>  (eth0): device state 
change: 9 -> 3
Jul  6 09:15:43 fossie NetworkManager: <info>  (eth0): deactivating 
device (reason: 0).
Jul  6 09:15:43 fossie NetworkManager: <WARN>  
nm_named_manager_add_ip4_config(): Could not commit DNS changes.  Error: 
'Could not open /etc/resolv.conf.tmp: Read-only file system '
Jul  6 09:15:43 fossie NetworkManager: <info>  Policy set 'Auto 
FRITZ!Box Fon WLAN 7270' (eth1) as default for routing and DNS.
Jul  6 09:15:43 fossie kernel: [  326.131326] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:43 fossie kernel: [  326.131571] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1000010 offset 0
Jul  6 09:15:43 fossie kernel: [  326.131809] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #958510 offset 0
Jul  6 09:15:43 fossie kernel: [  326.133875] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #958510 offset 0
Jul  6 09:15:43 fossie kernel: [  326.134123] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1000010 offset 0
Jul  6 09:15:43 fossie kernel: [  326.134335] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1000010 offset 0
Jul  6 09:15:43 fossie kernel: [  326.134545] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1000010 offset 0
Jul  6 09:15:43 fossie kernel: [  326.134755] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1000010 offset 0
Jul  6 09:15:43 fossie kernel: [  326.134965] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1000010 offset 0
Jul  6 09:15:43 fossie kernel: [  326.135176] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1000010 offset 0
Jul  6 09:15:43 fossie kernel: [  326.135386] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1000010 offset 0
Jul  6 09:15:43 fossie kernel: [  326.135604] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1000010 offset 0
Jul  6 09:15:43 fossie kernel: [  326.135814] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1000010 offset 0
Jul  6 09:15:43 fossie kernel: [  326.140663] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1000010 offset 0
Jul  6 09:15:44 fossie kernel: [  327.131421] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:45 fossie kernel: [  328.131298] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #229673 offset 0
Jul  6 09:15:45 fossie kernel: [  328.131633] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #229406 offset 0
Jul  6 09:15:45 fossie kernel: [  328.131982] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #229665 offset 0
Jul  6 09:15:45 fossie kernel: [  328.133980] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:45 fossie kernel: [  328.134256] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:45 fossie kernel: [  328.139490] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:45 fossie kernel: [  328.140065] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #229377 offset 0
Jul  6 09:15:45 fossie kernel: [  328.140468] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #229624 offset 0
Jul  6 09:15:50 fossie console-kit-daemon[2286]: WARNING: Unable to open 
directory /etc/ConsoleKit/run-session.d: Error opening directory 
'/etc/ConsoleKit/run-session.d': No such file or directory
Jul  6 09:15:50 fossie acpid: client connected from 2495[0:0]
Jul  6 09:15:50 fossie console-kit-daemon[2286]: WARNING: Unable to open 
directory /usr/lib/ConsoleKit/run-session.d: Error opening directory 
'/usr/lib/ConsoleKit/run-session.d': No such file or directory
Jul  6 09:15:50 fossie console-kit-daemon[2286]: WARNING: Unable to open 
directory /etc/ConsoleKit/run-session.d: Error opening directory 
'/etc/ConsoleKit/run-session.d': No such file or directory
Jul  6 09:15:50 fossie console-kit-daemon[2286]: WARNING: Unable to open 
directory /usr/lib/ConsoleKit/run-session.d: Error opening directory 
'/usr/lib/ConsoleKit/run-session.d': No such file or directory
Jul  6 09:15:50 fossie console-kit-daemon[2286]: WARNING: Record was not 
written to disk (Read-only file system)
Jul  6 09:15:50 fossie kernel: [  332.863262] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:50 fossie kernel: [  332.863322] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:15:50 fossie NetworkManager: <info>  (eth1): supplicant 
connection state:  associated -> disconnected
Jul  6 09:15:50 fossie NetworkManager: <info>  (eth1): supplicant 
connection state:  disconnected -> scanning
Jul  6 09:15:51 fossie NetworkManager: <info>  (eth1): supplicant 
connection state:  scanning -> disconnected
Jul  6 09:15:51 fossie NetworkManager: <info>  (eth1): supplicant 
connection state:  disconnected -> associating
Jul  6 09:15:51 fossie NetworkManager: <info>  (eth1): supplicant 
connection state:  associating -> associated
Jul  6 09:15:52 fossie NetworkManager: <info>  (eth1): supplicant 
connection state:  associated -> 4-way handshake
Jul  6 09:15:52 fossie NetworkManager: <info>  (eth1): supplicant 
connection state:  4-way handshake -> group handshake
Jul  6 09:15:52 fossie NetworkManager: <info>  (eth1): supplicant 
connection state:  group handshake -> completed
Jul  6 09:15:56 fossie kernel: [  338.633851] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1025639 offset 0
Jul  6 09:16:04 fossie kernel: [  347.155882] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #958616 offset 0
Jul  6 09:16:04 fossie kernel: [  347.155944] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #958616 offset 0
Jul  6 09:16:04 fossie kernel: [  347.155989] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #958616 offset 0
Jul  6 09:16:04 fossie kernel: [  347.157931] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #958616 offset 0
Jul  6 09:16:04 fossie kernel: [  347.157981] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #958616 offset 0
Jul  6 09:16:04 fossie kernel: [  347.158041] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #1115826 offset 0
Jul  6 09:16:04 fossie kernel: [  347.158093] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #958617 offset 0
Jul  6 09:16:04 fossie kernel: [  347.158136] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #958617 offset 0
Jul  6 09:16:04 fossie kernel: [  347.158178] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #958617 offset 0
Jul  6 09:16:04 fossie kernel: [  347.158220] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #958617 offset 0
Jul  6 09:16:04 fossie kernel: [  347.158262] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #958617 offset 0
Jul  6 09:16:06 fossie /usr/sbin/cron[2696]: (CRON) STAT FAILED (crontabs)
Jul  6 09:16:06 fossie kernel: [  348.721682] EXT3-fs error (device 
sda3): ext3_find_entry: reading directory #247074 offset 0
Jul  6 09:23:06 fossie NetworkManager: <info>  (eth1): supplicant 
connection state:  completed -> group handshake
Jul  6 09:23:06 fossie NetworkManager: <info>  (eth1): supplicant 
connection state:  group handshake -> completed



--------------060109030703060106070603
Content-Type: text/x-vcard; charset=utf-8;
 name="christof.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="christof.vcf"

begin:vcard
fn:Christof Warlich
n:Warlich;Christof
org:Warlich Consulting
adr:;;Am Haselhang 7;Hilpoltstein;Bayern;91161;Deutschland
email;internet:christof@warlich.name
tel;work:09174/492914
tel;home:09174/492914
x-mozilla-html:TRUE
url:www.warlich.name
version:2.1
end:vcard


--------------060109030703060106070603--
