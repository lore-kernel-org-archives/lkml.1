Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbZBISbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbZBISbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZBISbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:31:25 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:43058 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812AbZBISbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:31:22 -0500
Date: Mon, 9 Feb 2009 18:26:32 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org
Message-ID: <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk>
In-Reply-To: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux@youmustbejoking.demon.co.uk
User-Agent: Gemini/2.29m (Qt/3.3.8b) (Linux-x86_64)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2095223807--1359088538--1840572005"
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
Subject: Oopses and ACPI problems (Linus 2.6.29-rc4)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on pentagram.youmustbejoking.demon.co.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format.

--2095223807--1359088538--1840572005
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

I'm seeing various oopses with -rc4, where -rc3 is fine; config, dmesg
(captured via netconsole) and decoded oops data attached =B9. The last fe=
w
oopses were followed by a scrambled display and a hard lockup.

All oopses follow an otherwise successful suspend-to-RAM.

Also, I see that Fn-Fx don't seem to be reported via /proc/acpi/events an=
y
more, or at least I'm seeing no evidence of them via acpi_listen (and, no=
t
coincidentally, I can't adjust the volume etc. via eeepc-acpi-scripts).

The only other (significant) change is that I've installed X from Debian
experimental, though -rc3 and 2.6.28.* seem fine with this. (Oh, and I ca=
n
get UXA to cause OOM quite trivially... several Iceweasel tabs is enough.=
)


=B9 Yes, I decided not to include symbol names in the running kernel...

--=20
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Use more efficient products. Use less.          BE MORE ENERGY EFFICI=
ENT.

I'll have what the bloke on the floor is having...


--2095223807--1359088538--1840572005
Content-Type: application/x-gzip; name="config-eee901.gz"
Content-Disposition: attachment; filename="config-eee901.gz"
Content-Transfer-Encoding: base64

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

--2095223807--1359088538--1840572005
Content-Type: text/plain; name="eee-oops.txt"
Content-Disposition: attachment; filename="eee-oops.txt"
Content-Transfer-Encoding: quoted-printable

ksymoops 2.4.11 on i686 2.6.29-rc4-eee901.  Options used=0A=
     -V (default)=0A=
     -k /proc/ksyms (default)=0A=
     -l /proc/modules (default)=0A=
     -o /lib/modules/2.6.29-rc4-eee901/ (default)=0A=
     -m /boot/System.map-2.6.29-rc4-eee901 (default)=0A=
=0A=
Warning: You did not tell me where to find symbol information.  I will=0A=
assume that the log matches the kernel and modules that are running=0A=
right now and I'll use the default options above for symbol resolution.=0A=
If the current kernel and/or modules do not match the log, you can get=0A=
more accurate output by telling me the kernel version and where to find=0A=
map, modules, ksyms etc.  ksymoops -h explains the options.=0A=
=0A=
Error (regular_file): read_ksyms stat /proc/ksyms failed=0A=
No modules in ksyms, skipping objects=0A=
No ksyms, skipping lsmod=0A=
CPU 1 is now offline=0A=
WARNING: at fs/sysfs/group.c:138 ()=0A=
Pid: 330, comm: pciehpd Not tainted 2.6.29-rc4-eee901 #2=0A=
Call Trace:=0A=
 [<c011fab7>] 0xc011fab7=0A=
 [<c032ca9d>] 0xc032ca9d=0A=
 [<f81760d5>] 0xf81760d5=0A=
 [<c01f112c>] 0xc01f112c=0A=
 [<c0118940>] 0xc0118940=0A=
 [<c011fc82>] 0xc011fc82=0A=
 [<c016b8aa>] 0xc016b8aa=0A=
 [<c0190b6b>] 0xc0190b6b=0A=
 [<c016b9a8>] 0xc016b9a8=0A=
 [<c016b738>] 0xc016b738=0A=
 [<c019102a>] 0xc019102a=0A=
 [<c0191faa>] 0xc0191faa=0A=
 [<c025a8d4>] 0xc025a8d4=0A=
 [<c025a9c9>] 0xc025a9c9=0A=
 [<c01fae3c>] 0xc01fae3c=0A=
 [<c01faf00>] 0xc01faf00=0A=
 [<c0205ca4>] 0xc0205ca4=0A=
 [<c0204a68>] 0xc0204a68=0A=
 [<c0204eb3>] 0xc0204eb3=0A=
 [<c0204e2d>] 0xc0204e2d=0A=
 [<c012bd8f>] 0xc012bd8f=0A=
 [<c012c51d>] 0xc012c51d=0A=
 [<c012c5d1>] 0xc012c5d1=0A=
 [<c012e9ac>] 0xc012e9ac=0A=
 [<c012c51d>] 0xc012c51d=0A=
 [<c012e8de>] 0xc012e8de=0A=
 [<c012e8a6>] 0xc012e8a6=0A=
 [<c010349b>] 0xc010349b=0A=
