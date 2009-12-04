Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZLDKVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZLDKVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbZLDKVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:21:32 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48842 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbZLDKVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:21:31 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Howells <dhowells@redhat.com>
Subject: Re: [uClinux-dev] Re: [PATCH] FDPIC: respect PT_GNU_STACK exec markings when creating NOMMU stack
Date: Fri, 4 Dec 2009 05:26:46 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.31.4; KDE/4.3.4; x86_64; ; )
Cc: uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org,
       Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
References: <200912040207.09801.vapier@gentoo.org> <16680.1259863084@redhat.com> <31066.1259919632@redhat.com>
In-Reply-To: <31066.1259919632@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1551683.CkTYhXZ7tR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200912040526.47709.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1551683.CkTYhXZ7tR
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 04 December 2009 04:40:32 David Howells wrote:
> Mike Frysinger <vapier@gentoo.org> wrote:
> > > 	+	flush_icache_range(mm->brk, brk);
> > > 		return mm->brk =3D brk;
> > > 	 }
> >
> > probably want mm->brk + brk for the second argument
>=20
> Ummm...  Why?  mm->brk and brk are both addresses - note the return
>  statement where brk just gets assigned to mm->brk.

yeah, sorry.  i was thinking sbrk where the argument is an increment, not a=
=20
new address.
=2Dmike

--nextPart1551683.CkTYhXZ7tR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iQIcBAABAgAGBQJLGOPnAAoJEEFjO5/oN/WBGp0P/RXp0w+v+udLSmas4dAzuuzx
nsXAKoeOTwDplXsiOOP2VHBROJEtYdCsiQLNcRvXfeETc479dDXAecfCz/IAC78P
e/fUGPe5WTN0XitxkY6x3yAG/Wbma5VmZv89e/etdhIYNoOLYMulefnuZLWROPAa
tcj77fH6fAtaCga5vQDtJnJyIXoGb5BX/EwS27A4HJLAQdl4l2myhokBzN/Wf1vu
aYKW1hkaT6cJLfY+6SxIvanJIFH+Ng0VOxzhXbIv0Om+2VJt1uBFqRuVbxwnZ29V
zKZ+KP+2NeG6MKaRz7BMqq+nPZn0/jzdJJtHfM1NeZlBqRyxzW5Y8U1YBVEhpD4B
Np9gVOKP+w/JosXd8+JF8tuB/MZKvDCKBHQQUE6GzcEdDVrkVTo/vUETP1D4N/Hq
0eZww9ER523JPftGePG+DZAr18aS8wGynhzn/qpSDyxT0glJ1X6H4xVYKDC7vdBX
kMKljHkQmpOdxaXCkx2aW/Yoi3rBN8qphTRRlys8wWFzjehEYO7Wg2qubghCGkMH
sW29FiIScCHNSvU8k3TAHTePzDxzdmts9s8P8Sy8vgcQouonc3BvpiO7j+6q7407
+fqIFlrEskIrPwfLnE0fe3ujQ/DU5qjmKuK4TL1P6V9FgndACfD11USdO0oyrVse
7yWA1dImW7SJvZv7srcI
=Fp9l
-----END PGP SIGNATURE-----

--nextPart1551683.CkTYhXZ7tR--
