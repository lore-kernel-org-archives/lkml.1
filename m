Return-Path: <linux-kernel-owner+w=401wt.eu-S1760442AbXLTCO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442AbXLTCO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 21:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759522AbXLTCOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 21:14:04 -0500
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:58645 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbXLTCOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 21:14:01 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: linux-kernel@vger.kernel.org
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as well
Date: Thu, 20 Dec 2007 03:13:54 +0100
User-Agent: KMail/1.9.7
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <Pine.LNX.4.64.0712171540040.6503@blonde.wat.veritas.com> <200712172044.51629.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200712172044.51629.volker.armin.hemmann@tu-clausthal.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200313.54425.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag, 17. Dezember 2007, you wrote:

and another one, this time tainted with the nvidia module:
5194.130985] Unable to handle kernel paging request at 0000030000000000 RIP:
[ 5194.130988]  [<ffffffff804449fa>] _spin_lock+0x0/0xf
[ 5194.130993] PGD 0
[ 5194.130994] Oops: 0002 [1] SMP
[ 5194.130996] CPU 1
[ 5194.130997] Modules linked in: rfcomm l2cap hci_usb bluetooth snd_usb_audio 
ohci1394 snd_usb_lib ieee1394 aic7xxx i2c_nforce2 nvidia(P) k8temp w83627ehf 
hwmon_vid hwmon i2c_core snd_seq_midi snd_emu10k1_synth snd_emux_synth 
snd_seq_virmidi snd_seq_midi_emul snd_pcm_oss snd_mixer_oss snd_seq_oss 
snd_seq_midi_event snd_seq snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus 
snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd 
r8169
[ 5194.131014] Pid: 22490, comm: sleep Tainted: P        2.6.23.11reiser4 #4
[ 5194.131015] RIP: 0010:[<ffffffff804449fa>]  [<ffffffff804449fa>] 
_spin_lock+0x0/0xf
[ 5194.131018] RSP: 0018:ffff81009278be70  EFLAGS: 00010206
[ 5194.131020] RAX: 00002ab90bfb5000 RBX: ffff810117d44db0 RCX: 
00002ab90bdb5000
[ 5194.131021] RDX: ffff81011519f810 RSI: 000000388aa08fff RDI: 
0000030000000000
[ 5194.131023] RBP: 0000030000000000 R08: ffff81012f190ea0 R09: 
0000000000000000
[ 5194.131024] R10: 0000000000000008 R11: 0000000000000246 R12: 
ffff810117d44db0
[ 5194.131026] R13: 00002ab90bdb0000 R14: 0000000000000000 R15: 
0000000000000000
[ 5194.131028] FS:  00002ab90bde3070(0000) GS:ffff81012fc6cec0(0000) 
knlGS:00000000f7f756c0
[ 5194.131030] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5194.131031] CR2: 0000030000000000 CR3: 0000000093605000 CR4: 
00000000000006e0
[ 5194.131033] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 5194.131034] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 5194.131036] Process sleep (pid: 22490, threadinfo ffff81009278a000, task 
ffff8100960630c0)
[ 5194.131037] Stack:  ffffffff8026afbc ffff810117d44db0 ffff810115e2cbb8 
ffff810117d44db0
[ 5194.131040]  ffffffff80265ec3 ffff81009278bee0 ffff81009278bee0 
ffff810115e2c3d8
[ 5194.131043]  ffff8100a076cb80 0000000000000002 00007fff9ecf7808 
00007fff9ecf7810
[ 5194.131045] Call Trace:
[ 5194.131048]  [<ffffffff8026afbc>] anon_vma_unlink+0x1a/0x64
[ 5194.131051]  [<ffffffff80265ec3>] free_pgtables+0x64/0xc4
[ 5194.131054]  [<ffffffff80267174>] exit_mmap+0x91/0xeb
[ 5194.131057]  [<ffffffff80230191>] mmput+0x28/0xa0
[ 5194.131060]  [<ffffffff802353db>] do_exit+0x211/0x786
[ 5194.131063]  [<ffffffff802359cf>] sys_exit_group+0x0/0xe
[ 5194.131065]  [<ffffffff8020b66e>] system_call+0x7e/0x83
[ 5194.131069]
[ 5194.131070]
[ 5194.131070] Code: f0 ff 0f 79 09 f3 90 83 3f 00 7e f9 eb f2 c3 f0 81 2f 00 
00
[ 5194.131076] RIP  [<ffffffff804449fa>] _spin_lock+0x0/0xf
[ 5194.131078]  RSP <ffff81009278be70>
[ 5194.131079] CR2: 0000030000000000
[ 5194.131101] Fixing recursive fault but reboot is needed!
