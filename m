Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbYFNIRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbYFNIRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 04:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYFNIRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 04:17:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42822 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbYFNIRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 04:17:05 -0400
Date: Sat, 14 Jun 2008 18:16:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 13 (x86_64: panic)
Message-Id: <20080614181646.d91dcbda.sfr@canb.auug.org.au>
In-Reply-To: <20080613155809.7699fc11.randy.dunlap@oracle.com>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
	<20080613155809.7699fc11.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__14_Jun_2008_18_16_46_+1000_V9ctqLLaxCQGKoHr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__14_Jun_2008_18_16_46_+1000_V9ctqLLaxCQGKoHr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Fri, 13 Jun 2008 15:58:09 -0700 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> When booting linux-next-20080613, I'm seeing a panic (on x86_64):
>=20
>=20
> Freeing unused kernel memory: 380k freed
> Write protecting the kernel read-only data: 4616k
> uhci_hcd: version magic '2.6.26-rc6 SMP mod_unload ' should be '2.6.26-rc=
6-next-20080613 SMP mod_unload '
> ohci_hcd: version magic '2.6.26-rc6 SMP mod_unload ' should be '2.6.26-rc=
6-next-20080613 SMP mod_unload '
> ehci_hcd: version magic '2.6.26-rc6 SMP mod_unload ' should be '2.6.26-rc=
6-next-20080613 SMP mod_unload '
> cciss: version magic '2.6.26-rc6 SMP mod_unload ' should be '2.6.26-rc6-n=
ext-20080613 SMP mod_unload '

These look strange.  Are you sure you rebuilt and installed all your
modules and removed any old ones lying around?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__14_Jun_2008_18_16_46_+1000_V9ctqLLaxCQGKoHr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhTfm4ACgkQTgG2atn1QN9yTQCfR87Suz4+KMNiKAdprSprxc7F
/G8AnjRRkh4PVyqMi2JejsIk2vLyv8V+
=2gSA
-----END PGP SIGNATURE-----

--Signature=_Sat__14_Jun_2008_18_16_46_+1000_V9ctqLLaxCQGKoHr--
