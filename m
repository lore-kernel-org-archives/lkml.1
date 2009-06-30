Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZF3HK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZF3HK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 03:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZF3HKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 03:10:20 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:36678 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488AbZF3HKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 03:10:19 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3
To: linux-kernel@vger.kernel.org
from: aeriksson2@gmail.com
Subject: 2.6.29.5 oops
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 30 Jun 2009 09:10:09 +0200
Message-Id: <20090630071009.B4E4F33C0ED@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.236.9
X-Scan-Result: No virus found in message 1MLXTo-0000wo-8R.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1MLXTo-0000wo-8R fc32c964a97ad52ea35e675dfbe67e7c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One of my machines was found dead this morning. Looking at the logs picked up
by another machine, I found this:

Jun 30 00:05:52 tv BUG: unable to handle kernel paging request at 0007a2cd
Jun 30 00:05:52 tv IP: [<c021dc80>] 0xc021dc80
Jun 30 00:05:52 tv *pde = 00000000 
Jun 30 00:05:52 tv Oops: 0000 [#1] SMP 
Jun 30 00:05:52 tv ?z?{?z ?z?z?z?zz?z??{ ?{?{?z?z?!?{?{?|?}?}?}?|?|?{{?|?{?|?{?}?}?}?}?~?}?}?~?
Jun 30 00:05:52 tv ~??
                      ?~? }?
                            ???}}?}?|?|?z?z? ?z'?0|+?!}?}?|
                                                           ?
                                                            ~? ?
                                                                ?|%?-}+?0|0?'|?|?%{&?-xB?_sn?Ut>?Kue?|z{?[}C?4v.?0w0?+x&?'z&?'~*?+?.?.?3?4?
/?+?-?&?(?'?#?~?{ ?z?x?y?#z,?5~<?@?>?P?g?W?M?B?/?(?(?+?/?/~/?/{-?+y+?.y2?/y,?-x0?.x-?-x*?,x-?-x,?&y%?c050667c'?(y%?"x#?"y&?"x?x%?(y)?,y1?)x
 ?)x*?)y$?'y)?*y/?,y/?-x-?.w-?1w3?-x$?&x:?Bx??AwA?CwI?LwI?EwG?PvK?LuJ?EsI?KtN?LrJ?LtK?LtJ?Ot]?]tc?bti?mtd?lvd?Pw[??w?u???l?k?k?j?j?i?h?f?g?
 ?g?h?h?h???f???e?e?g??wjn?fmU?PpI?Cq??7q5?6q0?-q;?7p1?-p1?4o1?0o3?5o5?3o0?4o3?1o4?3p3?7p6?1p1?1q0?/q1?1p3?5p3?3p5?3p5?3p.?.p5?6o5?4p3?2p4?
