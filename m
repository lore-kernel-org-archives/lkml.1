Return-Path: <linux-kernel-owner+w=401wt.eu-S2992943AbXDTLVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992943AbXDTLVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992953AbXDTLVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:21:53 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:38144 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992943AbXDTLVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:21:52 -0400
Subject: Re: VMWare Workstation 6 for debugging Linux Kernel (!)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Andi Kleen <andi@firstfloor.org>
Cc: Xavier Bestel <xavier.bestel@free.fr>, roland <devzero@web.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <p73r6qf49zc.fsf@bingen.suse.de>
References: <03f401c782d4$95c323e0$eeeea8c0@aldipc>
	 <1177058522.14404.132.camel@frg-rhel40-em64t-04>
	 <p73r6qf49zc.fsf@bingen.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ubhYvmd9BfEaKQ5P+rYA"
Date: Fri, 20 Apr 2007 21:21:47 +1000
Message-Id: <1177068108.11136.11.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ubhYvmd9BfEaKQ5P+rYA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Fri, 2007-04-20 at 12:27 +0200, Andi Kleen wrote:
> Xavier Bestel <xavier.bestel@free.fr> writes:
>=20
> > On Fri, 2007-04-20 at 00:46 +0200, roland wrote:
> >=20
> > > We just quietly added an exciting feature to Workstation 6.0. I belie=
ve it=20
> > > will make WS6 a great tool for Linux kernel development. You can now =
debug=20
> > > kernel of Linux VM with gdb running on the Host without changing anyt=
hing in=20
> > > the Guest VM. No kdb, no recompiling and no need for second machine. =
All you=20
> > > need is a single line in VM's configuration file.
> >=20
> > I think qemu has the exact same feature.
>=20
> It doesn't seem to work for x86-64 there though.

You mean the VMware one doesn't work? I tried it and got:

(gdb) target remote localhost:8832=20
Remote debugging using localhost:8832=20
Ignoring packet error, continuing...=20
warning: unrecognized item "timeout" in "qSupported" respoonse=20
Ignoring packet error, continuing...=20
Ignoring packet error, continuing...=20
Ignoring packet error, continuing...=20
Malformed response to offset query, timeout=20
(gdb)

Hopefully that's not too hard to fix. Made the appropriate noises :)

Nigel

--=-ubhYvmd9BfEaKQ5P+rYA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGKKJLN0y+n1M3mo0RAl32AJ9yaGBDmmO5G+HATe8JmmbPFHI5aACfc8Vq
iam9YZcw9fgTv4NOHtC4yck=
=NK2o
-----END PGP SIGNATURE-----

--=-ubhYvmd9BfEaKQ5P+rYA--

