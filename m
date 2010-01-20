Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067Ab0ATNBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0ATNBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486Ab0ATNBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:01:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45360 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab0ATNBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:01:36 -0500
Date: Thu, 21 Jan 2010 00:01:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: kvm tree build warning
Message-Id: <20100121000128.cf11525c.sfr@canb.auug.org.au>
In-Reply-To: <3727B46C-0197-47A4-AF41-023517C15752@suse.de>
References: <20100120174814.43195995.sfr@canb.auug.org.au>
	<3727B46C-0197-47A4-AF41-023517C15752@suse.de>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Jan_2010_00_01_28_+1100_O2UAF5JILjFZKDIf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Jan_2010_00_01_28_+1100_O2UAF5JILjFZKDIf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alex,

On Wed, 20 Jan 2010 11:42:28 +0100 Alexander Graf <agraf@suse.de> wrote:
>
> This is odd. The same function saves and restores ext_bkp.vrsave under a =
common condition:
>=20
> So there can't be a case where ext_bkp.vrsave is read, but not written to=
 before, which is what this warning implies, right?

Right.

> Also, why doesn't gcc complain about vscr too then? They're both used in =
the very same if statement.

I have no idea how gcc makes these decisions. :-(

> Additionally, while compiling locally I looked for warnings and didn't sp=
ot any. So apparently our compiler versions / options don't match. Which ve=
rsion of gcc are you using? I assume a gcc bug.
>=20
> $ gcc --version
> gcc (SUSE Linux) 4.3.2 [gcc-4_3-branch revision 141291]

I use a 4.4.0 cross compiler (I should update it).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_Jan_2010_00_01_28_+1100_O2UAF5JILjFZKDIf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktW/qgACgkQjjKRsyhoI8w/pgCgsnczHyy8m0KWKbupJJpsEzfx
0oUAmgPFI3YB9bE2x+gWRGWFFJEb7NIA
=/1aL
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Jan_2010_00_01_28_+1100_O2UAF5JILjFZKDIf--
