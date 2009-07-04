Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZGDOuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZGDOuS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 10:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbZGDOuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 10:50:07 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:43830 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZGDOuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 10:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=JuXMoUu0rEZks/g730A0oOU52oAk/N0z2b1F5hGJcp1ujGMZ16ZqXqHcIKkT4GTSIB
         ZGpQ9K2j/yq1zUvwNCEj+SwfbYO3e35IJzvbNg6i7EH9z6UHL//hDuYGVJsbn604NR1v
         +iGCQApCklSPF+eSxrnKz9T5HHySH24KUMwc0=
Message-ID: <4A4F6C1D.5060803@gmail.com>
Date: Sat, 04 Jul 2009 16:50:05 +0200
From: "Mikko C." <mikko.cal@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at fs/notify/notification.c:93!
References: <4A4F0FD4.7070009@gmail.com> <1246718455.20265.2.camel@dhcp235-23.rdu.redhat.com>
In-Reply-To: <1246718455.20265.2.camel@dhcp235-23.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
>
> This is the first time I've heard about it.  I'm looking for the problem
> but I don't see it right offhand.  Is there anything you know of that
> causes it?  I'm looking though....
>   

No, sorry - it seems very random to me. Most of the times the related 
process is krunner.
But sometimes it can be something else, for example firefox:

Jul  2 23:16:43 gentoo kernel BUG at 
fs/notify/notification.c:93!                                                            

Jul  2 23:16:43 gentoo invalid opcode: 0000 [#2] PREEMPT 
SMP                                                                
Jul  2 23:16:43 gentoo last sysfs file: 
/sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0/charge_full          

Jul  2 23:16:43 gentoo CPU 
0                                                                                                 

Jul  2 23:16:43 gentoo Modules linked in: radeon drm snd_seq 
snd_seq_device vfat fat coretemp hwmon cpufreq_ondemand fan iwl3945 
iwlcore usb_storage snd_hda_codec_idt snd_hda_intel mac80211 
snd_hda_codec led_class snd_pcm snd_timer snd cfg80211 soundcore 
snd_page_alloc dell_laptop psmouse rfkill ehci_hcd button battery ac 
thermal uhci_hcd evdev wmi                        
Jul  2 23:16:43 gentoo Pid: 5736, comm: firefox Tainted: G      D    
2.6.31-rc1 #2 MM061                                    
Jul  2 23:16:43 gentoo RIP: 0010:[<ffffffff810db63a>]  
[<ffffffff810db63a>] fsnotify_put_event+0x5a/0x60                    
Jul  2 23:16:43 gentoo RSP: 0018:ffff880063d7de58  EFLAGS: 
00010283                                                         
Jul  2 23:16:43 gentoo RAX: ffff88007faac258 RBX: ffff88007faac200 RCX: 
00007fa00dc5e820                                    
Jul  2 23:16:43 gentoo RDX: 0000000000000001 RSI: ffffffff8162bf50 RDI: 
ffff88007faac200                                    
Jul  2 23:16:43 gentoo RBP: 0000000000000020 R08: ffff880063d7c000 R09: 
ffff88006e27b828                                    
Jul  2 23:16:43 gentoo R10: 000000000000000a R11: 0000000000000000 R12: 
ffff88007faac200                                    
Jul  2 23:16:43 gentoo R13: 00007fa00dc5e800 R14: 0000000000000000 R15: 
ffff88007fab9cc0                                    
Jul  2 23:16:43 gentoo FS:  00007fa02cb0f700(0000) 
GS:ffff880001651000(0000) knlGS:0000000000000000                         
Jul  2 23:16:43 gentoo CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033                                                    
Jul  2 23:16:43 gentoo CR2: 00007fce069899c4 CR3: 0000000063d7b000 CR4: 
00000000000006f0                                    
Jul  2 23:16:43 gentoo DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000                                    
Jul  2 23:16:43 gentoo DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400                                    
Jul  2 23:16:43 gentoo Process firefox (pid: 5736, threadinfo 
ffff880063d7c000, task ffff88007f98a3c0)                      
Jul  2 23:16:43 gentoo 
Stack:                                                                                                

Jul  2 23:16:43 gentoo 0000000000000010 ffffffff810ddf35 
0000000000000400 00007fa00dc5e800                                  
Jul  2 23:16:43 gentoo <0> ffff880057737800 ffff88007fab9d18 
ffff88007fab9ce8 0000001080b907cc                              
Jul  2 23:16:43 gentoo <0> 0000000000000000 ffff88007f98a3c0 
ffffffff81051b90 ffff88007fab9d20                              
Jul  2 23:16:43 gentoo Call 
Trace:                                                                                           

Jul  2 23:16:43 gentoo [<ffffffff810ddf35>] ? 
inotify_read+0x2e5/0x310                                                       

Jul  2 23:16:43 gentoo [<ffffffff81051b90>] ? 
autoremove_wake_function+0x0/0x30                                              

Jul  2 23:16:43 gentoo [<ffffffff810ba30b>] ? 
do_vfs_ioctl+0x3fb/0x580                                                       

Jul  2 23:16:43 gentoo [<ffffffff810ac028>] ? 
vfs_read+0xc8/0x1a0                                                            

Jul  2 23:16:43 gentoo [<ffffffff810ac203>] ? 
sys_read+0x53/0xa0                                                             

Jul  2 23:16:43 gentoo [<ffffffff8100b3eb>] ? 
system_call_fastpath+0x16/0x1b                                                 

Jul  2 23:16:43 gentoo Code: ff 48 89 de 48 8b 3d 4e 08 55 00 5b e9 a0 
a7 fc ff 5b c3 66 0f 1f 44 00 00 48 8d 7f 28 e8 4f 8d fd ff 0f 1f 80 00 
00 00 00 eb c3 <0f> 0b eb fe 66 90 41 57 4c 8d 7f 28 41 56 41 55 41 54 
55 48 89                           
Jul  2 23:16:43 gentoo RIP  [<ffffffff810db63a>] 
fsnotify_put_event+0x5a/0x60                                               
Jul  2 23:16:43 gentoo RSP 
<ffff880063d7de58>                                                                                

Jul  2 23:16:43 gentoo ---[ end trace ac2beffdbb4340c9 ]---

Please let me know if you need more info.
