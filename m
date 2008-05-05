Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbYEEXRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbYEEXRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYEEXRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:17:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58187 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbYEEXRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:17:08 -0400
Date: Tue, 6 May 2008 09:17:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] linux-next: Tree for May 5 kernel bug at
 arch/x86/kernel/io_apic_64.c:353!
Message-Id: <20080506091700.0dfbeb7a.sfr@canb.auug.org.au>
In-Reply-To: <481ED722.1020804@linux.vnet.ibm.com>
References: <20080505151538.23eb89c5.sfr@canb.auug.org.au>
	<481ED722.1020804@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_May_2008_09_17_00_+1000_1E9QxW+n+GbiUiVS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_May_2008_09_17_00_+1000_1E9QxW+n+GbiUiVS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Just adding Ingo to the cc ...

On Mon, 05 May 2008 15:15:06 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> Hi Stephen,
>=20
> This BUG_ON() with next-20080505 kernel is hit on x86_64 machine with 32 =
cpus.
> Kernel boots up when, passing noapic as boot parameter.
>=20
> kernel BUG at arch/x86/kernel/io_apic_64.c:353!
> invalid opcode: 0000 [1] SMP=20
> last sysfs file:=20
> CPU 24=20
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.26-rc1-next-20080505-autotest #1
> RIP: 0010:[<ffffffff8021cfba>]  [<ffffffff8021cfba>] add_pin_to_irq+0x7a/=
0x90
> RSP: 0018:ffff81090e4cbb80  EFLAGS: 00010216
> RAX: 00000000000000f0 RBX: 00000000000000f0 RCX: 0000000000000001
> RDX: 0000000000000018 RSI: 0000000000000006 RDI: 00000000000000f0
> RBP: 0000000000000006 R08: 0000000000000018 R09: 0000000000000006
> R10: 0000000000000008 R11: ffffffff80394926 R12: 0000000000000001
> R13: 0000000000000001 R14: 0000000000000018 R15: ffff81090e4cbc24
> FS:  0000000000000000(0000) GS:ffff810bfe7cf540(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff81090e4ca000, task ffff81061e4ca0=
50)
> Stack:  0000000000000006 ffffffff8021d04e 00000000000000f0 00000000000000=
01
>  0000000000000000 0000000000000000 ffff81090e4cbc20 ffffffff8021b290
>  00000000000000f0 0000000000000000 0000000000000001 ffffffff80219e8a
> Call Trace:
>  [<ffffffff8021d04e>] io_apic_set_pci_routing+0x7e/0xb0
>  [<ffffffff8021b290>] mp_register_gsi+0xc0/0xe0
>  [<ffffffff80219e8a>] acpi_register_gsi+0x6a/0x70
>  [<ffffffff80394b50>] acpi_pci_irq_enable+0x14f/0x1f9
>  [<ffffffff80394926>] acpi_pci_allocate_irq+0x0/0x4c
>  [<ffffffff8036e70a>] do_pci_enable_device+0x4a/0x70
>  [<ffffffff8036e781>] __pci_enable_device_flags+0x51/0x60
>  [<ffffffff804dac78>] tg3_init_one+0x58/0x15e0
>  [<ffffffff8022be40>] default_wake_function+0x0/0x10
>  [<ffffffff80231a50>] set_cpus_allowed_ptr+0xd0/0x100
>  [<ffffffff803703bf>] pci_device_probe+0xdf/0x130
>  [<ffffffff803c3526>] driver_probe_device+0x96/0x1a0
>  [<ffffffff803c36b9>] __driver_attach+0x89/0x90
>  [<ffffffff803c3630>] __driver_attach+0x0/0x90
>  [<ffffffff803c2b9d>] bus_for_each_dev+0x4d/0x80
>  [<ffffffff80292288>] kmem_cache_alloc+0xc8/0xf0
>  [<ffffffff803c308e>] bus_add_driver+0xae/0x220
>  [<ffffffff803c3946>] driver_register+0x56/0x130
>  [<ffffffff80370665>] __pci_register_driver+0x55/0xa0
>  [<ffffffff806a8a44>] kernel_init+0x154/0x2e0
>  [<ffffffff8020c3c8>] child_rip+0xa/0x12
>  [<ffffffff806a88f0>] kernel_init+0x0/0x2e0
>  [<ffffffff8020c3be>] child_rip+0x0/0x12
>=20
>=20
> Code: 89 05 07 86 41 00 7f 29 48 0f bf c1 48 8d 14 00 48 c1 e0 03 48 29 d=
0 48 8d 90 20 10 72 80 66 89 32 66 44 89 42 02 48 83 c4 08 c3 <0f> 0b eb fe=
 66 90 48 c7 c7 38 34 5c 80 31 c0 e8 d2 9f 01 00 66=20
