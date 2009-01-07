Return-Path: <linux-kernel-owner+w=401wt.eu-S1762022AbZAGVgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762022AbZAGVgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761904AbZAGVgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:36:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38480 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761872AbZAGVgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:36:21 -0500
Date: Thu, 8 Jan 2009 08:36:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Tim Bird <tim.bird@am.sony.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH V3 01/17] Squashfs: inode operations
Message-Id: <20090108083609.97f0703a.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0901071854210.32034@vixen.sonytel.be>
References: <E1LJnJn-0002L2-GZ@dylan.lougher.demon.co.uk>
	<Pine.LNX.4.64.0901071854210.32034@vixen.sonytel.be>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__8_Jan_2009_08_36_09_+1100_IRCI5g.wNKF4sD4i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Jan_2009_08_36_09_+1100_IRCI5g.wNKF4sD4i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Wed, 7 Jan 2009 19:00:24 +0100 (CET) Geert Uytterhoeven <Geert.Uytterhoe=
ven@sonycom.com> wrote:
>
> Note that I get lots of
>=20
> | warning: format '%llx' expects type 'long long unsigned int', but argum=
ent 3 has type 'u64'
>=20
> on ppc64, since you switched from `unsigned long long' to 'u64', as `u64'=
 is
> (still -- this is being changed) `unsigned long' on pp64.
>=20
> I guess no action has to be taken, for now?

Correct, as we are in the process of changing u64 to unsigned long long for
powerpc.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__8_Jan_2009_08_36_09_+1100_IRCI5g.wNKF4sD4i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkllIEkACgkQjjKRsyhoI8z+kACgqYc6WZOOWrsC3r7DIQxcBfZT
ddUAoKQX7RBP6l9WH98d3MgBSQ/3fPDf
=JuME
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Jan_2009_08_36_09_+1100_IRCI5g.wNKF4sD4i--
