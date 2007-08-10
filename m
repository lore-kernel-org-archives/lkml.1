Return-Path: <linux-kernel-owner+w=401wt.eu-S932510AbXHJLDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbXHJLDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 07:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbXHJLDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 07:03:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:28682 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388AbXHJLDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 07:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oUqTbwCgyvQkWAbQHvrr7XLNTcP1Ao8tqC/ADRfCMdmMzJBJCQ/lpA0Y6aYDGF4+8crQrAQNxcFfBudbeZatw/dIkvR+P1lwVEIuW9zoeSuevQXkr/XaElONlwiogZsh35/5J2mQZTnvH5pbYLQ34YvYEqM7P/5qGe9Picoeq24=
Message-ID: <7fedbc910708100403s10d0152dqbfa1c4a1646eccf7@mail.gmail.com>
Date: Fri, 10 Aug 2007 13:03:22 +0200
From: shacky <shacky83@gmail.com>
To: "Dave Jones" <davej@redhat.com>, shacky <shacky83@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Unable to handle kernel paging request at virtual address
In-Reply-To: <20070810000900.GA30952@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7fedbc910708091617o7ae25fd8i36e7ec32c2b9ba86@mail.gmail.com>
	 <20070809234000.GA19549@redhat.com>
	 <7fedbc910708091644u5aaf37f7q5d259a66e2a4cce8@mail.gmail.com>
	 <20070810000900.GA30952@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's hard to blindly guess because there's so little to go on.
> At the least, a complete list of the modules loaded, the EIP/RIP
> and the call trace. (This makes up 90% of the output, hence the
> suggestion to take a photograph).

Ok, I wrote down all the error:

===========================================================
[9271.829711] BUG: unable to handle kernel paging request at virtual
address 6d207972
[9271.829805] printing eip:
[9271.829845] 6d207972
[9271.829883] *pde = 00000000
[9271.829926] Oops: 000 [#2]
[9271.829965] SMP
[9271.830067] Modules linked in: bluetooth capability lirc_dev ppdev
speedstep_lib cpufreq_powersave cpufreq_stats cpufreq_userspace
cpufreq_ondemand cpufreq_conservative freq_table video container sbs
button dock ac battery ipv6 sbp2 lp fuse snd_emu10k1_synth
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm
snd_page_alloc and_util_mem snd_hwdep snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event pcmcia snd_seq snd_timer
snd_seq_device parport_pc snd parport serio_raw psmouse pcspkr
emu10k1_gp soundcore yenta_socket rsrc_nonstatic pcmcia_core gameport
i2c_sis96x shpchp i2c_core pci_hotplug sis_agp agpgart af_packet evdev
reiserfs sg sr_mod cdrom sd_mod b44 mii ehci_hcd ohci_hcd usbcore
pata_sis ata_generic libata scsi_mod ohci1394 ieee1394 thermal
processor fan apparmor commoncap aamatch_pcre
[9271.833075] CPU:    0
[9271.833076] EIP:    0060:[<6d207972>]    Not tainted VLI
[9271.833078] EFLAGS: 00010206   (2.6.22-9-generic #1)
[9271.833212] EIP is at 0x6d207972
[9271.833255] eax: d55f5c08   ebx: d26f0a00   ecx: 00000000   edx: 6d207972
[9271.833305] esi: 01234567   edi: b7f8fff4   ebp: d3218000   esp: d3219e8c
[9271.833371] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[9271.833435] Process reboot (pid: 9650, ti=d3218000 task=d8b2af60
task.ti=d3218000)
[9271.833501] Stack: c026326c 00000000 c013585b c02f2c7e 28121969
28121969 c0135a4a 000000c3
[9271.833868]        c158fcd4 c158fcd4 c015e660 00000148 c13b5b00
c0161001 c0284a32 00000000
[9271.834236]        d3219f50 ddf6d420 dc2ada80 dc2adac8 c158fc30
00000000 00000000 c043ac20
[9271.843603] Call trace:
[9271.834704]  [<c026326c>] device_shutdown+0x3c/0x90
[9271.834818]  [<c013585b>] kernel_restart+0xb/0x50
[9271.834915]  [<c02f2c7e>] lock_kernel+0x1e/0x40
[9271.835028]  [<c0135a4a>] sys_reboot+0x19a/0x1e0
[9271.835140]  [<c015e660>] find_get_page+0x20/0x60
[9271.835249]  [<c0161001>] filemap_nopage+0x181/0x340
[9271.835344]  [<c0284a32>] netdev_run_todo+0x142/0x250
[9271.835512]  [<c02f2a58>] _spin_lock_bh+0x8/0x20
[9271.835624]  [<c01a32fe>] invalidate_inode_buffers+0xe/0xc0
[9271.835719]  [<c02f2a58>] _spin_lock_bh+0x8/0x20
[9271.835878]  [<c0193d9e>] destroy_inode+0x2e/0x50
[9271.835993]  [<c0191758>] d_kill+0x38/0x50
[9271.836098]  [<c0192457>] dput+0x87/0x100
[9271.836197]  [<c01814eb>] __fput+0x12b/0x1a0
[9271.836318]  [<c0196884>] mntput_no_expire+0x24/0xa0
[9271.836430]  [<c017e8f7>] filp_close+0x47/0x80
[9271.836548]  [<c017fc6b>] sys_close+0x6b/0xd0
[9271.836658]  [<c01041d2>] sysenter_pat_esp+0x6b/0xa9
[9271.836848]  =======================
[9271.836905] Code:  Bad EIP value.
[9271.837024] EIP: [<6d207972>] 0x6d207972 SS:ESP 0068:d3219e8c
===========================================================

Thank you very much!
Bye.
