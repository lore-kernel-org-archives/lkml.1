Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbZDYI7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbZDYI7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZDYI7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:59:11 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:53780 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbZDYI7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:59:09 -0400
X-Greylist: delayed 1074 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Apr 2009 04:59:08 EDT
Message-ID: <49F2CC9A.4020709@t-online.de>
Date: Sat, 25 Apr 2009 10:40:58 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc3: reiserfs woes
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB409A5E3B811D68C16798EA9"
X-ID: VyQM6oZBghXmdghb+z5tZaQQUzwA0wx3MdmrGy-U4OdoYAw6YYaz0Pi0q8YkUFmwu1
X-TOI-MSGID: 6632cb48-1f1b-44af-8971-b2ad5d9993bd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB409A5E3B811D68C16798EA9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi folks,

I found this at boot time:

Apr 25 10:29:53 elmer kernel: [   10.601514] ------------[ cut here ]----=
--------
Apr 25 10:29:53 elmer kernel: [   10.605661] WARNING: at /export/tmp/buil=
d_kernel.2.6.30-rc3.XXXXXXba3twq/raw-kernel-2.6.30-rc3/linux-2.6.30-rc3/f=
s/namei.c:1251 lookup_one_len+0x32/0x9f()
Apr 25 10:29:53 elmer kernel: [   10.614944] Hardware name: Aspire R3600
Apr 25 10:29:53 elmer kernel: [   10.619771] Modules linked in: reiserfs =
raid10 raid456 raid6_pq async_xor async_memcpy async_tx xor raid1 raid0 m=
ultipath linear md_mod usbhid sd_mod ohci_hcd ehci_hcd ahci usbcore libat=
a forcedeth thermal fan
Apr 25 10:29:53 elmer kernel: [   10.636436] Pid: 2084, comm: exe Not tai=
nted 2.6.30-rc3 #1
Apr 25 10:29:53 elmer kernel: [   10.642208] Call Trace:
Apr 25 10:29:53 elmer kernel: [   10.647869]  [<c011f905>] ? warn_slowpat=
h+0x80/0xae
Apr 25 10:29:53 elmer kernel: [   10.653744]  [<c0123627>] ? __do_softirq=
+0x120/0x154
Apr 25 10:29:53 elmer kernel: [   10.659705]  [<c01237a8>] ? irq_exit+0x2=
8/0x32
Apr 25 10:29:53 elmer kernel: [   10.665558]  [<c010e666>] ? smp_apic_tim=
er_interrupt+0x64/0x6c
Apr 25 10:29:53 elmer kernel: [   10.671607]  [<c0102f4a>] ? apic_timer_i=
nterrupt+0x2a/0x30
Apr 25 10:29:53 elmer kernel: [   10.677780]  [<c011007b>] ? destroy_irq+=
0x5e/0x83
Apr 25 10:29:53 elmer kernel: [   10.683856]  [<c012024b>] ? vprintk+0x29=
c/0x2dc
Apr 25 10:29:53 elmer kernel: [   10.689827]  [<c0120255>] ? vprintk+0x2a=
6/0x2dc
Apr 25 10:29:53 elmer kernel: [   10.695733]  [<c016c45d>] ? cache_alloc_=
debugcheck_after+0x2c/0x184
Apr 25 10:29:53 elmer kernel: [   10.701601]  [<c0177c5e>] ? lookup_one_l=
en+0x32/0x9f
Apr 25 10:29:53 elmer kernel: [   10.707306]  [<c02c4299>] ? printk+0xe/0=
x15
Apr 25 10:29:53 elmer kernel: [   10.712993]  [<f9273444>] ? reiserfs_xat=
tr_init+0x5b/0x186 [reiserfs]
Apr 25 10:29:53 elmer kernel: [   10.718945]  [<f92647b8>] ? reiserfs_fil=
l_super+0x9f8/0xb01 [reiserfs]
Apr 25 10:29:53 elmer kernel: [   10.724866]  [<c02c6618>] ? _spin_unlock=
+0xf/0x22
Apr 25 10:29:53 elmer kernel: [   10.730615]  [<c01d185a>] ? _atomic_dec_=
and_lock+0x22/0x2c
Apr 25 10:29:53 elmer kernel: [   10.736360]  [<c01d6715>] ? string+0x33/=
0x81
Apr 25 10:29:53 elmer kernel: [   10.741981]  [<c01d71e0>] ? vsnprintf+0x=
313/0x35e
Apr 25 10:29:53 elmer kernel: [   10.747396]  [<c0172329>] ? get_sb_bdev+=
0xe8/0x12f
Apr 25 10:29:53 elmer kernel: [   10.752686]  [<c016d700>] ? __kmalloc_tr=
ack_caller+0x1a/0x16c
Apr 25 10:29:53 elmer kernel: [   10.758043]  [<c0182836>] ? alloc_vfsmnt=
+0x6c/0xe3
Apr 25 10:29:53 elmer kernel: [   10.763316]  [<c0182836>] ? alloc_vfsmnt=
+0x6c/0xe3
Apr 25 10:29:53 elmer kernel: [   10.768316]  [<f9262395>] ? get_super_bl=
ock+0x12/0x16 [reiserfs]
Apr 25 10:29:53 elmer kernel: [   10.773176]  [<f9263dc0>] ? reiserfs_fil=
l_super+0x0/0xb01 [reiserfs]
Apr 25 10:29:53 elmer kernel: [   10.777997]  [<c017137f>] ? vfs_kern_mou=
nt+0x39/0x72
Apr 25 10:29:53 elmer kernel: [   10.782653]  [<c01713f6>] ? do_kern_moun=
t+0x2f/0xb4
Apr 25 10:29:53 elmer kernel: [   10.787079]  [<c0183445>] ? do_mount+0x6=
5e/0x699
Apr 25 10:29:53 elmer kernel: [   10.791285]  [<c01132a8>] ? do_page_faul=
t+0x0/0x200
Apr 25 10:29:53 elmer kernel: [   10.795411]  [<c02c6fb9>] ? iret_exc+0x4=
25/0x8a9
Apr 25 10:29:53 elmer kernel: [   10.799483]  [<c01834ef>] ? sys_mount+0x=
6f/0xac
Apr 25 10:29:53 elmer kernel: [   10.803501]  [<c0102921>] ? syscall_call=
+0x7/0xb
Apr 25 10:29:53 elmer kernel: [   10.807518] ---[ end trace 4a3c8f4700302=
9bb ]---


Regards

Harri



--------------enigB409A5E3B811D68C16798EA9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknyzJ4ACgkQUTlbRTxpHjck+gCeIJ4t2GrpOPbNPhoLwk6mrZ99
Ym0An3jIeh5BpzthJXfIJHAAdI78r4hZ
=pdYO
-----END PGP SIGNATURE-----

--------------enigB409A5E3B811D68C16798EA9--
