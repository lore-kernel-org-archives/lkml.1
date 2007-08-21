Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbXHUA52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbXHUA52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 20:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXHUA5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 20:57:18 -0400
Received: from hu-out-0506.google.com ([72.14.214.237]:60155 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXHUA5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 20:57:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:message-id;
        b=tdSWIN4cCxYnlzscqb3y084pIQo82RvXQ3h7tmNqr2quQPVsbIrHLUZZn+JRcBmcoNC9xxuX+/p73AYNri2dw6pI2rlPlZcmJH7mpK07aHmk/uCPVlbCBsy8xokrrOPC+auAhBEP2WyoUHhL9/nUJUxGY5rsuYvcJ26937Lfbg4=
From: poison <rc.poison@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG: unable to handle kernel NULL pointer dereference - linux-2.6.22
Date: Tue, 21 Aug 2007 02:56:49 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart11534568.bkWRSH7BGs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708210256.58818.rc.poison@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart11534568.bkWRSH7BGs
Content-Type: multipart/mixed;
  boundary="Boundary-01=_ShjyG3+t6gY0G6t"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_ShjyG3+t6gY0G6t
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,
after running a few instances of bittorent-curses on 2.6.22 - 2.6.22.3 it=20
takes about 15min to 2hrs for my System to hang. 2.6.21.7 is definately fin=
e,=20
2.6.21 probably (ran for 4hrs without hanging).=20
If I'm lucky the Oops below makes it to my syslog (unfortunately SysRq-{p,s=
,i}=20
doesn't work when it hangs, neither can I ssh into it):

