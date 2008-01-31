Return-Path: <linux-kernel-owner+w=401wt.eu-S1765350AbYAaI2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765350AbYAaI2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764380AbYAaI1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:27:54 -0500
Received: from chello089077127128.chello.pl ([89.77.127.128]:56838 "EHLO
	astralstorm.puszkin.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbYAaI1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:27:31 -0500
Date: Thu, 31 Jan 2008 09:26:40 +0100
From: Radoslaw Szkodzinski (AstralStorm) <lkml@astralstorm.puszkin.org>
To: "Steve French" <smfrench@gmail.com>
Cc: "Jeff Layton" <jlayton@redhat.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Guenter Kukkukk" <linux@kukkukk.com>, samba-technical@lists.samba.org,
       linux-kernel@vger.kernel.org, sfrench@samba.org
Subject: Re: [2.6 patch] remove smbfs
Message-ID: <20080131092640.5bc79dbd@astralstorm.puszkin.org>
In-Reply-To: <524f69650801301730m42abca6dn76d21fbdddbe89b5@mail.gmail.com>
References: <20080128220835.GF8767@does.not.exist>
	<200801302216.13788.linux@kukkukk.com>
	<20080130174103.17ff8197@tleilax.poochiereds.net>
	<20080130225810.GU29368@does.not.exist>
	<20080130193412.61c6e2e9@tleilax.poochiereds.net>
	<20080131004717.GX29368@does.not.exist>
	<20080130201350.7a576203@tleilax.poochiereds.net>
	<524f69650801301730m42abca6dn76d21fbdddbe89b5@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/O4llMdYloMS7sHMZ9qktUVY";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/O4llMdYloMS7sHMZ9qktUVY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jan 2008 19:30:55 -0600
"Steve French" <smfrench@gmail.com> wrote:

> On Jan 30, 2008 7:13 PM, Jeff Layton <jlayton@redhat.com> wrote:
> > On Thu, 31 Jan 2008 02:47:17 +0200
> > > > > > > In addition, cifs cannot completely replace smbfs atm.
> > > > > > > Even todays sold NAS-boxes (often running anchient
> > > > > > > samba-2.x.x) work only with smbfs on the client side.
> I am not convinced that this (mounting to older servers) would be a
> problem with the proper mount options but it is more intuitive for
> smbfs for some of the lanman servers.   I do want to make sure that we
> don't make it too easy to mount with insecure lanman (ie due to
> downgrade attacks) without the user at least doing that (specify weak
> lanman security explicitly).  Today the user has to explicitly specify
> sec=3Dlanman which is confusing but at least makes explicit the weaker
> security.
>=20
> There are four common issues with mounting to these very old servers:
> 1) remembering to mount specifying lanman security (sec=3Dlanman)

I think it'd be nice to add an alias called oldsmb or similar for that
option in mount.cifs. It should only be needed for old win9x servers.

--Sig_/O4llMdYloMS7sHMZ9qktUVY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHoYZLBlhXA0ALOYMRAm98AJ9BRW54fyQNHhCN8SON7JcWbAqLKQCdGjyA
Da2G1U4I2K8RnCzhLkHMFvU=
=+pqR
-----END PGP SIGNATURE-----

--Sig_/O4llMdYloMS7sHMZ9qktUVY--
