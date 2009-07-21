Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZGUAOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZGUAOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 20:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbZGUAOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 20:14:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34684 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbZGUAOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 20:14:08 -0400
Date: Tue, 21 Jul 2009 10:13:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
       Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-Id: <20090721101355.c32a0d27.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.01.0907201110390.13838@localhost.localdomain>
References: <20090720040813.GC11940@kroah.com>
	<200907201613.22483.wolfgang.walter@stwm.de>
	<20090720150916.GB10015@suse.de>
	<20090720180333.GA2905@brouette>
	<alpine.LFD.2.01.0907201110390.13838@localhost.localdomain>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Jul_2009_10_13_55_+1000_As0gsyLpMMjDjU_g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Jul_2009_10_13_55_+1000_As0gsyLpMMjDjU_g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Jul 2009 11:16:17 -0700 (PDT) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> Why? Many distro's use ccache, and so you may actually get a cached objec=
t=20
> file from a previous compile (with a previous compiler). Now, ccache is=20
> pretty good at noticing when things change, and I can well imagine that i=
t=20
> also checks the compiler version (in addition to checking the hash of the=
=20
> preprocessed output and build flags etc), but I haven't double-checked.
>=20
> So to make doubly sure that you really don't end up using cached object=20
> files, you might want to run "ccache -C".

ccache includes, in the hash of the preprocessed file, "the real compilers
size and modification time", so will probably notice an upgrade or
downgrade of the compiler.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Jul_2009_10_13_55_+1000_As0gsyLpMMjDjU_g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkplCEMACgkQjjKRsyhoI8ylJQCfedyUFWHTyu5k3QQP37+EItBW
CLMAnRWZEABEbrqX8sNGLNEold4aX3uN
=s8Gy
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Jul_2009_10_13_55_+1000_As0gsyLpMMjDjU_g--
