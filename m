Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbXGHSLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbXGHSLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbXGHSLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:11:37 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:33020 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbXGHSLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:11:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JC/6A6yH/c/KX7ZGqUm8s+nXCpP+VsCMtp7U7MEEHxlDh85rhyLWdJ7LNz11I73mbR5MRo0F7DidzC6UIRAoyMUQLvUdu8C9bH9foOr3oU7OSIMzI3y7u776z2bCpfU1lbTQlS9CNV5afF0w2h5T7bBZWVXCl9aOWCHVEK3myc8=
Message-ID: <dcf706c60707081111yd4240ftf612ddc8695325f4@mail.gmail.com>
Date: Sun, 8 Jul 2007 20:11:34 +0200
From: "Sasa Ostrouska" <casaxa@gmail.com>
To: linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com
Subject: Re: KVM-AMD OOPS
In-Reply-To: <dcf706c60707081051r2ff03a7bi35307536755b42f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dcf706c60707080915w7660a2exe629c5def78549da@mail.gmail.com>
	 <469121DC.7070504@googlemail.com>
	 <dcf706c60707081051r2ff03a7bi35307536755b42f6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here is the output without nvidia driver installed.


Jul  9 00:02:38 rcserver kernel: int3: 0000 [1] PREEMPT SMP
Jul  9 00:02:38 rcserver kernel: CPU 1
Jul  9 00:02:38 rcserver kernel: Modules linked in: kvm_amd
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
snd_pcm_oss snd_mixer_oss nls_iso8859_1 ntfs nls_base usb_storage
libusual capability commoncap lp psmouse snd_hda_intel snd_hda_codec
snd_pcm snd_timer snd 8139too mii k8temp soundcore snd_page_alloc
ehci_hcd ohci_hcd rtc_cmos i2c_nforce2 usbcore rtc_core rtc_lib
parport_pc parport
Jul  9 00:02:38 rcserver kernel: Pid: 2898, comm: modprobe Not tainted
2.6.21.5 #1
Jul  9 00:02:38 rcserver kernel: RIP: 0010:[<ffffffff80572364>]
[<ffffffff80572364>] register_cpu_notifier+0x1/0x31
Jul  9 00:02:38 rcserver kernel: RSP: 0018:ffff81006f117f40  EFLAGS: 00000246
Jul  9 00:02:38 rcserver kernel: RAX: 0000000000000000 RBX:
0000000000000000 RCX: 00000000c0010117
Jul  9 00:02:38 rcserver kernel: RDX: 000000000000ffff RSI:
ffff81007b7d6cc0 RDI: ffffffff80536510
Jul  9 00:02:38 rcserver kernel: RBP: ffffffff8816e840 R08:
0000000000000000 R09: 000000000006c112
Jul  9 00:02:38 rcserver kernel: R10: 0000000000000000 R11:
0000000000000000 R12: 00000000005296b0
Jul  9 00:02:38 rcserver kernel: R13: 00007fffa75ddbb0 R14:
0000000000000000 R15: 0000000000000000
Jul  9 00:02:38 rcserver kernel: FS:  00002af70381fb00(0000)
GS:ffff810002e794c0(0000) knlGS:0000000000000000
Jul  9 00:02:38 rcserver kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Jul  9 00:02:38 rcserver kernel: CR2: 0000000000508a68 CR3:
000000007a299000 CR4: 00000000000006e0
Jul  9 00:02:38 rcserver kernel: Process modprobe (pid: 2898,
threadinfo ffff81006f116000, task ffff81007bd62340)
Jul  9 00:02:38 rcserver kernel: Stack:  ffffffff8039e024
ffff81006f116000 ffffffff8816e840 0000000000005e19
Jul  9 00:02:38 rcserver kernel:  ffffffff8024537c 0000000000000000
00007fffa75dd6b0 00000000004142d0
Jul  9 00:02:38 rcserver kernel:  ffffffff8020967e 0000000000000206
00000000005230e0 000000000052f4c9
Jul  9 00:02:38 rcserver kernel: Call Trace:
Jul  9 00:02:38 rcserver kernel:  [<ffffffff8039e024>] kvm_init_arch+0x90/0x145
Jul  9 00:02:38 rcserver kernel:  [<ffffffff8024537c>]
sys_init_module+0xad/0x168
Jul  9 00:02:38 rcserver kernel:  [<ffffffff8020967e>] system_call+0x7e/0x83
Jul  9 00:02:38 rcserver kernel:
Jul  9 00:02:38 rcserver kernel:
Jul  9 00:02:38 rcserver kernel: Code: cc cc cc cc cc cc cc cc cc cc
cc cc cc cc cc cc cc cc cc cc
Jul  9 00:02:38 rcserver kernel: RIP  [<ffffffff80572364>]
register_cpu_notifier+0x1/0x31
Jul  9 00:02:38 rcserver kernel:  RSP <ffff81006f117f40>
Jul  9 00:02:38 rcserver kernel: BUG: scheduling while atomic:
modprobe/0x10000001/2898
Jul  9 00:02:38 rcserver kernel:
Jul  9 00:02:38 rcserver kernel: Call Trace:
Jul  9 00:02:38 rcserver kernel:  <#DB>  [<ffffffff80445740>]
__sched_text_start+0x60/0x80f
Jul  9 00:02:38 rcserver kernel:  [<ffffffff804451f9>] __down_trylock+0x44/0x4f
Jul  9 00:02:38 rcserver kernel:  [<ffffffff804477fb>]
__down_failed_trylock+0x35/0x3a
Jul  9 00:02:38 rcserver kernel:  [<ffffffff80225517>] __cond_resched+0x1c/0x44
Jul  9 00:02:38 rcserver kernel:  [<ffffffff80446818>] cond_resched+0x2e/0x39
Jul  9 00:02:38 rcserver kernel:  [<ffffffff802586c5>] unmap_vmas+0x6a5/0x73d
Jul  9 00:02:38 rcserver kernel:  [<ffffffff8025dabb>] exit_mmap+0x7f/0x11b
Jul  9 00:02:38 rcserver kernel:  [<ffffffff80227449>] mmput+0x29/0x9a
Jul  9 00:02:38 rcserver kernel:  [<ffffffff8022c2f9>] do_exit+0x216/0x823
Jul  9 00:02:38 rcserver kernel:  [<ffffffff80447b38>]
__lock_text_start+0x8/0x30
Jul  9 00:02:38 rcserver kernel:  [<ffffffff8020b044>] die_nmi+0x0/0x75
Jul  9 00:02:38 rcserver kernel:  [<ffffffff8020bb3a>] do_int3+0x81/0xa1
Jul  9 00:02:38 rcserver kernel:  [<ffffffff804485d3>] int3+0x93/0xb0
Jul  9 00:02:38 rcserver kernel:  [<ffffffff80572364>]
register_cpu_notifier+0x1/0x31
Jul  9 00:02:38 rcserver kernel:  <<EOE>>  [<ffffffff8039e024>]
kvm_init_arch+0x90/0x145
Jul  9 00:02:38 rcserver kernel:  [<ffffffff8024537c>]
sys_init_module+0xad/0x168
Jul  9 00:02:38 rcserver kernel:  [<ffffffff8020967e>] system_call+0x7e/0x83
Jul  9 00:02:38 rcserver kernel:

Rgds
Saxa