0?1p3?2p0?,q-?.o1?/q+?)q-?.q.?-q-?-q-?/q1?-q.?.q1?3q.?)r(?*r,?.s,?&s&?(q+?-q,?*q)?,r.?+q*?(r(?.r0?*r*?(s(?(s)?*s'?)r(?'s(?'s'?d?blocknr]: b
it already clearedModules linked in: radeon drm hid_sunplus usbhid nfs it87 hwmon_vid bnep rfcomm l2cap nfsd lockd sunrpc exportfs ipv6 saa
7134_alsa tda1004x saa7134_dvb firmware_class videobuf_dvb dvb_core ir_kbd_i2c lirc_imon lirc_dev btusb tda827x snd_hda_codec_atihdmi tda82
90 snd_hda_codec_realtek tuner saa7134 ir_common v4l2_common videodev v4l1_compat ohci1394 videobuf_dma_sg videobuf_core ieee1394 tveeprom 
parport_pc i2c_piix4 r8169 snd_hda_intel ohci_hcd floppy sg k8temp rtc_cmos mii snd_hda_codec atiixp rtc_core parport pcspkr ati_agp agpgar
t rtc_lib
Jun 30 00:05:52 tv 
Jun 30 00:05:52 tv Pid: 5547, comm: lcdproc Not tainted (2.6.29.5 #1) System Product Name
Jun 30 00:05:52 tv EIP: 0060:[<c021dc80>] EFLAGS: 00010297 CPU: 1
Jun 30 00:05:52 tv EAX: 0007a2cd EBX: f6031688 ECX: 0007a2cd EDX: fffffffe
Jun 30 00:05:52 tv ESI: 0007a2cd EDI: ffffffff EBP: f6032000 ESP: f600fcd4
Jun 30 00:05:52 tv DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jun 30 00:05:52 tv Process lcdproc (pid: 5547, ti=f600f000 task=f71378e0 task.ti=f600f000)
Jun 30 00:05:52 tv Stack:
Jun 30 00:05:52 tv c021ce61 f600fd88 f600fd84 c04bff5c 00000000 c021d194 ffffffff ffffffff
Jun 30 00:05:52 tv 00000000 f600fd4c c03e15fb 00001000 f6031000 00000000 f6031688 f6032000
Jun 30 00:05:52 tv ffffffff ffffffff ffffffff f600fd84 00000000 f600fd7c c03e102d 00000cab
Jun 30 00:05:52 tv Call Trace:
Jun 30 00:05:52 tv [<c021ce61>] 0xc021ce61
Jun 30 00:05:52 tv [<c021d194>] 0xc021d194
Jun 30 00:05:52 tv [<c0180571>] 0xc0180571
Jun 30 00:05:52 tv [<c019e809>] 0xc019e809
Jun 30 00:05:52 tv [<c03219e6>] 0xc03219e6
Jun 30 00:05:52 tv [<c016d9df>] 0xc016d9df
Jun 30 00:05:52 tv [<c038af32>] 0xc038af32
Jun 30 00:05:52 tv [<c018080c>] 0xc018080c
Jun 30 00:05:52 tv [<c01806ac>] 0xc01806ac
Jun 30 00:05:52 tv [<c019937c>] 0xc019937c
Jun 30 00:05:52 tv [<c0199324>] 0xc0199324
Jun 30 00:05:52 tv [<c016e247>] 0xc016e247
Jun 30 00:05:52 tv [<c016e352>] 0xc016e352
Jun 30 00:05:52 tv [<c0102c81>] 0xc0102c81
Jun 30 00:05:52 tv Code: 0e 89 c7 89 d0 f2 ae 74 05 bf 01 00 00 00 4f 89 f8 5f c3 85 c9 57 89 c7 89 d0 74 05 f2 ae 75 01 4f 89 f8 5f c3 89 
c1 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 c3 90 55 89 d5 57 56 
Jun 30 00:05:52 tv EIP: [<c021dc80>]  SS:ESP 0068:f600fcd4
Jun 30 00:05:52 tv ---[ end trace 423b4bc611ce6147 ]---


I have no idea where that garbage at the top came from. Runing it though 
ksymoops yields:
>>EIP; c021dc80 <strnlen+6/16>   <=====

Trace; c021ce61 <string+27/6d>
Trace; c021d194 <vsnprintf+2ed/731>
Trace; c0180571 <seq_printf+25/41>
Trace; c019e809 <show_stat+42d/740>
Trace; c03219e6 <sock_aio_read+ec/fa>
Trace; c016d9df <do_sync_read+c0/107>
Trace; c038af32 <__mutex_lock_slowpath+1e4/1ec>
Trace; c018080c <seq_read+160/327>
Trace; c01806ac <seq_read+0/327>
Trace; c019937c <proc_reg_read+58/6b>
Trace; c0199324 <proc_reg_read+0/6b>
Trace; c016e247 <vfs_read+81/f4>
Trace; c016e352 <sys_read+3c/63>
Trace; c0102c81 <sysenter_do_call+12/21>

Code;  c021dc80 <strnlen+6/16>
00000000 <_EIP>:
Code;  c021dc80 <strnlen+6/16>   <=====
   0:   0e                        push   %cs   <=====
Code;  c021dc81 <strnlen+7/16>
   1:   89 c7                     mov    %eax,%edi
Code;  c021dc83 <strnlen+9/16>
   3:   89 d0                     mov    %edx,%eax
Code;  c021dc85 <strnlen+b/16>
   5:   f2 ae                     repnz scas %es:(%edi),%al
Code;  c021dc87 <strnlen+d/16>
   7:   74 05                     je     e <_EIP+0xe>
Code;  c021dc89 <strnlen+f/16>
   9:   bf 01 00 00 00            mov    $0x1,%edi
Code;  c021dc8e <strnlen+14/16>
   e:   4f                        dec    %edi
Code;  c021dc8f <strnlen+15/16>
   f:   89 f8                     mov    %edi,%eax
Code;  c021dc91 <strstr+1/34>
  11:   5f                        pop    %edi
Code;  c021dc92 <strstr+2/34>
  12:   c3                        ret    
Code;  c021dc93 <strstr+3/34>
  13:   85 c9                     test   %ecx,%ecx
Code;  c021dc95 <strstr+5/34>
  15:   57                        push   %edi
Code;  c021dc96 <strstr+6/34>
  16:   89 c7                     mov    %eax,%edi
Code;  c021dc98 <strstr+8/34>
  18:   89 d0                     mov    %edx,%eax
Code;  c021dc9a <strstr+a/34>
  1a:   74 05                     je     21 <_EIP+0x21>
Code;  c021dc9c <strstr+c/34>
  1c:   f2 ae                     repnz scas %es:(%edi),%al
Code;  c021dc9e <strstr+e/34>
  1e:   75 01                     jne    21 <_EIP+0x21>
Code;  c021dca0 <strstr+10/34>
  20:   4f                        dec    %edi
Code;  c021dca1 <strstr+11/34>
  21:   89 f8                     mov    %edi,%eax
Code;  c021dca3 <strstr+13/34>
  23:   5f                        pop    %edi
Code;  c021dca4 <strstr+14/34>
  24:   c3                        ret    
Code;  c021dca5 <strstr+15/34>
  25:   89 00                     mov    %eax,(%eax)

Jun 30 00:05:52 tv EIP: [<c021dc80>]  SS:ESP 0068:f600fcd4


Any ideas what happened?

/Anders


