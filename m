Return-Path: <linux-kernel-owner+w=401wt.eu-S1161390AbXBOVag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161390AbXBOVag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161391AbXBOVaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:30:35 -0500
Received: from smtp.ono.com ([62.42.230.12]:8300 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161390AbXBOVae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:30:34 -0500
Date: Thu, 15 Feb 2007 22:30:17 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1
Message-ID: <20070215223017.2cf5d19f@werewolf-wl>
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.7.2cvs44 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 05:14:08 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.20-mm1/
> 
> Will appear later at
> 
>  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm1/
> 
> 

Oops plague for me :(.

A lot like this:

ee1394 usblp evdev
CPU:    1
EIP:    0060:[<c0195f12>]    Tainted: P       VLI
EFLAGS: 00010246   (2.6.20-jam01 #1)
EIP is at sysfs_lookup+0x5b/0x20a
eax: f6707118   ebx: f6b33e5c   ecx: f6917d38   edx: 00000004
esi: 00000000   edi: f670717c   ebp: f6b33e24   esp: f6997db4
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process udevd (pid: 3899, ti=f6996000 task=f7e34540 task.ti=f6996000)
Stack: f66e1800 f6707118 c016da12 f66e1800 f6707118 c02f75c0 f6707118 f6997f04 
       f6997e38 c0164238 f6997e44 c210d8c0 f6b39340 f6b393b4 f7a7d025 f6997e38 
       27692f8b f6997f04 c0165a6a f7a7d01d 00000000 000200d2 c037ddac 00000286 
Call Trace:
 [<c016da12>] d_alloc+0x140/0x198
 [<c0164238>] do_lookup+0x128/0x165
 [<c0165a6a>] __link_path_walk+0x7e2/0xc9b
 [<c0165f68>] link_path_walk+0x45/0xbf
 [<c01661b6>] do_path_lookup+0x88/0x1cc
 [<c0165125>] getname+0x90/0xad
 [<c0166aa4>] __user_walk_fd+0x2f/0x47
 [<c01607c4>] vfs_lstat_fd+0x16/0x3d
 [<c0160830>] sys_lstat64+0xf/0x23
 [<c0111904>] do_page_fault+0x326/0x5e2
 [<c01115de>] do_page_fault+0x0/0x5e2
 [<c010288e>] sysenter_past_esp+0x5f/0x85
 [<c02f0000>] wait_for_completion_interruptible+0xdf/0xee
 =======================
Code: 83 ed 04 8b 45 04 0f 18 00 90 8d 45 04 39 d8 0f 84 bc 00 00 00 f6 45 18 2c 74 e2 89 e8 e8 ed e4 ff ff 89 c6 8b 44 24 10 8b 78 28 <ac> ae 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 85 c0 75 be 8b 
EIP: [<c0195f12>] sysfs_lookup+0x5b/0x20a SS:ESP 0068:f6997db4
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
c01963ff
*pde = 00000000
Oops: 0000 [#5]
PREEMPT SMP 
last sysfs file: /devices/pci0000:00/0000:00:00.0/resource
Modules linked in: nfsd exportfs lockd nfs_acl sunrpc w83627hf hwmon_vid hwmon i2c_isa i2c_i801 i2c_dev microcode snd_intel8x0 snd_ens1371 gameport snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd nvidia(P) loop intel_agp agpgart udf e1000 3c59x ohci1394 ieee1394 usblp evdev
CPU:    1
EIP:    0060:[<c01963ff>]    Tainted: P       VLI
EFLAGS: 00010246   (2.6.20-jam01 #1)
EIP is at sysfs_follow_link+0x109/0x254
eax: 00000000   ebx: 00000001   ecx: ffffffff   edx: ffffffff
esi: 00000000   edi: 00000000   ebp: 00000003   esp: f70fdea4
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process udevd (pid: 3900, ti=f70fc000 task=c21f5070 task.ti=f70fc000)
Stack: f6917cd8 f70fdedc f670b000 f7321c88 ffffffff f6917cd8 ffffffea 00000000 
       c02f76a0 f6707aa8 00000200 bfa2c2fc c0163e50 b7fc9ff4 f70fc000 f70fdfb8 
       f7f732f4 c21f5070 f7f732c0 f70fdfb8 c011d757 00000000 f6cfbe68 f70fdf44 
Call Trace:
 [<c0163e50>] generic_readlink+0x27/0x6e
 [<c011d757>] timespec_trunc+0x18/0x57
 [<c011dd47>] current_fs_time+0x4d/0x66
 [<c016f990>] touch_atime+0x6e/0xee
 [<c016076a>] sys_readlinkat+0x61/0x7a
 [<c0111904>] do_page_fault+0x326/0x5e2
 [<c01607aa>] sys_readlink+0x27/0x2b
 [<c010288e>] sysenter_past_esp+0x5f/0x85
 [<c02f0000>] wait_for_completion_interruptible+0xdf/0xee
 =======================

Full dmesg at:

http://belly.cps.unizar.es/~magallon/oops/oops.txt

And another one on reboot. Picture here:

http://belly.cps.unizar.es/~magallon/oops/IMG_1448.JPG

(sorry, no tripod available ;), just the back of my soft chair).

And yes, before nobody says anything, nvidia.ko is loaded.
If you really want, I can try without it.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.19-jam07 (gcc 4.1.2 20070115 (prerelease) (4.1.2-0.20070115.1mdv2007.1)) #2 SMP PREEMPT
