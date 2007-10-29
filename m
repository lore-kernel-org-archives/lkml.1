Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbXJ2Hpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbXJ2Hpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXJ2Hpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:45:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54463 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbXJ2Hpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:45:32 -0400
Date: Mon, 29 Oct 2007 00:45:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Syd Alsobrook <syd@ittagteam.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: Problem: OOPS in khubd on disconnect of Labtec USB Headset
Message-Id: <20071029004517.f39f867d.akpm@linux-foundation.org>
In-Reply-To: <200710221503.54949.syd@ittagteam.com>
References: <200710221503.54949.syd@ittagteam.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 15:03:54 -0400 Syd Alsobrook <syd@ittagteam.com> wrote:

> OOPS in khubd on disconnect of Labtec USB Headset
> 
> Linux version 2.6.23.1 (alsobrsp@karma) (gcc version 4.1.3 20070831 
> (prerelease) (Debian 4.1.2-16)) #5 SMP PREEMPT Sat Oct 20 11:53:38 EDT 2007
> 
> BUG: unable to handle kernel paging request at virtual address 00100100
>  printing eip:
> f89b5faa
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT SMP
> Modules linked in: snd_rtctimer dv1394 raw1394 nfsd exportfs auth_rpcgss ppdev 
> lp fan ac battery autofs4 nfs lockd nfs_acl sunrpc ipv6 fuse dm_snapshot 
> dm_mirror dm_mod rtc_rs5c372 rtc_rs5c348 rtc_v3020 rtc_x1205 rtc_pcf8563 
> rtc_max6902 rtc_m48t86 rtc_isl1208 rtc_ds1742 rtc_ds1672 rtc_ds1553 
> rtc_ds1307 rtc_cmos lm85 hwmon_vid loop sg sr_mod usblp snd_emu10k1_synth 
> snd_usb_audio snd_emux_synth snd_usb_lib snd_seq_virmidi snd_seq_midi_emul 
> snd_emu10k1 snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq 
> snd_rawmidi snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm 
> snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd ohci1394 
> parport_pc parport ieee1394 emu10k1_gp gameport soundcore tg3 ohci_hcd floppy 
> pcspkr rtc thermal button psmouse usb_storage processor generic i2c_i801 
> serio_raw iTCO_wdt piix i2c_core intel_agp agpgart shpchp pci_hotplug 
> ide_disk tsdev joydev evdev
> CPU:    0
> EIP:    0060:[<f89b5faa>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.23.1 #5)
> EIP is at snd_ctl_dev_disconnect+0x4b/0x7c [snd]
> eax: ef6ade70   ebx: 00100100   ecx: 00020004   edx: 0000001d
> esi: f7fd6200   edi: f7fd634c   ebp: f78f1800   esp: c217de70
> ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Process khubd (pid: 153, ti=c217c000 task=c217e790 task.ti=c217c000)
> Stack: 00000000 f79ec600 f7fd6200 00000000 f89b7a88 00000213 f79ec600 f7fd6200
>        f89b7cb7 00000000 f7fd6200 f8b51a20 f89b4dcc c031ad37 c0288fb9 f7f81800
>        c20e8d80 f8b41631 f7fd6200 f7f81800 f7f8181c f8b51a20 f78f1800 c0289b7c
> Call Trace:
>  [<f89b7a88>] snd_device_disconnect+0x28/0x60 [snd]
>  [<f89b7cb7>] snd_device_disconnect_all+0x19/0x3e [snd]
>  [<f89b4dcc>] snd_card_disconnect+0x11b/0x13f [snd]
>  [<c031ad37>] _spin_unlock_irqrestore+0xf/0x23
>  [<c0288fb9>] usb_autopm_do_device+0xc7/0xd1
>  [<f8b41631>] usb_audio_disconnect+0x44/0xea [snd_usb_audio]
>  [<c0289b7c>] usb_unbind_interface+0x44/0x94
>  [<c024fb8c>] __device_release_driver+0x71/0x8e
>  [<c024ff14>] device_release_driver+0x1e/0x34
>  [<c024f587>] bus_remove_device+0x6d/0x7dBUG: unable to handle kernel paging 
> request at virtual address 00100100
>  printing eip:
> f89b5faa

Did any earlier kernel work OK?  If so, can you tell us which version(s)?

Thanks.
