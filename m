Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbXCaSte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbXCaSte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 14:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXCaSte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 14:49:34 -0400
Received: from calisto.ae.poznan.pl ([150.254.37.3]:51474 "EHLO
	calisto.ae.poznan.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbXCaStd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 14:49:33 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Mar 2007 14:49:33 EDT
Message-ID: <460EAC2A.8080706@dns.toxicfilms.tv>
Date: Sat, 31 Mar 2007 20:44:58 +0200
From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.20.4 crashes
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here's more...

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
00000000
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: binfmt_misc sit nfs lockd nfs_acl sunrpc ipt_ECN iptable_mangle w83627ehf i2c_isa i2c_viapro i2c_core via_agp agpgart rtc
CPU:    0
EIP:    0060:[<00000000>]    Not tainted VLI
EFLAGS: 00010016   (2.6.20.3-cks1 #4)
EIP is at 0x0
eax: e94a5e6c   ebx: e94a5e6c   ecx: 00000000   edx: 00000001
esi: 00000000   edi: e94a5e84   ebp: e94a5e6c   esp: e94a5e4c
ds: 007b   es: 007b   ss: 0068
Process grep (pid: 9156, ti=e94a4000 task=f4569a90 task.ti=e94a4000)
Stack: c0116429 00000000 00000001 00000001 ec7da800 00000000 00000286 00000000 
       e94a5e84 c0117802 00000000 00000000 ec7da800 ec7da800 ec7da85c c015c622 
       00000000 e9d02b40 e94a5f60 f77b6ac0 00000000 00000400 c0313e6c 00001000 
Call Trace:
 [<c0116429>] __wake_up_common+0x39/0x70
 [<c0117802>] __wake_up+0x22/0x30
 [<c015c622>] pipe_write+0x222/0x4b0
 [<c0156887>] do_sync_write+0xc7/0x110
 [<c012b5c0>] autoremove_wake_function+0x0/0x50
 [<c0157156>] vfs_write+0xa6/0x160
 [<c01567c0>] do_sync_write+0x0/0x110
 [<c0157781>] sys_write+0x41/0x70
 [<c0102ed6>] sysenter_past_esp+0x5f/0x85
 [<c0300033>] ipv6_flowlabel_opt+0x193/0x730
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:e94a5e4c
 <3>BUG: sleeping function called from invalid context at kernel/rwsem.c:20
in_atomic():0, irqs_disabled():1
 [<c012e432>] down_read+0x12/0x20
 [<c01367b8>] acct_collect+0x38/0x120
 [<c011cc7a>] do_exit+0xda/0x750
 [<c011ab1b>] printk+0x1b/0x20
 [<c0104380>] do_trap+0x0/0x100
 [<c011533a>] do_page_fault+0x2da/0x630
 [<c0115060>] do_page_fault+0x0/0x630
 [<c030e5a4>] error_code+0x74/0x7c
 [<c0116429>] __wake_up_common+0x39/0x70
 [<c0117802>] __wake_up+0x22/0x30
 [<c015c622>] pipe_write+0x222/0x4b0
 [<c0156887>] do_sync_write+0xc7/0x110
 [<c012b5c0>] autoremove_wake_function+0x0/0x50
 [<c0157156>] vfs_write+0xa6/0x160
 [<c01567c0>] do_sync_write+0x0/0x110
 [<c0157781>] sys_write+0x41/0x70
 [<c0102ed6>] sysenter_past_esp+0x5f/0x85
 [<c0300033>] ipv6_flowlabel_opt+0x193/0x730
 =======================
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
00000000
*pde = 00000000
Oops: 0000 [#2]
Modules linked in: binfmt_misc sit nfs lockd nfs_acl sunrpc ipt_ECN iptable_mangle w83627ehf i2c_isa i2c_viapro i2c_core via_agp agpgart rtc
CPU:    0
EIP:    0060:[<00000000>]    Not tainted VLI
EFLAGS: 00010087   (2.6.20.3-cks1 #4)
EIP is at 0x0
eax: e94a5e6c   ebx: e94a5e6c   ecx: 00000000   edx: 00000001
esi: 00000000   edi: e94a5e84   ebp: e94a5ccc   esp: e94a5cac
ds: 007b   es: 007b   ss: 0068
Process grep (pid: 9156, ti=e94a4000 task=f4569a90 task.ti=e94a4000)
Stack: c0116429 00000000 00000001 00000001 ec7da800 00000000 00000286 ec7da800 
       e94a5ce4 c0117802 00000000 00000000 00000000 00000001 e9d02ad4 c015c069 
       00000000 e9d02b40 00000008 00000000 e9d02ad4 f77b6ac0 c0157b20 00000000 
Call Trace:
 [<c0116429>] __wake_up_common+0x39/0x70
 [<c0117802>] __wake_up+0x22/0x30
 [<c015c069>] pipe_release+0x59/0xb0
 [<c0157b20>] __fput+0xb0/0x180
 [<c0154ff7>] filp_close+0x47/0x80
 [<c011bcbc>] put_files_struct+0x9c/0xb0
 [<c011ccb5>] do_exit+0x115/0x750
 [<c011ab1b>] printk+0x1b/0x20
 [<c0104380>] do_trap+0x0/0x100
 [<c011533a>] do_page_fault+0x2da/0x630
 [<c0115060>] do_page_fault+0x0/0x630
 [<c030e5a4>] error_code+0x74/0x7c
 [<c0116429>] __wake_up_common+0x39/0x70
 [<c0117802>] __wake_up+0x22/0x30
 [<c015c622>] pipe_write+0x222/0x4b0
 [<c0156887>] do_sync_write+0xc7/0x110
 [<c012b5c0>] autoremove_wake_function+0x0/0x50
 [<c0157156>] vfs_write+0xa6/0x160
 [<c01567c0>] do_sync_write+0x0/0x110
 [<c0157781>] sys_write+0x41/0x70
 [<c0102ed6>] sysenter_past_esp+0x5f/0x85
 [<c0300033>] ipv6_flowlabel_opt+0x193/0x730
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:e94a5cac
 <1>Fixing recursive fault but reboot is needed!


