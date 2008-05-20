Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbYETDRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbYETDRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 23:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbYETDRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 23:17:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:59164 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbYETDRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 23:17:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=kfKmkodf8IrD/g6tjryCvQC5ZYDckUzGnA4mqdUHAFl1m8IU+wnV98eekljj/HU7UClN8uj6X8l3wYhsAoy+0acbfjMH3/p6MwJE6rhcZhMExB1jD0JFDVaTiarcg+td/O1BwX6Dpr6iWkzKG+5olFQz8T3BzRH6U7o6qQ0vN3Y=
Date: Tue, 20 May 2008 04:16:55 +0100
From: Ciaran McCreesh <ciaran.mccreesh@googlemail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr
 after e820_reserve_resources
Message-ID: <20080520041655.0552236d@googlemail.com>
In-Reply-To: <86802c440805191948h29769798qecc93b7aa5c9cd91@mail.gmail.com>
References: <20080518014111.4f32298b@googlemail.com>
	<86802c440805172055x30c2c6feg441e16f5fb24f64f@mail.gmail.com>
	<20080518164127.2236d82a@googlemail.com>
	<86802c440805181400m5a3b4e28oeab6245e9a2ffd00@mail.gmail.com>
	<20080518232347.7964835c@snowcone>
	<86802c440805182043n2a4855bcw6924f6df2fbdc9f4@mail.gmail.com>
	<20080520014405.5eb150cd@googlemail.com>
	<86802c440805191822v5b572d03t1568b27eb2defa4a@mail.gmail.com>
	<20080520022446.3b9c335a@googlemail.com>
	<86802c440805191948h29769798qecc93b7aa5c9cd91@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nOEaZA=6REKPfMOjbUd3Wjo";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nOEaZA=6REKPfMOjbUd3Wjo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 May 2008 19:48:38 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> >> >> could be pci iomem conflicts...
> >> >> please enable CONFIG_PCI_DEBUG=3Dy
> >> >> and apply the following two debug patches
> >> >
> >> > dmesg with debugging attached.
> >>
> >> the iomem allocation seems good...
> >>
> >> can you send out /proc/iomem?
> >
> > 00000000-0009ffff : pnp 00:09
> > <snip>
>=20
> seems acpi pnp resource cause some problem....
>=20
> please try attached patch and send out /proc/mtrr

The patch doesn't help I'm afraid.

/proc/mtrr is:

reg00: base=3D0x100000000 (4096MB), size=3D 512MB: write-back, count=3D1
reg01: base=3D0x00000000 (   0MB), size=3D2048MB: write-back, count=3D1
reg02: base=3D0x80000000 (2048MB), size=3D1024MB: write-back, count=3D1
reg03: base=3D0xc0000000 (3072MB), size=3D 256MB: write-back, count=3D1
reg04: base=3D0xd0000000 (3328MB), size=3D 128MB: write-back, count=3D1

Thanks,
--=20
Ciaran McCreesh

--Sig_/nOEaZA=6REKPfMOjbUd3Wjo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkgyQqsACgkQ96zL6DUtXhGw/wCfTpVnbknUO+MLXeAYVggXkNi/
g3IAoM11/ftjON1MnvMgssgOyM7OMJmJ
=Jjx7
-----END PGP SIGNATURE-----

--Sig_/nOEaZA=6REKPfMOjbUd3Wjo--
