Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZGAMVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZGAMVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZGAMUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:20:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47559 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZGAMUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:20:51 -0400
Date: Wed, 1 Jul 2009 22:20:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: boot failure
Message-Id: <20090701222042.57b0f4d3.sfr@canb.auug.org.au>
In-Reply-To: <4A4B4E1B.6090900@in.ibm.com>
References: <20090701160014.595e1338.sfr@canb.auug.org.au>
	<4A4B4E1B.6090900@in.ibm.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jul_2009_22_20_42_+1000_McLYd1rDOwqoVS1+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Jul_2009_22_20_42_+1000_McLYd1rDOwqoVS1+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sachin,

On Wed, 01 Jul 2009 17:22:59 +0530 Sachin Sant <sachinp@in.ibm.com> wrote:
>
> I too am facing similar issue on both Power and x86.
> Culprit seems to be 2nd patch in the above list.
>=20
> commit e1b79967e2b29839d16c12b534597a15d8630fc4
> audit: convert audit watches to use fsnotify instead of inotify
>=20
> I wasn't able to remove only patch 2 because of dependencies
> on other patches. After i reverted patches 2 to 7 in the above
> list, i was able to boot the machine. Then i applied patch 2
> and the machine failed to boot.

Thanks for tracking this down.  Now we just need a solution :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__1_Jul_2009_22_20_42_+1000_McLYd1rDOwqoVS1+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpLVJoACgkQjjKRsyhoI8z0LgCgsy4A3rEBIb80MnDAGDeOM+W4
D2AAoJ0lQbgscWnhUWdpkMIwu5Sh1vLl
=rphe
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jul_2009_22_20_42_+1000_McLYd1rDOwqoVS1+--