BUG: unable to handle kernel NULL pointer dereference at 00000010=0A=
*pde =3D 00000000=20=0A=
Oops: 0000 [#1] PREEMPT SMP=20=0A=
Pid: 330, comm: pciehpd Tainted: G        W  (2.6.29-rc4-eee901 #2) 901=0A=
EIP: 0060:[<c03ccef7>] EFLAGS: 00010246 CPU: 0=0A=
Using defaults from ksymoops -t elf32-i386 -a i386=0A=
EAX: 00000000 EBX: 00000001 ECX: 00000046 EDX: 00000001=0A=
ESI: f17dd470 EDI: f70f7c5c EBP: 00000000 ESP: f7339f00=0A=
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068=0A=
 f17dd45c 00000000 f70f7c5c c025a9c9 f7060b40 f7311a80ff 83 c0 89 83 cf d=
b 74 19 f6 06 01 74 11 6a 00 ---[ end trace 449537779ba90603 ]---=0A=
Warning (Oops_read): Code line not seen, dumping what data is available=0A=
=0A=
=0A=
Trace; c011fab7 <warn_slowpath+7d/94>=0A=
Trace; c032ca9d <__alloc_skb+4b/103>=0A=
Trace; f81760d5 <END_OF_CODE+37c160d5/????>=0A=
Trace; c01f112c <cpumask_next_and+23/33>=0A=
Trace; c0118940 <find_busiest_group+242/725>=0A=
Trace; c011fc82 <__call_console_drivers+51/5d>=0A=
Trace; c016b8aa <find_inode+1b/56>=0A=
Trace; c0190b6b <sysfs_ilookup_test+0/d>=0A=
Trace; c016b9a8 <ifind+3a/74>=0A=
Trace; c016b738 <iput+21/4a>=0A=
Trace; c019102a <sysfs_addrm_finish+4a/1ae>=0A=
Trace; c0191faa <sysfs_remove_group+34/8d>=0A=
Trace; c025a8d4 <device_del+32/11f>=0A=
Trace; c025a9c9 <device_unregister+8/10>=0A=
Trace; c01fae3c <pci_stop_dev+20/3a>=0A=
Trace; c01faf00 <pci_remove_bus_device+27/88>=0A=
Trace; c0205ca4 <pciehp_unconfigure_device+108/180>=0A=
Trace; c0204a68 <pciehp_disable_slot+12d/1d6>=0A=
Trace; c0204eb3 <pciehp_power_thread+86/cd>=0A=
Trace; c0204e2d <pciehp_power_thread+0/cd>=0A=
Trace; c012bd8f <run_workqueue+71/f1>=0A=
Trace; c012c51d <worker_thread+0/bf>=0A=
Trace; c012c5d1 <worker_thread+b4/bf>=0A=
Trace; c012e9ac <autoremove_wake_function+0/2b>=0A=
Trace; c012c51d <worker_thread+0/bf>=0A=
Trace; c012e8de <kthread+38/5e>=0A=
Trace; c012e8a6 <kthread+0/5e>=0A=
Trace; c010349b <kernel_thread_helper+7/10>=0A=
=0A=
>>EIP; c03ccef7 <klist_put+f/59>   <=3D=3D=3D=3D=3D=0A=
=0A=
BUG: unable to handle kernel paging request at 7a9d5f5c=0A=
*pde =3D 00000000=20=0A=
Oops: 0000 [#2] PREEMPT SMP=20=0A=
Pid: 4094, comm: bash Tainted: G      D W  (2.6.29-rc4-eee901 #2) 901=0A=
EIP: 0060:[<c015bb0a>] EFLAGS: 00010006 CPU: 1=0A=
EAX: 00000000 EBX: c04c7d90 ECX: 7a9d5f5c EDX: c180ff6c=0A=
ESI: 00000282 EDI: c04c7d90 EBP: 00000040 ESP: ee9f1e38=0A=
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068=0A=
 7a9d5f5c 000080d0 f173f7c0 c194c488 7ac532a8 fe280a2e c194c488 c0194004=0A=
 f173f7c0 c194c488 f6e64498 0000003e f6e02458 c019aaa0 c194c488 00000000=0A=
 ee949600 c194cff8 00000000 ee949600 ee949600 f6e02458 00000000 c019ab55=0A=
Call Trace:=0A=
 [<c0194004>] 0xc0194004=0A=
 [<c019aaa0>] 0xc019aaa0=0A=
 [<c019ab55>] 0xc019ab55=0A=
 [<c01405ce>] 0xc01405ce=0A=
 [<c0102cf1>] 0xc0102cf1=0A=
56 BUG: unable to handle kernel paging request at 7a9d5f5c=0A=
*pde =3D 00000000=20=0A=
Oops: 0000 [#3] PREEMPT SMP=20=0A=
Pid: 3147, comm: xfce4-systemloa Tainted: G      D W  (2.6.29-rc4-eee901 =
#2) 901=0A=
EIP: 0060:[<c015b4e5>] EFLAGS: 00010006 CPU: 1=0A=
EAX: 00000000 EBX: 00000292 ECX: 7a9d5f5c EDX: c180ff6c=0A=
ESI: 00000040 EDI: c018d53c EBP: c04c7d90 ESP: f16ebe34=0A=
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068=0A=
 7a9d5f5c 000000d0 f702c00a ee949300 f73e35e0 c018d53c 00000000 c017059b=0A=
 00000000 f73e35e0 fffffff4 c018d53c ee949300 c0170678 00000000 f7029000=0A=
 fffffff4 00001000 ee949300 c018d51e f173f2a0 f70e9680 c018d4d0 f70e96cc=0A=
Call Trace:=0A=
 [<c018d53c>] 0xc018d53c=0A=
 [<c017059b>] 0xc017059b=0A=
 [<c018d53c>] 0xc018d53c=0A=
 [<c0170678>] 0xc0170678=0A=
 [<c018d51e>] 0xc018d51e=0A=
 [<c018d4d0>] 0xc018d4d0=0A=
 [<c01887b8>] 0xc01887b8=0A=
 [<c017006d>] 0xc017006d=0A=
 [<c012e9ac>] 0xc012e9ac=0A=
 [<c0102cf1>] 0xc0102cf1=0A=
BUG: unable to handle kernel paging request at 7a9d5f5c=0A=
*pde =3D 00000000=20=0A=
Oops: 0000 [#4] PREEMPT SMP=20=0A=
Pid: 3137, comm: xfce4-panel Tainted: G      D W  (2.6.29-rc4-eee901 #2) =
901=0A=
EIP: 0060:[<c015b4e5>] EFLAGS: 00010006 CPU: 1=0A=
EAX: 00000000 EBX: 00000296 ECX: 7a9d5f5c EDX: c180ff6c=0A=
ESI: 00000040 EDI: ee939f7c EBP: c04c7d90 ESP: f1653ecc=0A=
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068=0A=
 7a9d5f5c 000000d0 00000000 ee814440 00000000 ee939f7c 01200011 c012c900=0A=
 ee938380 eea4fff8 c048d53c ee814440 c0101a87 01200011 ee814440 00000000=0A=
 ee939f7c ee814440 00000000 ee939f7c 01200011 c011e9cb f1653fb8 bf9e8d30=0A=
Call Trace:=0A=
 [<c012c900>] 0xc012c900=0A=
 [<c0101a87>] 0xc0101a87=0A=
 [<c011e9cb>] 0xc011e9cb=0A=
 [<c011f085>] 0xc011f085=0A=
eb BUG: unable to handle kernel paging request at 7a9d5f5c=0A=
*pde =3D 00000000=20=0A=
Oops: 0000 [#5] PREEMPT SMP=20=0A=
Pid: 2942, comm: Xorg Tainted: G      D W  (2.6.29-rc4-eee901 #2) 901=0A=
EIP: 0060:[<c015bb0a>] EFLAGS: 00213006 CPU: 1=0A=
EAX: 00000000 EBX: c04c7d90 ECX: 7a9d5f5c EDX: c180ff6c=0A=
ESI: 00203282 EDI: c04c7d90 EBP: 00000040 ESP: f68adef4=0A=
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068=0A=
 7a9d5f5c 000000d0 00203286 00000000 fffffff4 40286454 f6a86800 f81ea6f4=0A=
 f6b2d420 f8348c59 f83583e4 f6950080 bfbc1eb4 40286454 c0167680 bfbc1eb4=0A=
 f6950080 f6f1e7f8 08a84b40 f68ac000 c0167bb4 0000000d 00203082 f68adf9c=0A=
Call Trace:=0A=
 [<f81ea6f4>] 0xf81ea6f4=0A=
 [<f8348c59>] 0xf8348c59=0A=
 [<c0167680>] 0xc0167680=0A=
 [<c0167bb4>] 0xc0167bb4=0A=
 [<c0122ac3>] 0xc0122ac3=0A=
 [<c0122c59>] 0xc0122c59=0A=
f4 BUG: unable to handle kernel paging request at 7a9d5f5c=0A=
*pde =3D 00000000=20=0A=
Oops: 0000 [#6] PREEMPT SMP=20=0A=
Pid: 1219, comm: udevd Tainted: G      D W  (2.6.29-rc4-eee901 #2) 901=0A=
EIP: 0060:[<c015b4e5>] EFLAGS: 00010006 CPU: 1=0A=
EAX: 00000000 EBX: 00000292 ECX: 7a9d5f5c EDX: c180ff6c=0A=
ESI: 00000040 EDI: c018d53c EBP: c04c7d90 ESP: f68fbe34=0A=
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068=0A=
 7a9d5f5c 000000d0 f708c00a ee949c80 f73e3720 c018d53c 00000000 c017059b=0A=
 f6c12964 f73e3720 fffffff4 c018d53c ee949c80 c0170678 00000000 f708e000=0A=
 fffffff4 00001000 ee949c80 c018d51e f173fa20 f70e9680 c018d4d0 f70e96cc=0A=
Call Trace:=0A=
 [<c018d53c>] 0xc018d53c=0A=
 [<c017059b>] 0xc017059b=0A=
 [<c018d53c>] 0xc018d53c=0A=
 [<c0170678>] 0xc0170678=0A=
Warning (Oops_read): Code line not seen, dumping what data is available=0A=
=0A=
=0A=
>>EIP; c015bb0a <__kmalloc+83/c0>   <=3D=3D=3D=3D=3D=0A=
=0A=
>>EBX; c04c7d90 <kmalloc_caches+210/480>=0A=
>>ECX; 7a9d5f5c <phys_startup_32+7a8d5f5c/c0000000>=0A=
>>EDI; c04c7d90 <kmalloc_caches+210/480>=0A=
=0A=
Trace; c0194004 <ext3_htree_store_dirent+26/de>=0A=
Trace; c019aaa0 <htree_dirblock_to_tree+d6/11b>=0A=
Trace; c019ab55 <ext3_htree_fill_tree+70/1cb>=0A=
Trace; c01405ce <find_lock_page+10/43>=0A=
Trace; c0102cf1 <sysenter_do_call+12/25>=0A=
=0A=
>>EIP; c015b4e5 <kmem_cache_alloc+48/83>   <=3D=3D=3D=3D=3D=0A=
=0A=
>>ECX; 7a9d5f5c <phys_startup_32+7a8d5f5c/c0000000>=0A=
>>EDI; c018d53c <show_stat+0/680>=0A=
>>EBP; c04c7d90 <kmalloc_caches+210/480>=0A=
=0A=
Trace; c018d53c <show_stat+0/680>=0A=
Trace; c017059b <seq_open+23/6d>=0A=
Trace; c018d53c <show_stat+0/680>=0A=
Trace; c0170678 <single_open+48/68>=0A=
Trace; c018d51e <stat_open+4e/6c>=0A=
Trace; c018d4d0 <stat_open+0/6c>=0A=
Trace; c01887b8 <proc_reg_open+89/ed>=0A=
Trace; c017006d <single_release+0/1b>=0A=
Trace; c012e9ac <autoremove_wake_function+0/2b>=0A=
Trace; c0102cf1 <sysenter_do_call+12/25>=0A=
=0A=
>>EIP; c015b4e5 <kmem_cache_alloc+48/83>   <=3D=3D=3D=3D=3D=0A=
=0A=
>>ECX; 7a9d5f5c <phys_startup_32+7a8d5f5c/c0000000>=0A=
>>EBP; c04c7d90 <kmalloc_caches+210/480>=0A=
=0A=
Trace; c012c900 <alloc_pid+18/2b6>=0A=
Trace; c0101a87 <copy_thread+2f/f3>=0A=
Trace; c011e9cb <copy_process+917/e42>=0A=
Trace; c011f085 <do_fork+11a/268>=0A=
=0A=
>>EIP; c015bb0a <__kmalloc+83/c0>   <=3D=3D=3D=3D=3D=0A=
=0A=
>>EBX; c04c7d90 <kmalloc_caches+210/480>=0A=
>>ECX; 7a9d5f5c <phys_startup_32+7a8d5f5c/c0000000>=0A=
>>ESI; 00203282 <phys_startup_32+103282/c0000000>=0A=
>>EDI; c04c7d90 <kmalloc_caches+210/480>=0A=
=0A=
Trace; f81ea6f4 <END_OF_CODE+37c8a6f4/????>=0A=
Trace; f8348c59 <END_OF_CODE+37de8c59/????>=0A=
Trace; c0167680 <vfs_ioctl+47/5d>=0A=
Trace; c0167bb4 <do_vfs_ioctl+446/47c>=0A=
Trace; c0122ac3 <do_setitimer+157/2a9>=0A=
Trace; c0122c59 <sys_setitimer+44/71>=0A=
=0A=
>>EIP; c015b4e5 <kmem_cache_alloc+48/83>   <=3D=3D=3D=3D=3D=0A=
=0A=
>>ECX; 7a9d5f5c <phys_startup_32+7a8d5f5c/c0000000>=0A=
>>EDI; c018d53c <show_stat+0/680>=0A=
>>EBP; c04c7d90 <kmalloc_caches+210/480>=0A=
=0A=
Trace; c018d53c <show_stat+0/680>=0A=
Trace; c017059b <seq_open+23/6d>=0A=
Trace; c018d53c <show_stat+0/680>=0A=
Trace; c0170678 <single_open+48/68>=0A=
=0A=
=0A=
3 warnings and 1 error issued.  Results may not be reliable.=0A=

--2095223807--1359088538--1840572005
Content-Type: application/x-gzip; name="eeepc.log.gz"
Content-Disposition: attachment; filename="eeepc.log.gz"
Content-Transfer-Encoding: base64

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

--2095223807--1359088538--1840572005--
