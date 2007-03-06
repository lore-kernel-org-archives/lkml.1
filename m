Return-Path: <linux-kernel-owner+w=401wt.eu-S933279AbXCFCfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbXCFCfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933862AbXCFCfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:35:41 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:54098 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279AbXCFCfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:35:40 -0500
From: francesco foresti <frafore@tiscali.it>
Subject: Re: PROBLEM: 2.6.20-1 not working on ibook g4 (BUG/Oops)
Date: Tue, 6 Mar 2007 03:35:16 +0100
User-Agent: KMail/1.9.5
References: <200703051414.15802.frafore@tiscali.it> <20070305091445.da58d029.randy.dunlap@oracle.com>
In-Reply-To: <20070305091445.da58d029.randy.dunlap@oracle.com>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed;
  boundary="nextPart6081493.dTWpPd43CU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703060335.37615.frafore@tiscali.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6081493.dTWpPd43CU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mon, Mar 5 2007 18:14, Randy Dunlap wrote:
> On Mon, 5 Mar 2007 14:13:41 +0100 francesco foresti wrote:
> > Hi,
> > i'm having problems trying to use 2.6.20-1 (taken from kernel.org, not
> > patched) on my ibook g4 (debian testing/unstable):
> > i'm getting two errors while trying to boot up, and i can only report t=
he
> > second one because the other slips offscreen before i can see what's
> > going on. However, this is what i have been able to hand-copy:
> >
> > kernel BUG at mm/slab.c:610!
> > Oops: Exception in kernel mode, sig: 5 [#2]
>
> As you say, this is the second "[#2]" Oops, but the first one is
> usually the one that we need to see.  Can you use a serial console
> or netconsole to send to kernel messages to another computer?

Unfortunately, i can't use a serial console, and netconsole refused to work=
=20
(both built as a module and within the kernel). However, after some 20 shots
to my laptop screen (God bless digital cameras) i had luck and could hand-c=
opy=20
something out of a shot; i _really_ hope it helps:

<everything before this line was off the screen>
Modules linked in: snd_aoa_codec_tas snd_aoa_fabric_layout snd_aoa=20
snd_aoa_i2sbus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer
snd_page_alloc appletouch snd soundcore snd_aoa_soundbus uninorth_agp agpga=
rt=20
eth1394 evdev ext3 jbd mbcache dm_mirror dm_snapshot
dm_mod usbhid ff_memless ide_cd cdrom ide_disk sungem sungem_phy ohci1394=20
ieee1394 ehci_hcd ohci_hcd usbcore i2c_powermac
NIP: C007BBA8 LR: C007BA00 CTR: 00000029=20
REGS: cfc13990 TRAP: 0300 Not tainted  (2.6.20.1-powerpc)
MSR: 00001032 <ME,IR,DR> CR: 22004042 XER: 00000000
DAR: 00000000, DSISR: 42000000
TASK =3D c1b83950[2309] 'alsactl' THREAD: cfc12000
GPR00: 00200200 CFC13A40 C1B83950 C1BF901C 00000015 00000028 C1C97D60 C1BF9=
000
GPR08: 00000000 00000000 00000000 00100100 0151A7A0 100D8C9C 00000000 C1AFE=
19C
GPR16: CFC13D18 00000009 00000001 00000007 EFFB4800 C1A77D34 C1A77D90 00000=
000
GPR24: 00000010 00011200 00000000 00000000 EFFEE6E0 C1C9D260 00000000 C1C96=
A00
NIP [C007BBA8] cache_alloc_refill+0x184/0x564
LR [C007BA00] kmem_cache_alloc+0x6c/0x90
Call Trace:
[CFC13A40] [0020020] 0x20020 (unreliable)
[CFC13A70] [C007BA00] kmem_cache_alloc+0x6c/0x90
[CFC13A90] [C005E86C] mempool_alloc_slab+0x1c/0x2c
[CFC13AA0] [C005EAA0] mempool_alloc+0x44/0xf4
[CFC13AE0] [C00F08C4] get_request+0x184/0x294
[CFC13B10] [C00F12A4] get_request_wait+0x28/0x100
[CFC13B60] [C00F2254] __make_request+0x3b4/0x550
[CFC13BB0] [C00EFCA0] generic_make_request+0x208/0x224
[CFC13BF0] [C00F2810] submit_bio+0xe4/0xf8
[CFC13C30] [C00A3D9C] submit_bh+0x160/0x198
[CFC13C50] [C00A5178] ll_rw_block+0x104/0x134
[CFC13C70] [F22C95F8] ext3_find_entry+0x308/0x524 [ext3]
[CFC13D10] [F22CB24C] ext3_lookup+0x34/0x134 [ext3]
[CFC13D40] [C0087A44] do_lookup+0xc0/0x1a0
[CFC13D70] [C0089EB0] __link_path_walk+0x904/0xe70
[CFC13DC0] [C008A49C] link_path_walk+0x80/0x144
[CFC13E30] [C008A8AC] do_path_lookup+0x1f8/0x22c
[CFC13E60] [C008B350] path_lookup_intent_open+0x58/0xa4
[CFC13E80] [C008B504] open_namei+0x6c/0x698
[CFC13EC0] [C007D794] do_filp_open+0x30/0x60
[CFC13F20] [C007D81C] do_sys_open+0x58/0xf8
[CFC13F40] [C00129F4] ret_from_syscall+0x0/0x40
=2D-- Exception : c01 at 0x30012cf8
    LR =3D 0x300056a4
Instruction dump:
801c0020 38890001 7f890040 409c000c 38a5ffff 4200ffac 81270000 3d600010
3c000020 81470004 616b0100 60000200 <912a0000> 91490004 91670000 90070004

I have to add some more info:
=2D  sometimes i'm having another error with the same kernel, but in a diff=
erent=20
   moment (earlier). Again, i took my camera and got this out of it:

 Unable to handle kernel paging request for data at address 0x00000000
=46aulting instruction address: 0xc007b5d0
Oops: Kernel access of bad area, sig:11 [#1]

Modules linked in: ide_disk ide_cd cdrom sungem sungem_phy ohci1394 ieee139=
4=20
ehci_hcd ohci_hcd usbcore i2c_powermac
NIP: C007B5D0 LR: C007B740 CTR: C007CDCC
REGS: effc7e50 TRAP: 0300 Not tainted (2.6.20.1-powerpc)
MSR: 00001032 <ME,IR,DR>  CR: 22000088 XER: 00000000
DAR: 00000000, DSISR: 42000000
TASK effc0bf0[3] 'events/0' THREAD: effc6000
GPR00: 00100100 EFFC7F00 EFFC0BF0 EFFEE6E0 C0355F00 C1BF806C C1C97D60 C1BF8=
000
GPR08: 00000000 EFFEE6E0 00000000 00200200 00000000 00000000 00000000 00000=
000
GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 0164B260 41400=
000
GPR24: 00000000 00311000 EFFF6920 00000004 00000000 00000000 C1C96A10 EFFEE=
6E0
NIP: [C007B5D0] free_block+0x88/0x160
LR: [C007B740] drain_array+0x98/0xd8
Call Trace:
[EFFC7F00] [00000002] 0x2 (unreliable)
[EFFC7F20] [C007B740] drain_array+0x98/0xd8
[EFFC7F40] [C007CE0C] cache_reap+0x40/0x128
[EFFC7F50] [C003E2C8] run_workqueue+0xb4/0x15c
[EFFC7F70] [C003EB10] woker_thread+0x124/0x15c
[EFFC7FC0] [C00423FC] kthread+0xc4/0x100
[EFFC7FF0] [C0013998] kernel_thread+0x44/0x60
Instruction dump:
5400cffe 0f000000 80e4001c 5789103a 3c000010 7d29fa14 3d600020 81070004
60000100 616b0200 81470000 80c90018 <91480000> 910a0004 90070000 91670004
=20
i hope this can help someway.

Best
=2D-=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=46rancesco Foresti
Registered Linux User #332599
key fingerprint =3D 59D5 1E61 6631 5DEF DC88 C64C 7F53 2F45 99FB CD21

--nextPart6081493.dTWpPd43CU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF7NN5f1MvRZn7zSERAtsEAKCQgwoH9yERpO3Su7XDorRMo18wiQCdFBGK
ZDcoVXRNnodfh0Jyv7XIjKI=
=oEs7
-----END PGP SIGNATURE-----

--nextPart6081493.dTWpPd43CU--
