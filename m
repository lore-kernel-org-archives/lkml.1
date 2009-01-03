Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbZACAfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbZACAfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 19:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757987AbZACAe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 19:34:58 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:64660 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbZACAe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 19:34:57 -0500
Subject: Re: i915 KMS framebuffer oops report
From: Eric Anholt <eric@anholt.net>
To: Hubert Tonneau <hubert.tonneau@fullpliant.org>
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <08IR6K911@briare1.fullpliant.org>
References: <08IR6K911@briare1.fullpliant.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yM0NE1CO3ZJ1LVQToDZs"
Date: Fri, 02 Jan 2009 16:34:54 -0800
Message-Id: <1230942894.4727.5.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yM0NE1CO3ZJ1LVQToDZs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-30 at 14:21 +0000, Hubert Tonneau wrote:
> I've tested the GIT tree submitted by Airlied for inclusion
> in 2.6.29, and just got an oops when trying to load i915
> with kernel mode setting:

Hmm, I've been poking at modesetting a bunch today while working on HDMI
support, and haven't managed to reproduce this.  Could you open a bug
with .config and dmesg?

> <6>Linux agpgart interface v0.103
> <6>agpgart-intel 0000:00:00.0: Intel 945GM Chipset
> <6>agpgart-intel 0000:00:00.0: detected 7932K stolen memory
> <6>agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> <6>[drm] Initialized drm 1.1.0 20060810
> <6>pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> <7>pci 0000:00:02.0: setting latency timer to 64
> <1>BUG: unable to handle kernel NULL pointer dereference at 00000000
> <1>IP: [<00000000>] 0x0
> <4>*pde =3D 00000000=20
> <0>Oops: 0000 [#1] SMP=20
> <0>last sysfs file:=20
> <4>Modules linked in: i915(+) cfbfillrect cfbimgblt cfbcopyarea i2c_algo_=
bit drm i2c_core intel_agp agpgart
> <4>
> <4>Pid: 1420, comm: insmod Not tainted (2.6.28 #1) Latitude D820         =
         =20
> <4>EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 1
> <4>EIP is at 0x0
> <4>EAX: 00000000 EBX: c1fbc2a0 ECX: c2008500 EDX: c1fbc2a0
> <4>ESI: 00000000 EDI: f6f64148 EBP: 00000000 ESP: f648bca8
> <4> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> <0>Process insmod (pid: 1420, ti=3Df648a000 task=3Df6fcd8d0 task.ti=3Df64=
8a000)
> <0>Stack:
> <4> c0152fe0 000000d0 00000000 00000000 00000000 00000000 f6f64148 c01530=
54
> <0> 00000000 00000000 00000000 00000000 00000020 f65853c0 c01530f0 000000=
00
> <0> f65853c0 f7e08bcc 00000000 f7cd3931 f6437f40 f6f64148 f6585440 f65853=
c0
> <0>Call Trace:
> <0> [<c0152fe0>] __read_cache_page+0x70/0xc0
> <0> [<c0153054>] read_cache_page_async+0x24/0xb0
> <0> [<c01530f0>] read_cache_page+0x10/0x50
> <0> [<f7e08bcc>] i915_gem_object_get_page_list+0x7c/0x100 [i915]
> <0> [<f7cd3931>] drm_mm_split_at_start+0x21/0x80 [drm]
> <0> [<f7e09437>] i915_gem_object_bind_to_gtt+0xd7/0x1f0 [i915]
> <0> [<f7e0a617>] i915_gem_object_pin+0x87/0xd0 [i915]
> <0> [<f7e0a9e2>] i915_gem_init_object+0x12/0x50 [i915]
> <0> [<f7ccc627>] drm_gem_object_alloc+0x87/0xb0 [drm]
> <0> [<f7e0aff1>] i915_gem_init_ringbuffer+0x71/0x340 [i915]
> <0> [<f7cd3887>] drm_mm_create_tail_node+0x27/0x80 [drm]
> <0> [<f7e03fc7>] i915_load_modeset_init+0x2e7/0x460 [i915]
> <0> [<f7e0434a>] i915_driver_load+0x1ba/0x2c0 [i915]
> <0> [<f7cd085e>] drm_get_dev+0x1ce/0x200 [drm]
> <0> [<c01ff5f0>] pci_get_dev_by_id+0x40/0x80
> <0> [<f7ccb17c>] drm_init+0x8c/0xf0 [drm]
> <0> [<f7c78000>] i915_init+0x0/0x6a [i915]
> <0> [<c0101113>] do_one_initcall+0x23/0x1d0
> <0> [<c01ee015>] idr_get_empty_slot+0xc5/0x150
> <0> [<c01b19d2>] sysfs_add_one+0x12/0x50
> <0> [<c01ee74f>] ida_get_new_above+0x3f/0x1b0
> <0> [<c01b1880>] sysfs_ilookup_test+0x0/0x10
> <0> [<c01b1880>] sysfs_ilookup_test+0x0/0x10
> <0> [<c0183de1>] ifind+0x31/0xa0
> <0> [<c01b1987>] __sysfs_add_one+0x47/0x80
> <0> [<c01b19d2>] sysfs_add_one+0x12/0x50
> <0> [<c01b18cf>] sysfs_addrm_start+0x3f/0xb0
> <0> [<c01b1b5e>] sysfs_addrm_finish+0xe/0xa0
> <0> [<c016a7bd>] __vunmap+0x4d/0xc0
> <0> [<c014a8c4>] load_module+0xa14/0xb70
> <0> [<c0152bb0>] filemap_fault+0x0/0x360
> <0> [<c013f277>] blocking_notifier_call_chain+0x17/0x20
> <0> [<c014ab06>] sys_init_module+0xe6/0x1a0
> <0> [<c010340a>] syscall_call+0x7/0xb
> <0>Code:  Bad EIP value.
> <0>EIP: [<00000000>] 0x0 SS:ESP 0068:f648bca8
> <4>---[ end trace 6e26e53289db93ad ]---
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-yM0NE1CO3ZJ1LVQToDZs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklesq4ACgkQHUdvYGzw6vckuACfZm+PgtTTaPSpUpIhEYcYYwcY
WYQAn1/WpQw2QCFkqoZS6FNHgVsNQHxl
=eZXB
-----END PGP SIGNATURE-----

--=-yM0NE1CO3ZJ1LVQToDZs--

