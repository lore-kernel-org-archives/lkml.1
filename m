Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYETBZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYETBZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 21:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbYETBY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 21:24:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:19490 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbYETBY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 21:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=Rf4z2sbsvUNJ8H6+PQKiUFh5Z4R7PPUodHg0lBxyTPkHXQ0p6m6vLa6bXrT/7bf0P/XF4XGk9ObcJBQtNxFHQWOIos6SvHvzYFBPFy3O1nKv45WsRbJqYtqcu1OaRRc9HSem4021oy7gh9odG6ZZVNqlD3VYNlYCFXu8BBqgO38=
Date: Tue, 20 May 2008 02:24:46 +0100
From: Ciaran McCreesh <ciaran.mccreesh@googlemail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr
 after e820_reserve_resources
Message-ID: <20080520022446.3b9c335a@googlemail.com>
In-Reply-To: <86802c440805191822v5b572d03t1568b27eb2defa4a@mail.gmail.com>
References: <20080518014111.4f32298b@googlemail.com>
	<86802c440805172055x30c2c6feg441e16f5fb24f64f@mail.gmail.com>
	<20080518164127.2236d82a@googlemail.com>
	<86802c440805181400m5a3b4e28oeab6245e9a2ffd00@mail.gmail.com>
	<20080518232347.7964835c@snowcone>
	<86802c440805182043n2a4855bcw6924f6df2fbdc9f4@mail.gmail.com>
	<20080520014405.5eb150cd@googlemail.com>
	<86802c440805191822v5b572d03t1568b27eb2defa4a@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/sskltneETbm9.f=.we0EsDd";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sskltneETbm9.f=.we0EsDd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 May 2008 18:22:00 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> >> could be pci iomem conflicts...
> >> please enable CONFIG_PCI_DEBUG=3Dy
> >> and apply the following two debug patches
> >
> > dmesg with debugging attached.
>=20
> the iomem allocation seems good...
>=20
> can you send out /proc/iomem?

00000000-0009ffff : pnp 00:09
000f0000-000fffff : pnp 00:09
00100000-d7feffff : pnp 00:09
d7ff0000-d7ffffff : pnp 00:09
d8000000-dfffffff : PCI Bus 0000:01
  d8000000-dfffffff : 0000:01:05.0
e0000000-efffffff : PCI MMCONFIG 0
  e0000000-efffffff : pnp 00:08
fdb00000-fdbfffff : PCI Bus 0000:03
fdc00000-fdcfffff : PCI Bus 0000:03
  fdcff000-fdcff0ff : 0000:03:05.0
    fdcff000-fdcff0ff : 8139too
fdd00000-fddfffff : PCI Bus 0000:02
  fdd00000-fdd1ffff : 0000:02:00.0
fde00000-fdefffff : PCI Bus 0000:02
  fdeff000-fdefffff : 0000:02:00.0
    fdeff000-fdefffff : r8169
fdf00000-fdffffff : PCI Bus 0000:01
  fdf00000-fdf03fff : 0000:01:05.2
    fdf00000-fdf03fff : ICH HD audio
  fdff0000-fdffffff : 0000:01:05.0
fe024000-fe027fff : 0000:00:14.2
  fe024000-fe027fff : ICH HD audio
fe029000-fe0290ff : 0000:00:13.5
  fe029000-fe0290ff : ehci_hcd
fe02a000-fe02afff : 0000:00:13.4
  fe02a000-fe02afff : ohci_hcd
fe02b000-fe02bfff : 0000:00:13.3
  fe02b000-fe02bfff : ohci_hcd
fe02c000-fe02cfff : 0000:00:13.2
  fe02c000-fe02cfff : ohci_hcd
fe02d000-fe02dfff : 0000:00:13.1
  fe02d000-fe02dfff : ohci_hcd
fe02e000-fe02efff : 0000:00:13.0
  fe02e000-fe02efff : ohci_hcd
fe02f000-fe02f3ff : 0000:00:12.0
  fe02f000-fe02f3ff : ahci
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : pnp 00:09
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : 0000:00:14.0
    fed00000-fed000ff : pnp 00:09
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : pnp 00:09
ffff0000-ffffffff : pnp 00:09
100000000-11fffffff : System RAM
  00200000-005d348d : Kernel code
  005d348e-00771927 : Kernel data
  007df000-0085f74f : Kernel bss

Thanks,
--=20
Ciaran McCreesh

--Sig_/sskltneETbm9.f=.we0EsDd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkgyKGEACgkQ96zL6DUtXhGaxgCfRoQ/ffKABPxEL11Hl7MKcwTp
QN0AoMRoGTutC+iu5e9Cwbavo20J1vng
=yYPt
-----END PGP SIGNATURE-----

--Sig_/sskltneETbm9.f=.we0EsDd--
