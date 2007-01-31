Return-Path: <linux-kernel-owner+w=401wt.eu-S933018AbXAaK5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbXAaK5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933011AbXAaK47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:56:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:49072 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933019AbXAaK46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:56:58 -0500
X-Authenticated: #14349625
Subject: 2.6.19.2 oops after resume from ram (corruption?)
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-eGtHCksWBsa9UGXGmwm/"
Date: Wed, 31 Jan 2007 11:56:48 +0100
Message-Id: <1170241008.6512.10.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eGtHCksWBsa9UGXGmwm/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Greetings,

I received the below upon first poke of firefox icon after a resume.  

See attachment (evolution refuses to inline it).

 BUG: unable to handle kernel NULL pointer dereference at virtual address 00000002
printing eip:
c109a7cf
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP 
Modules linked in: xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss eeprom snd_seq_midi snd_seq_midi_event snd_seq edd button battery ac ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat ip_nat iptable_filter ip6table_mangle ip_conntrack nfnetlink ip_tables ip6table_filter ip6_tables x_tables nls_iso8859_1 nls_cp437 nls_utf8 snd_mpu401 snd_mpu401_uart snd_rawmidi snd_seq_device ohci1394 ieee1394 prism54 snd_intel8x0 snd_ac97_codec snd_ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc intel_agp agpgart i2c_i801 sd_mod fan thermal processor
CPU:    0
EIP:    0060:[<c109a7cf>]    Not tainted VLI
EFLAGS: 00010246   (2.6.19.2-smp #90)
EIP is at inotify_inode_queue_event+0x51/0xd1
eax: c1599288   ebx: 00000fc6   ecx: 00000000   edx: 00000002
esi: c1599280   edi: fffffffa   ebp: ef38bf58   esp: ef38bf28
ds: 007b   es: 007b   ss: 0068
Process klauncher (pid: 6283, ti=ef38b000 task=dff91030 task.ti=ef38b000)
Stack: dfc998c0 c1e4f1c0 ef38bf58 00000000 00000020 f346ac68 00000000 0000000c 
       f346ac60 dba1cd50 f346cf70 f346ab28 ef38bf80 c109aea9 dba1cdb4 ec421998 
       00000000 00000020 dba1cd58 00000020 ea829000 0000000c ef38bfa8 c1070f3b 
Call Trace:
 [<c109aea9>] inotify_dentry_parent_queue_event+0x69/0xa0
 [<c1070f3b>] do_sys_open+0x83/0xc5
 [<c1070fb5>] sys_open+0x1c/0x1e
 [<c10030d9>] sysenter_past_esp+0x56/0x79
 [<b7f9f410>] 0xb7f9f410
 =======================
Code: 5e 5f 5d c3 8d 83 40 01 00 00 89 45 e4 e8 5a ee 2f 00 8b b3 38 01 00 00 83 ee 08 8b 56 08 8d 46 08 39 45 f0 74 69 8d 7a f8 eb 10 <8b> 57 08 8d 47 08 3b 45 f0 74 59 89 fe 8d 7a f8 8b 5e 20 85 5d 
EIP: [<c109a7cf>] inotify_inode_queue_event+0x51/0xd1 SS:ESP 0068:ef38bf28



--=-eGtHCksWBsa9UGXGmwm/
Content-Disposition: attachment; filename=2.6.19.2-oops
Content-Type: text/plain; name=2.6.19.2-oops; charset=us-ascii
Content-Transfer-Encoding: 8bit

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000002
printing eip:
c109a7cf
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP 
Modules linked in: xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss eeprom snd_seq_midi snd_seq_midi_event snd_seq edd button battery ac ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat ip_nat iptable_filter ip6table_mangle ip_conntrack nfnetlink ip_tables ip6table_filter ip6_tables x_tables nls_iso8859_1 nls_cp437 nls_utf8 snd_mpu401 snd_mpu401_uart snd_rawmidi snd_seq_device ohci1394 ieee1394 prism54 snd_intel8x0 snd_ac97_codec snd_ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc intel_agp agpgart i2c_i801 sd_mod fan thermal processor
CPU:    0
EIP:    0060:[<c109a7cf>]    Not tainted VLI
EFLAGS: 00010246   (2.6.19.2-smp #90)
EIP is at inotify_inode_queue_event+0x51/0xd1
eax: c1599288   ebx: 00000fc6   ecx: 00000000   edx: 00000002
esi: c1599280   edi: fffffffa   ebp: ef38bf58   esp: ef38bf28
ds: 007b   es: 007b   ss: 0068
Process klauncher (pid: 6283, ti=ef38b000 task=dff91030 task.ti=ef38b000)
Stack: dfc998c0 c1e4f1c0 ef38bf58 00000000 00000020 f346ac68 00000000 0000000c 
       f346ac60 dba1cd50 f346cf70 f346ab28 ef38bf80 c109aea9 dba1cdb4 ec421998 
       00000000 00000020 dba1cd58 00000020 ea829000 0000000c ef38bfa8 c1070f3b 
Call Trace:
 [<c109aea9>] inotify_dentry_parent_queue_event+0x69/0xa0
 [<c1070f3b>] do_sys_open+0x83/0xc5
 [<c1070fb5>] sys_open+0x1c/0x1e
 [<c10030d9>] sysenter_past_esp+0x56/0x79
 [<b7f9f410>] 0xb7f9f410
 =======================
Code: 5e 5f 5d c3 8d 83 40 01 00 00 89 45 e4 e8 5a ee 2f 00 8b b3 38 01 00 00 83 ee 08 8b 56 08 8d 46 08 39 45 f0 74 69 8d 7a f8 eb 10 <8b> 57 08 8d 47 08 3b 45 f0 74 59 89 fe 8d 7a f8 8b 5e 20 85 5d 
EIP: [<c109a7cf>] inotify_inode_queue_event+0x51/0xd1 SS:ESP 0068:ef38bf28

gdb vmlinux -core /proc/kcore

(gdb) list *inotify_inode_queue_event+0x51
0xc109a7cf is in inotify_inode_queue_event (fs/inotify.c:294).
289
290             if (!inotify_inode_watched(inode))
291                     return;
292
293             mutex_lock(&inode->inotify_mutex);
294             list_for_each_entry_safe(watch, next, &inode->inotify_watches, i_list) {
295                     u32 watch_mask = watch->mask;
296                     if (watch_mask & mask) {
297                             struct inotify_handle *ih= watch->ih;
298                             mutex_lock(&ih->mutex);
(gdb) x 0x8+0xc1599280
0xc1599288 <new_cpu_data+8>:    0x00000002
/me: new_cpu_data?
(gdb) x 0xc1599280+0x20
0xc15992a0 <new_cpu_data+32>:   0x00000fc6
(gdb) x 0xef38bf58
0xef38bf58:     0x00000000
(gdb) print new_cpu_data
$1 = {x86 = 15 '\017', x86_vendor = 151 '\227', x86_model = 2 '\002',
  x86_mask = 9 '\t', wp_works_ok = 88 'X', hlt_works_ok = -110 '\222',
  hard_math = 1 '\001', rfu = -63 '¿, cpuid_level = 2, x86_capability = {
    3219913727, 1, 3844256384, 4081494824, 4, 4038, 4145066816},
  x86_vendor_id = "GenuineIntelp\n¿,
  x86_model_id = "\001\000\000\000\200\"¿\n¿002\000\000\000¿017\000\000", '¿ <repeats 44 times>, x86_cache_size = -858993460,
  x86_cache_alignment = -858993460, fdiv_bug = -52 '¿, f00f_bug = -52 '¿,
  coma_bug = -52 '¿, pad0 = -52 '¿, x86_power = -858993460,
  loops_per_jiffy = 3435973836, llc_shared_map = {bits = {3435973836}},
  x86_max_cores = 204 '¿, apicid = 204 '¿, booted_cores = 204 '¿,
  phys_proc_id = 204 '¿, cpu_core_id = 204 '¿}
(gdb)
/me: ("G-e-n-u")... eject!

0000030e <inotify_inode_queue_event>:
 30e:	55                   	push   %ebp
 30f:	89 e5                	mov    %esp,%ebp
 311:	57                   	push   %edi
 312:	56                   	push   %esi
 313:	53                   	push   %ebx
 314:	83 ec 24             	sub    $0x24,%esp
 317:	89 c3                	mov    %eax,%ebx
 319:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
 31c:	89 4d dc             	mov    %ecx,0xffffffdc(%ebp)
 31f:	8d 80 38 01 00 00    	lea    0x138(%eax),%eax
 325:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
 328:	3b 83 38 01 00 00    	cmp    0x138(%ebx),%eax
 32e:	75 08                	jne    338 <inotify_inode_queue_event+0x2a>
 330:	83 c4 24             	add    $0x24,%esp
 333:	5b                   	pop    %ebx
 334:	5e                   	pop    %esi
 335:	5f                   	pop    %edi
 336:	5d                   	pop    %ebp
 337:	c3                   	ret    
 338:	8d 83 40 01 00 00    	lea    0x140(%ebx),%eax
 33e:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
 341:	e8 fc ff ff ff       	call   342 <inotify_inode_queue_event+0x34>
 346:	8b b3 38 01 00 00    	mov    0x138(%ebx),%esi
 34c:	83 ee 08             	sub    $0x8,%esi
 34f:	8b 56 08             	mov    0x8(%esi),%edx
 352:	8d 46 08             	lea    0x8(%esi),%eax
 355:	39 45 f0             	cmp    %eax,0xfffffff0(%ebp)
 358:	74 69                	je     3c3 <inotify_inode_queue_event+0xb5>
 35a:	8d 7a f8             	lea    0xfffffff8(%edx),%edi
 35d:	eb 10                	jmp    36f <inotify_inode_queue_event+0x61>
 35f:	8b 57 08             	mov    0x8(%edi),%edx <=== boom
 362:	8d 47 08             	lea    0x8(%edi),%eax
 365:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
 368:	74 59                	je     3c3 <inotify_inode_queue_event+0xb5>
 36a:	89 fe                	mov    %edi,%esi
 36c:	8d 7a f8             	lea    0xfffffff8(%edx),%edi
 36f:	8b 5e 20             	mov    0x20(%esi),%ebx
 372:	85 5d e0             	test   %ebx,0xffffffe0(%ebp)
 375:	74 e8                	je     35f <inotify_inode_queue_event+0x51>
 377:	8b 46 14             	mov    0x14(%esi),%eax
 37a:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
 37d:	83 c0 18             	add    $0x18,%eax
 380:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
 383:	e8 fc ff ff ff       	call   384 <inotify_inode_queue_event+0x76>
 388:	85 db                	test   %ebx,%ebx
 38a:	78 47                	js     3d3 <inotify_inode_queue_event+0xc5>
 38c:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
 38f:	8b 58 3c             	mov    0x3c(%eax),%ebx
 392:	8b 56 1c             	mov    0x1c(%esi),%edx
 395:	8b 45 0c             	mov    0xc(%ebp),%eax
 398:	89 44 24 08          	mov    %eax,0x8(%esp)
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a3:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
 3a6:	89 04 24             	mov    %eax,(%esp)
 3a9:	8b 4d e0             	mov    0xffffffe0(%ebp),%ecx
 3ac:	89 f0                	mov    %esi,%eax
 3ae:	ff 13                	call   *(%ebx)
 3b0:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
 3b3:	e8 fc ff ff ff       	call   3b4 <inotify_inode_queue_event+0xa6>
 3b8:	8b 57 08             	mov    0x8(%edi),%edx
 3bb:	8d 47 08             	lea    0x8(%edi),%eax
 3be:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
 3c1:	75 a7                	jne    36a <inotify_inode_queue_event+0x5c>
 3c3:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
 3c6:	e8 fc ff ff ff       	call   3c7 <inotify_inode_queue_event+0xb9>
 3cb:	83 c4 24             	add    $0x24,%esp
 3ce:	5b                   	pop    %ebx
 3cf:	5e                   	pop    %esi
 3d0:	5f                   	pop    %edi
 3d1:	5d                   	pop    %ebp
 3d2:	c3                   	ret    
 3d3:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
 3d6:	89 f0                	mov    %esi,%eax
 3d8:	e8 cd fe ff ff       	call   2aa <remove_watch_no_event>
 3dd:	eb ad                	jmp    38c <inotify_inode_queue_event+0x7e>

--=-eGtHCksWBsa9UGXGmwm/--