Aug 18 19:47:41 draco kernel: BUG: unable to handle kernel NULL pointer=20
dereference at virtual address 00000000
Aug 18 19:47:41 draco kernel:  printing eip:
Aug 18 19:47:41 draco kernel: c038fcba
Aug 18 19:47:41 draco kernel: *pdpt =3D 0000000033830001
Aug 18 19:47:41 draco kernel: *pde =3D 0000000000000000
Aug 18 19:47:41 draco kernel: Oops: 0002 [#1]
Aug 18 19:47:41 draco kernel: SMP=20
Aug 18 19:47:41 draco kernel: Modules linked in: snd_hda_intel snd_emu10k1=
=20
cls_u32 sch_sfq sch_htb snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_se=
q=20
snd_pcm_oss snd_mixer_oss rfcomm hidp l2cap nfsd exportfs lockd sunrpc=20
coretemp hwmon eeprom snd_rawmidi snd_ac97_codec hci_usb ac97_bus=20
snd_seq_device snd_util_mem snd_pcm bluetooth snd_hwdep snd_timer snd=20
snd_page_alloc i2c_i801 emu10k1_gp gameport i2c_core sg
Aug 18 19:47:41 draco kernel: CPU:    0
Aug 18 19:47:41 draco kernel: EIP:    0060:[<c038fcba>]    Not tainted VLI
Aug 18 19:47:41 draco kernel: EFLAGS: 00210202   (2.6.22.2poison #14)
Aug 18 19:47:41 draco kernel: EIP is at tcp_sendmsg+0x40a/0xb70
Aug 18 19:47:41 draco kernel: eax: 00000000   ebx: ec5b807c   ecx: c04b43a0=
  =20
edx: ec5b807c
Aug 18 19:47:41 draco kernel: esi: ec5b8000   edi: 00000100   ebp: ec524180=
  =20
esp: f3a11d30
Aug 18 19:47:41 draco kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss:=
=20
0068
Aug 18 19:47:41 draco kernel: Process bittorrent-curs (pid: 3974, ti=3Df3a1=
0000=20
task=3Df3a0e000 task.ti=3Df3a10000)
Aug 18 19:47:41 draco kernel: Stack: ffffffff ebe562f5 0000000b 00000000=20
f3a11d94 00000000 ec5b807c 00000000=20
Aug 18 19:47:41 draco kernel:        00000001 00100100 f3a11f40 00000000=20
00000040 00000200 00000200 000004b6=20
Aug 18 19:47:41 draco kernel:        08604707 00200200 f3e5c798 eeaa4b40=20
00000000 f3a0e000 000001f5 00100100=20
Aug 18 19:47:41 draco kernel: Call Trace:
Aug 18 19:47:41 draco kernel:  [<c03ac267>] inet_sendmsg+0x37/0x70
Aug 18 19:47:41 draco kernel:  [<c03511ef>] sock_sendmsg+0xbf/0xf0
Aug 18 19:47:41 draco kernel:  [<c012fe60>] autoremove_wake_function+0x0/0x=
50
Aug 18 19:47:41 draco kernel:  [<c01188f0>] default_wake_function+0x0/0x10
Aug 18 19:47:41 draco last message repeated 3 times
Aug 18 19:47:41 draco kernel:  [<c015589d>] find_extend_vma+0x1d/0x70
Aug 18 19:47:41 draco kernel:  [<c03515cf>] sys_sendto+0x12f/0x180
Aug 18 19:47:41 draco kernel:  [<c0139dfc>] futex_wake+0xac/0xd0
Aug 18 19:47:41 draco kernel:  [<c013a4dd>] do_futex+0x6bd/0xbd0
Aug 18 19:47:41 draco kernel:  [<c0351653>] sys_send+0x33/0x40
Aug 18 19:47:41 draco kernel:  [<c03525c2>] sys_socketcall+0x142/0x280
Aug 18 19:47:41 draco kernel:  [<c0205d20>] copy_to_user+0x30/0x60
Aug 18 19:47:41 draco kernel:  [<c0102a92>] syscall_call+0x7/0xb
Aug 18 19:47:41 draco kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Aug 18 19:47:41 draco kernel: Code: 85 fb 06 00 00 80 ca 10 8b 83 94 00 00 =
00=20
88 53 68 f0 81 00 00 00 01 00 8b 44 24 18 ff 40 08 8b 54 24 18 8b 42 04 89 =
13=20
89 43 04 <89> 18 89 5a 04 8b 8e 2c 01 00 00 85 c9 0f 84 19 06 00 00 8b 83=20
Aug 18 19:47:41 draco kernel: EIP: [<c038fcba>] tcp_sendmsg+0x40a/0xb70 SS:=
ESP=20
0068:f3a11d30
Aug 18 19:47:51 draco kernel:=20
Aug 18 19:47:51 draco kernel: Pid: 3812, comm:                    X
Aug 18 19:47:51 draco kernel: EIP: 0060:[<c014a4c2>] CPU: 0
Aug 18 19:47:51 draco kernel: EIP is at __get_free_pages+0x22/0x40
Aug 18 19:47:51 draco kernel:  EFLAGS: 00003246    Not tainted =20
(2.6.22.2poison #14)
Aug 18 19:47:51 draco kernel: EAX: 000000d0 EBX: 000000d0 ECX: c0496b40 EDX=
:=20
00000000
Aug 18 19:47:51 draco kernel: ESI: 00000000 EDI: f5ba1be4 EBP: f49a4d80 DS:=
=20
007b ES: 007b FS: 00d8
Aug 18 19:47:51 draco kernel: CR0: 8005003b CR2: b7384000 CR3: 37165000 CR4=
:=20
000006f0
Aug 18 19:47:51 draco kernel:  [<c01734b6>] __pollwait+0xa6/0x100
Aug 18 19:47:51 draco kernel:  [<c03c9597>] unix_poll+0x17/0xa0
Aug 18 19:47:51 draco kernel:  [<c03500bc>] sock_poll+0xc/0x10
Aug 18 19:47:51 draco kernel:  [<c0172bec>] do_select+0x25c/0x490
Aug 18 19:47:51 draco kernel:  [<c0173410>] __pollwait+0x0/0x100
Aug 18 19:47:51 draco kernel:  [<c01188f0>] default_wake_function+0x0/0x10
Aug 18 19:47:51 draco last message repeated 19 times
Aug 18 19:47:51 draco kernel:  [<c0172fe8>] core_sys_select+0x1c8/0x2f0
Aug 18 19:47:51 draco kernel:  [<c0166a30>] do_readv_writev+0x120/0x190
Aug 18 19:47:51 draco kernel:  [<c03503c0>] sock_aio_write+0x0/0x110
Aug 18 19:47:51 draco kernel:  [<c017355d>] sys_select+0x4d/0x1b0
Aug 18 19:47:51 draco kernel:  [<c0166adc>] vfs_writev+0x3c/0x50
Aug 18 19:47:51 draco kernel:  [<c0166f97>] sys_writev+0x47/0x80
Aug 18 19:47:51 draco kernel:  [<c0102a92>] syscall_call+0x7/0xb
Aug 18 19:47:51 draco kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D--

It's also attached together with one from a tainted 2.6.22.3

The error is reproducable for me by running 4 bittorent instances and watin=
g.=20
2.6.22 lives no longer than 2hrs, so when bisecting I assumed it was good=20
after 4hrs ... so I may as well have taken a wrong turn. Result here:

00ed8e3dda47f8421b11da17e353d7db8c878121 is first bad commit
commit 00ed8e3dda47f8421b11da17e353d7db8c878121
Author: Dmitriy Monakhov <dmonakhov@sw.ru>
Date:   Sun Mar 11 15:36:19 2007 +0300

    driver core: fix device_add error path

     - At the moment we jump here device was't added to
       dev->class->devices list yet.

    Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 bc29a0e7ec67055b2cad30ef3e0d19b8fe0c0981=20
8b1eee1c34d5b5db827a4d0c8a8363eb827338f3 M      dr
ivers
=2D--

gcc -v
Reading specs from /usr/lib/gcc/i486-slackware-linux/4.1.2/specs
Target: i486-slackware-linux
Configured=20
with: ../gcc-4.1.2/configure --prefix=3D/usr --enable-shared --enable-langu=
ages=3Dada,c,c++,fortran,java,objc --enable-threads=3Dposix --enable-__cxa_=
atexit --disable-checking --with-gnu-ld --verbose --with-arch=3Di486 --targ=
et=3Di486-slackware-linux --host=3Di486-slackware-linux
Thread model: posix
gcc version 4.1.
=2D--

All traffic went over an USB NIC (D-Link DUB-E100) using the asix driver.
I have no idea what further information could be useful, so shout =3D)

=2D--
If you only have a hammer, you tend to see every problem as a nail.
                -- Maslow

--Boundary-01=_ShjyG3+t6gY0G6t
Content-Type: text/plain;
  charset="iso-8859-1";
  name="Oops"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="Oops"

Aug 18 05:28:40 draco kernel: BUG: unable to handle kernel NULL pointer der=
eference at virtual address 00000000
Aug 18 05:28:40 draco kernel:  printing eip:
Aug 18 05:28:40 draco kernel: c038fe0a
Aug 18 05:28:40 draco kernel: *pdpt =3D 0000000030e8c001
Aug 18 05:28:40 draco kernel: *pde =3D 0000000000000000
Aug 18 05:28:40 draco kernel: Oops: 0002 [#1]
Aug 18 05:28:40 draco kernel: SMP=20
Aug 18 05:28:40 draco kernel: Modules linked in: snd_hda_intel snd_emu10k1 =
cls_u32 sch_sfq sch_htb snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_se=
q snd_pcm_oss snd_mixer_oss rfcomm hidp l2cap nfsd exportfs lockd sunrpc co=
retemp hwmon eeprom nvidia(P) snd_rawmidi snd_ac97_codec ac97_bus snd_seq_d=
evice snd_util_mem snd_pcm hci_usb snd_hwdep snd_timer snd_page_alloc bluet=
ooth snd emu10k1_gp gameport i2c_i801 i2c_core sg
Aug 18 05:28:40 draco kernel: CPU:    1
Aug 18 05:28:40 draco kernel: EIP:    0060:[<c038fe0a>]    Tainted: P      =
 VLI
Aug 18 05:28:40 draco kernel: EFLAGS: 00210202   (2.6.22.3poison #13)
Aug 18 05:28:40 draco kernel: EIP is at tcp_sendmsg+0x40a/0xb70
Aug 18 05:28:40 draco kernel: eax: 00000000   ebx: f0eca97c   ecx: c04b43a0=
   edx: f0eca97c
Aug 18 05:28:40 draco kernel: esi: f0eca900   edi: 00000100   ebp: f0a44300=
   esp: f0f15d30
Aug 18 05:28:40 draco kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss:=
 0068
Aug 18 05:28:40 draco kernel: Process bittorrent-curs (pid: 3969, ti=3Df0f1=
4000 task=3Df0e56a20 task.ti=3Df0f14000)
Aug 18 05:28:40 draco kernel: Stack: ffffffff f0482100 00000200 00000000 f0=
f15d94 00000000 f0eca97c 00000000=20
Aug 18 05:28:40 draco kernel:        00000001 00100100 f0f15f40 00000000 00=
000040 00000200 00000200 000000f4=20
Aug 18 05:28:40 draco kernel:        0850ec9c 00200200 f11db618 f1e26f00 00=
000000 f0e56a20 00000000 00100100=20
Aug 18 05:28:40 draco kernel: Call Trace:
Aug 18 05:28:40 draco kernel:  [<c03ac3b7>] inet_sendmsg+0x37/0x70
Aug 18 05:28:40 draco kernel:  [<c035133f>] sock_sendmsg+0xbf/0xf0
Aug 18 05:28:40 draco kernel:  [<c012fe60>] autoremove_wake_function+0x0/0x=
50
Aug 18 05:28:40 draco kernel:  [<c01188f0>] default_wake_function+0x0/0x10
Aug 18 05:28:40 draco last message repeated 3 times
Aug 18 05:28:40 draco kernel:  [<c015589d>] find_extend_vma+0x1d/0x70
Aug 18 05:28:40 draco kernel:  [<c035171f>] sys_sendto+0x12f/0x180
Aug 18 05:28:40 draco kernel:  [<c0139dfc>] futex_wake+0xac/0xd0
Aug 18 05:28:40 draco kernel:  [<c013a4dd>] do_futex+0x6bd/0xbd0
Aug 18 05:28:40 draco kernel:  [<c03517a3>] sys_send+0x33/0x40
Aug 18 05:28:40 draco kernel:  [<c0352712>] sys_socketcall+0x142/0x280
Aug 18 05:28:40 draco kernel:  [<c0205d30>] copy_to_user+0x30/0x60
Aug 18 05:28:40 draco kernel:  [<c0102a92>] syscall_call+0x7/0xb
Aug 18 05:28:40 draco kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Aug 18 05:28:40 draco kernel: Code: 85 fb 06 00 00 80 ca 10 8b 83 94 00 00 =
00 88 53 68 f0 81 00 00 00 01 00 8b 44 24 18 ff 40 08 8b 54 24 18 8b 42 04 =
89 13 89 43 04 <89> 18 89 5a 04 8b 8e 2c 01 00 00 85 c9 0f 84 19 06 00 00 8=
b 83=20
Aug 18 05:28:40 draco kernel: EIP: [<c038fe0a>] tcp_sendmsg+0x40a/0xb70 SS:=
ESP 0068:f0f15d30
Aug 18 05:28:43 draco kernel: BUG: unable to handle kernel NULL pointer der=
eference at virtual address 00000000
Aug 18 05:28:43 draco kernel:  printing eip:
Aug 18 05:28:43 draco kernel: c038fe0a
Aug 18 05:28:43 draco kernel: *pdpt =3D 0000000030d18001
Aug 18 05:28:43 draco kernel: *pde =3D 0000000000000000
Aug 18 05:28:43 draco kernel: Oops: 0002 [#2]
Aug 18 05:28:43 draco kernel: SMP=20
Aug 18 05:28:43 draco kernel: Modules linked in: snd_hda_intel snd_emu10k1 =
cls_u32 sch_sfq sch_htb snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_se=
q snd_pcm_oss snd_mixer_oss rfcomm hidp l2cap nfsd exportfs lockd sunrpc co=
retemp hwmon eeprom nvidia(P) snd_rawmidi snd_ac97_codec ac97_bus snd_seq_d=
evice snd_util_mem snd_pcm hci_usb snd_hwdep snd_timer snd_page_alloc bluet=
ooth snd emu10k1_gp gameport i2c_i801 i2c_core sg
Aug 18 05:28:43 draco kernel: CPU:    1
Aug 18 05:28:43 draco kernel: EIP:    0060:[<c038fe0a>]    Tainted: P      =
 VLI
Aug 18 05:28:43 draco kernel: EFLAGS: 00210202   (2.6.22.3poison #13)
Aug 18 05:28:43 draco kernel: EIP is at tcp_sendmsg+0x40a/0xb70
Aug 18 05:28:43 draco kernel: eax: 00000000   ebx: f0d556fc   ecx: c04b43a0=
   edx: f0d556fc
Aug 18 05:28:43 draco kernel: esi: f0d55680   edi: 00000100   ebp: f09d2180=
   esp: f0d13d30
Aug 18 05:28:43 draco kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss:=
 0068
Aug 18 05:28:43 draco kernel: Process bittorrent-curs (pid: 3956, ti=3Df0d1=
2000 task=3Df13b2a20 task.ti=3Df0d12000)
Aug 18 05:28:43 draco kernel: Stack: ffffffff efbfe2c9 00000237 00000000 f0=
d13d94 00000000 f0d556fc 00000000=20
Aug 18 05:28:43 draco kernel:        00000001 00100100 f0d13f40 00000000 00=
000040 00000400 00000400 0000032d=20
Aug 18 05:28:43 draco kernel:        0867ed77 00200200 f0c22498 f11ecc00 00=
000000 f13b2a20 000001c9 00100100=20
Aug 18 05:28:43 draco kernel: Call Trace:
Aug 18 05:28:43 draco kernel:  [<c03ac3b7>] inet_sendmsg+0x37/0x70
Aug 18 05:28:43 draco kernel:  [<c035133f>] sock_sendmsg+0xbf/0xf0
Aug 18 05:28:43 draco kernel:  [<c012fe60>] autoremove_wake_function+0x0/0x=
50
Aug 18 05:28:43 draco kernel:  [<c01188f0>] default_wake_function+0x0/0x10
Aug 18 05:28:43 draco last message repeated 3 times
Aug 18 05:28:43 draco kernel:  [<c015589d>] find_extend_vma+0x1d/0x70
Aug 18 05:28:43 draco kernel:  [<c035171f>] sys_sendto+0x12f/0x180
Aug 18 05:28:43 draco kernel:  [<c0139dfc>] futex_wake+0xac/0xd0
Aug 18 05:28:43 draco kernel:  [<c013a4dd>] do_futex+0x6bd/0xbd0
Aug 18 05:28:43 draco kernel:  [<c03517a3>] sys_send+0x33/0x40
Aug 18 05:28:43 draco kernel:  [<c0352712>] sys_socketcall+0x142/0x280
Aug 18 05:28:43 draco kernel:  [<c0205d30>] copy_to_user+0x30/0x60
Aug 18 05:28:43 draco kernel:  [<c0102a92>] syscall_call+0x7/0xb
Aug 18 05:28:43 draco kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Aug 18 05:28:43 draco kernel: Code: 85 fb 06 00 00 80 ca 10 8b 83 94 00 00 =
00 88 53 68 f0 81 00 00 00 01 00 8b 44 24 18 ff 40 08 8b 54 24 18 8b 42 04 =
89 13 89 43 04 <89> 18 89 5a 04 8b 8e 2c 01 00 00 85 c9 0f 84 19 06 00 00 8=
b 83=20
Aug 18 05:28:43 draco kernel: EIP: [<c038fe0a>] tcp_sendmsg+0x40a/0xb70 SS:=
ESP 0068:f0d13d30











Aug 18 19:47:41 draco kernel: BUG: unable to handle kernel NULL pointer der=
eference at virtual address 00000000
Aug 18 19:47:41 draco kernel:  printing eip:
Aug 18 19:47:41 draco kernel: c038fcba
Aug 18 19:47:41 draco kernel: *pdpt =3D 0000000033830001
Aug 18 19:47:41 draco kernel: *pde =3D 0000000000000000
Aug 18 19:47:41 draco kernel: Oops: 0002 [#1]
Aug 18 19:47:41 draco kernel: SMP=20
Aug 18 19:47:41 draco kernel: Modules linked in: snd_hda_intel snd_emu10k1 =
cls_u32 sch_sfq sch_htb snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_se=
q snd_pcm_oss snd_mixer_oss rfcomm hidp l2cap nfsd exportfs lockd sunrpc co=
retemp hwmon eeprom snd_rawmidi snd_ac97_codec hci_usb ac97_bus snd_seq_dev=
ice snd_util_mem snd_pcm bluetooth snd_hwdep snd_timer snd snd_page_alloc i=
2c_i801 emu10k1_gp gameport i2c_core sg
Aug 18 19:47:41 draco kernel: CPU:    0
Aug 18 19:47:41 draco kernel: EIP:    0060:[<c038fcba>]    Not tainted VLI
Aug 18 19:47:41 draco kernel: EFLAGS: 00210202   (2.6.22.2poison #14)
Aug 18 19:47:41 draco kernel: EIP is at tcp_sendmsg+0x40a/0xb70
Aug 18 19:47:41 draco kernel: eax: 00000000   ebx: ec5b807c   ecx: c04b43a0=
   edx: ec5b807c
Aug 18 19:47:41 draco kernel: esi: ec5b8000   edi: 00000100   ebp: ec524180=
   esp: f3a11d30
Aug 18 19:47:41 draco kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss:=
 0068
Aug 18 19:47:41 draco kernel: Process bittorrent-curs (pid: 3974, ti=3Df3a1=
0000 task=3Df3a0e000 task.ti=3Df3a10000)
Aug 18 19:47:41 draco kernel: Stack: ffffffff ebe562f5 0000000b 00000000 f3=
a11d94 00000000 ec5b807c 00000000=20
Aug 18 19:47:41 draco kernel:        00000001 00100100 f3a11f40 00000000 00=
000040 00000200 00000200 000004b6=20
Aug 18 19:47:41 draco kernel:        08604707 00200200 f3e5c798 eeaa4b40 00=
000000 f3a0e000 000001f5 00100100=20
Aug 18 19:47:41 draco kernel: Call Trace:
Aug 18 19:47:41 draco kernel:  [<c03ac267>] inet_sendmsg+0x37/0x70
Aug 18 19:47:41 draco kernel:  [<c03511ef>] sock_sendmsg+0xbf/0xf0
Aug 18 19:47:41 draco kernel:  [<c012fe60>] autoremove_wake_function+0x0/0x=
50
Aug 18 19:47:41 draco kernel:  [<c01188f0>] default_wake_function+0x0/0x10
Aug 18 19:47:41 draco last message repeated 3 times
Aug 18 19:47:41 draco kernel:  [<c015589d>] find_extend_vma+0x1d/0x70
Aug 18 19:47:41 draco kernel:  [<c03515cf>] sys_sendto+0x12f/0x180
Aug 18 19:47:41 draco kernel:  [<c0139dfc>] futex_wake+0xac/0xd0
Aug 18 19:47:41 draco kernel:  [<c013a4dd>] do_futex+0x6bd/0xbd0
Aug 18 19:47:41 draco kernel:  [<c0351653>] sys_send+0x33/0x40
Aug 18 19:47:41 draco kernel:  [<c03525c2>] sys_socketcall+0x142/0x280
Aug 18 19:47:41 draco kernel:  [<c0205d20>] copy_to_user+0x30/0x60
Aug 18 19:47:41 draco kernel:  [<c0102a92>] syscall_call+0x7/0xb
Aug 18 19:47:41 draco kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Aug 18 19:47:41 draco kernel: Code: 85 fb 06 00 00 80 ca 10 8b 83 94 00 00 =
00 88 53 68 f0 81 00 00 00 01 00 8b 44 24 18 ff 40 08 8b 54 24 18 8b 42 04 =
89 13 89 43 04 <89> 18 89 5a 04 8b 8e 2c 01 00 00 85 c9 0f 84 19 06 00 00 8=
b 83=20
Aug 18 19:47:41 draco kernel: EIP: [<c038fcba>] tcp_sendmsg+0x40a/0xb70 SS:=
ESP 0068:f3a11d30
Aug 18 19:47:51 draco kernel:=20
Aug 18 19:47:51 draco kernel: Pid: 3812, comm:                    X
Aug 18 19:47:51 draco kernel: EIP: 0060:[<c014a4c2>] CPU: 0
Aug 18 19:47:51 draco kernel: EIP is at __get_free_pages+0x22/0x40
Aug 18 19:47:51 draco kernel:  EFLAGS: 00003246    Not tainted  (2.6.22.2po=
ison #14)
Aug 18 19:47:51 draco kernel: EAX: 000000d0 EBX: 000000d0 ECX: c0496b40 EDX=
: 00000000
Aug 18 19:47:51 draco kernel: ESI: 00000000 EDI: f5ba1be4 EBP: f49a4d80 DS:=
 007b ES: 007b FS: 00d8
Aug 18 19:47:51 draco kernel: CR0: 8005003b CR2: b7384000 CR3: 37165000 CR4=
: 000006f0
Aug 18 19:47:51 draco kernel:  [<c01734b6>] __pollwait+0xa6/0x100
Aug 18 19:47:51 draco kernel:  [<c03c9597>] unix_poll+0x17/0xa0
Aug 18 19:47:51 draco kernel:  [<c03500bc>] sock_poll+0xc/0x10
Aug 18 19:47:51 draco kernel:  [<c0172bec>] do_select+0x25c/0x490
Aug 18 19:47:51 draco kernel:  [<c0173410>] __pollwait+0x0/0x100
Aug 18 19:47:51 draco kernel:  [<c01188f0>] default_wake_function+0x0/0x10
Aug 18 19:47:51 draco last message repeated 19 times
Aug 18 19:47:51 draco kernel:  [<c0172fe8>] core_sys_select+0x1c8/0x2f0
Aug 18 19:47:51 draco kernel:  [<c0166a30>] do_readv_writev+0x120/0x190
Aug 18 19:47:51 draco kernel:  [<c03503c0>] sock_aio_write+0x0/0x110
Aug 18 19:47:51 draco kernel:  [<c017355d>] sys_select+0x4d/0x1b0
Aug 18 19:47:51 draco kernel:  [<c0166adc>] vfs_writev+0x3c/0x50
Aug 18 19:47:51 draco kernel:  [<c0166f97>] sys_writev+0x47/0x80
Aug 18 19:47:51 draco kernel:  [<c0102a92>] syscall_call+0x7/0xb
Aug 18 19:47:51 draco kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
--Boundary-01=_ShjyG3+t6gY0G6t
Content-Type: application/x-gzip;
  name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="config.gz"

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
ekKS+RubiHEGo/j/1JTGSJrLAAA=

--Boundary-01=_ShjyG3+t6gY0G6t
Content-Type: application/x-gzip;
  name="lspci.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="lspci.gz"

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
8+8Viv4HOsIYw6pJAAA=

--Boundary-01=_ShjyG3+t6gY0G6t
Content-Type: application/x-gzip;
  name="lsusb.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="lsusb.gz"

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

--Boundary-01=_ShjyG3+t6gY0G6t--

--nextPart11534568.bkWRSH7BGs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGyjhSdg1usfq2jicRApnkAJ9tMdWsOehUFmPMO5GYMFPeN3eiwwCfbJJa
SNsKmPBR0nd9yUY46TQaBrY=
=Ivd3
-----END PGP SIGNATURE-----

--nextPart11534568.bkWRSH7BGs--
