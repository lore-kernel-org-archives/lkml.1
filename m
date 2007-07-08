Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbXGHQPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbXGHQPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 12:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbXGHQPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 12:15:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:46814 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbXGHQPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 12:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QXoOE6wfdKFLE32UBV1Nr96JrK98Xl+o7jpq/zMwHuixnvGdFuWafD9jpujeKdP7dla9OcC8ET6lel3J8OpZ3v0rf+flwY1E2fkIl6L92pKHeYlelBLaWlZjJFu9HgPr+cNWUR4QhG94Ohs1IVKifVSyhk87BZIzToIbW3E/7tg=
Message-ID: <dcf706c60707080915w7660a2exe629c5def78549da@mail.gmail.com>
Date: Sun, 8 Jul 2007 18:15:43 +0200
From: "Sasa Ostrouska" <casaxa@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: KVM-AMD OOPS
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi people,

I have kernel 2.6.21.5 and when trying to insert the kvm-amd module I
get this oops:

root@rcserver:~# modprobe kvm-amd
int3: 0000 [1] PREEMPT SMP
CPU 1
Modules linked in: kvm_amd snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
nls_iso8859_1 ntfs nls_base usb_storage libusual capability commoncap
lp psmouse snd_hda_intel snd_hda_codec snd_pcm snd_timer ohci_hcd
ehci_hcd 8139too rtc_cmos snd soundcore snd_page_alloc usbcore k8temp
mii rtc_core rtc_lib i2c_nforce2 parport_pc parport
Pid: 2898, comm: modprobe Tainted: P       2.6.21.5 #1
RIP: 0010:[<ffffffff80572364>]  [<ffffffff80572364>]
register_cpu_notifier+0x1/0x31
RSP: 0000:ffff81006e34df40  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000c0010117
RDX: 000000000000ffff RSI: ffff81006e219640 RDI: ffffffff80536510
RBP: ffffffff880d8840 R08: 0000000000000000 R09: 000000000006b5f4
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000005296b0
R13: 00007fff51fe55c0 R14: 0000000000000000 R15: 0000000000000000
FS:  00002b4e58e18b00(0000) GS:ffff810002e794c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000050df64 CR3: 000000007a0f3000 CR4: 00000000000006e0
Process modprobe (pid: 2898, threadinfo ffff81006e34c000, task ffff81007bc48400)
Stack:  ffffffff8039e024 ffff81006e34c000 ffffffff880d8840 0000000000005e19
 ffffffff8024537c 0000000000000000 00007fff51fe50c0 00000000004142d0
 ffffffff8020967e 0000000000000206 00000000005230e0 000000000052f4c9
Call Trace:
 [<ffffffff8039e024>] kvm_init_arch+0x90/0x145
 [<ffffffff8024537c>] sys_init_module+0xad/0x168
 [<ffffffff8020967e>] system_call+0x7e/0x83


Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
RIP  [<ffffffff80572364>] register_cpu_notifier+0x1/0x31
 RSP <ffff81006e34df40>
note: modprobe[2898] exited with preempt_count 1
Segmentation fault

Message from syslogd@rcserver at Sun Jul  8 21:00:33 2007 ...
rcserver kernel: int3: 0000 [1] PREEMPT SMP
root@rcserver:~#

This is on a x86-64 machine. If you need additional info please
contact by e-mail as i'm not subscribed to the list.

Best Regards
Sasa Ostrouska
