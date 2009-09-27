Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZI0GnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZI0GnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 02:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZI0GnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 02:43:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43031 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZI0GnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 02:43:18 -0400
Date: Sun, 27 Sep 2009 16:43:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       James Smart <James.Smart@Emulex.Com>
Subject: linux-next: scsi tree boot filure
Message-Id: <20090927164314.9377c24c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__27_Sep_2009_16_43_14_+1000_=CeqbiIj0YZ=Xde+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__27_Sep_2009_16_43_14_+1000_=CeqbiIj0YZ=Xde+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

next-20090926 does not boot on some of my PowerPC partitions:

calling  .ibmvscsi_module_init+0x0/0xb8 @ 1
ibmvscsi 30000028: SRP_VERSION: 16.a
scsi0 : IBM POWER Virtual SCSI Adapter 1.5.8
ibmvscsi 30000028: partner initialization complete
ibmvscsi 30000028: host srp version: 16.a, host partition 1-Didgo-VIOS (1),=
 OS 3, max io 1048576
ibmvscsi 30000028: Client reserve enabled
ibmvscsi 30000028: sent SRP login
ibmvscsi 30000028: SRP_LOGIN succeeded
Unable to handle kernel paging request for data at address 0x00000058
Faulting instruction address: 0xc0000000003a6280
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=3D128 NUMA pSeries
Modules linked in:
NIP: c0000000003a6280 LR: c0000000003a63b4 CTR: 0000000000000000
REGS: c00000007c3f3020 TRAP: 0300   Not tainted  (2.6.31-autokern1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24002042  XER: 00000001
DAR: 0000000000000058, DSISR: 0000000040000000
TASK =3D c00000007c3e8000[1] 'swapper' THREAD: c00000007c3f0000 CPU: 3
GPR00: 0000000000000000 c00000007c3f32a0 c000000000bc5390 c000000000a76420=
=20
GPR04: c000000000b97818 c0000000015abc70 0000000000000000 c00000007c81c918=
=20
GPR08: c00000007c81c888 0000000002000000 0000000000000002 c0000000014ecbcc=
=20
GPR12: 0000000024000042 c000000000c1ea80 0000000003500000 c00000000074af10=
=20
GPR16: c000000000749588 0000000000000000 0000000000000000 0000000000000000=
=20
GPR20: c00000007c3f3600 c000000079074c00 c00000007c81c000 0000000002f1f8e0=
=20
GPR24: 0000000000000000 0000000000000000 0000000000000000 c000000079074c28=
=20
GPR28: c00000007c81c000 0000000000000000 c000000000b353f0 c000000000b97818=
=20
NIP [c0000000003a6280] .__scsi_alloc_queue+0x2c/0x13c
LR [c0000000003a63b4] .scsi_alloc_queue+0x24/0x84
Call Trace:
[c00000007c3f32a0] [c00000007c3f3330] 0xc00000007c3f3330 (unreliable)
[c00000007c3f3330] [c0000000003a63b4] .scsi_alloc_queue+0x24/0x84
[c00000007c3f33b0] [c0000000003a8f78] .scsi_alloc_sdev+0x198/0x2ac
[c00000007c3f3470] [c0000000003a9450] .scsi_probe_and_add_lun+0x130/0xaac
[c00000007c3f3580] [c0000000003aa20c] .__scsi_scan_target+0xf4/0x5fc
[c00000007c3f36a0] [c0000000003aa768] .scsi_scan_channel+0x54/0xd0
[c00000007c3f3740] [c0000000003aa8b0] .scsi_scan_host_selected+0xcc/0x144
[c00000007c3f37f0] [c0000000003d5264] .ibmvscsi_probe+0x590/0x6e4
[c00000007c3f38c0] [c000000000021e88] .vio_bus_probe+0x84/0xb0
[c00000007c3f3960] [c00000000037cbac] .driver_probe_device+0xfc/0x1c0
[c00000007c3f39f0] [c00000000037cd04] .__driver_attach+0x94/0xd8
[c00000007c3f3a80] [c00000000037b9f8] .bus_for_each_dev+0x84/0xdc
[c00000007c3f3b30] [c00000000037c954] .driver_attach+0x28/0x40
[c00000007c3f3bb0] [c00000000037c290] .bus_add_driver+0x148/0x314
[c00000007c3f3c60] [c00000000037d1b0] .driver_register+0xd4/0x1a8
[c00000007c3f3d10] [c000000000021cbc] .vio_register_driver+0x40/0x5c
[c00000007c3f3da0] [c00000000084f418] .ibmvscsi_module_init+0x80/0xb8
[c00000007c3f3e30] [c0000000000094c8] .do_one_initcall+0x9c/0x1cc
[c00000007c3f3ee0] [c000000000822cc0] .kernel_init+0x21c/0x298
[c00000007c3f3f90] [c000000000026cb8] .kernel_thread+0x54/0x70
Instruction dump:
4e800020 7c0802a6 fb81ffe0 fbe1fff8 fba1ffe8 7c7c1b78 f8010010 f821ff71=20
7c9f2378 eba302a0 48000008 ebbd0000 <e81d0058> 7fa3eb78 2fa00000 419efff0=20
---[ end trace 18604a042ee6e0ba ]---
Kernel panic - not syncing: Attempted to kill init!
Call Trace:
[c00000007c3f2c80] [c00000000001024c] .show_stack+0x70/0x184 (unreliable)
[c00000007c3f2d30] [c00000000006a410] .panic+0x80/0x1b4
[c00000007c3f2dd0] [c00000000006eca4] .do_exit+0x84/0x728
[c00000007c3f2e90] [c000000000024d2c] .die+0x24c/0x27c
[c00000007c3f2f30] [c0000000000330c8] .bad_page_fault+0xb8/0xd4
[c00000007c3f2fb0] [c0000000000051dc] handle_page_fault+0x3c/0x74
--- Exception: 300 at .__scsi_alloc_queue+0x2c/0x13c
    LR =3D .scsi_alloc_queue+0x24/0x84
[c00000007c3f32a0] [c00000007c3f3330] 0xc00000007c3f3330 (unreliable)
[c00000007c3f3330] [c0000000003a63b4] .scsi_alloc_queue+0x24/0x84
[c00000007c3f33b0] [c0000000003a8f78] .scsi_alloc_sdev+0x198/0x2ac
[c00000007c3f3470] [c0000000003a9450] .scsi_probe_and_add_lun+0x130/0xaac
[c00000007c3f3580] [c0000000003aa20c] .__scsi_scan_target+0xf4/0x5fc
[c00000007c3f36a0] [c0000000003aa768] .scsi_scan_channel+0x54/0xd0
[c00000007c3f3740] [c0000000003aa8b0] .scsi_scan_host_selected+0xcc/0x144
[c00000007c3f37f0] [c0000000003d5264] .ibmvscsi_probe+0x590/0x6e4
[c00000007c3f38c0] [c000000000021e88] .vio_bus_probe+0x84/0xb0
[c00000007c3f3960] [c00000000037cbac] .driver_probe_device+0xfc/0x1c0
[c00000007c3f39f0] [c00000000037cd04] .__driver_attach+0x94/0xd8
[c00000007c3f3a80] [c00000000037b9f8] .bus_for_each_dev+0x84/0xdc
[c00000007c3f3b30] [c00000000037c954] .driver_attach+0x28/0x40
[c00000007c3f3bb0] [c00000000037c290] .bus_add_driver+0x148/0x314
[c00000007c3f3c60] [c00000000037d1b0] .driver_register+0xd4/0x1a8
[c00000007c3f3d10] [c000000000021cbc] .vio_register_driver+0x40/0x5c
[c00000007c3f3da0] [c00000000084f418] .ibmvscsi_module_init+0x80/0xb8
[c00000007c3f3e30] [c0000000000094c8] .do_one_initcall+0x9c/0x1cc
[c00000007c3f3ee0] [c000000000822cc0] .kernel_init+0x21c/0x298
[c00000007c3f3f90] [c000000000026cb8] .kernel_thread+0x54/0x70
Rebooting in 180 seconds..

I have bisected this down to commit
4acd10521ee002137b5d6791e234d7110033c782 ("[SCSI] scsi_lib_dma.c : fix
bug /w dma maps on virtual vc ports") which was added between
next-20090925 and next-20090926.

Reverting that single commit from next-20090926 allows it to boot.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__27_Sep_2009_16_43_14_+1000_=CeqbiIj0YZ=Xde+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkq/CYIACgkQjjKRsyhoI8y2BwCffOMw5YzGhtlIs46tGiG2Ocq8
iE4An2DafFU16XS6Yv2dgmzD6xQo1giM
=buma
-----END PGP SIGNATURE-----

--Signature=_Sun__27_Sep_2009_16_43_14_+1000_=CeqbiIj0YZ=Xde+--