> RIP  [<ffffffff8021cfba>] add_pin_to_irq+0x7a/0x90
>  RSP <ffff81090e4cbb80>
> ---[ end trace d31308394cb604eb ]---
> Kernel panic - not syncing: Attempted to kill init!
> Pid: 1, comm: swapper Tainted: G      D   2.6.26-rc1-next-20080505-autote=
st #1
>=20
> Call Trace:
>  [<ffffffff80237026>] panic+0x86/0x170
>  [<ffffffff80237d8e>] printk+0x4e/0x60
>  [<ffffffff8023ad31>] do_exit+0x761/0x770
>  [<ffffffff8020c871>] oops_end+0xc1/0xd0
>  [<ffffffff8020ddf6>] do_invalid_op+0x86/0xa0
>  [<ffffffff8021cfba>] add_pin_to_irq+0x7a/0x90
>  [<ffffffff803ad724>] vt_console_print+0x224/0x2f0
>  [<ffffffff80373f60>] dummycon_dummy+0x0/0x10
>  [<ffffffff804ea179>] error_exit+0x0/0x51
>  [<ffffffff80394926>] acpi_pci_allocate_irq+0x0/0x4c
>  [<ffffffff8021cfba>] add_pin_to_irq+0x7a/0x90
>  [<ffffffff8021d04e>] io_apic_set_pci_routing+0x7e/0xb0
>  [<ffffffff8021b290>] mp_register_gsi+0xc0/0xe0
>  [<ffffffff80219e8a>] acpi_register_gsi+0x6a/0x70
>  [<ffffffff80394b50>] acpi_pci_irq_enable+0x14f/0x1f9
>  [<ffffffff80394926>] acpi_pci_allocate_irq+0x0/0x4c
>  [<ffffffff8036e70a>] do_pci_enable_device+0x4a/0x70
>  [<ffffffff8036e781>] __pci_enable_device_flags+0x51/0x60
>  [<ffffffff804dac78>] tg3_init_one+0x58/0x15e0
>  [<ffffffff8022be40>] default_wake_function+0x0/0x10
>  [<ffffffff80231a50>] set_cpus_allowed_ptr+0xd0/0x100
>  [<ffffffff803703bf>] pci_device_probe+0xdf/0x130
>  [<ffffffff803c3526>] driver_probe_device+0x96/0x1a0
>  [<ffffffff803c36b9>] __driver_attach+0x89/0x90
>  [<ffffffff803c3630>] __driver_attach+0x0/0x90
>  [<ffffffff803c2b9d>] bus_for_each_dev+0x4d/0x80
>  [<ffffffff80292288>] kmem_cache_alloc+0xc8/0xf0
>  [<ffffffff803c308e>] bus_add_driver+0xae/0x220
>  [<ffffffff803c3946>] driver_register+0x56/0x130
>  [<ffffffff80370665>] __pci_register_driver+0x55/0xa0
>  [<ffffffff806a8a44>] kernel_init+0x154/0x2e0
>  [<ffffffff8020c3c8>] child_rip+0xa/0x12
>  [<ffffffff806a88f0>] kernel_init+0x0/0x2e0
>  [<ffffffff8020c3be>] child_rip+0x0/0x12
>=20
> --=20
> Thanks & Regards,
> Kamalesh Babulal,
> Linux Technology Center,
> IBM, ISTL.
>=20


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_May_2008_09_17_00_+1000_1E9QxW+n+GbiUiVS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIH5VwTgG2atn1QN8RArg6AJ9ZE3cGla8YHDV0UQ6EkXOdWWpOtgCggBiq
o6aScaKkPI5UB8c2PiGapng=
=hobv
-----END PGP SIGNATURE-----

--Signature=_Tue__6_May_2008_09_17_00_+1000_1E9QxW+n+GbiUiVS--
