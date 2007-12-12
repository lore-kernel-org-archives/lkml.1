Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbXLLOw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbXLLOw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbXLLOwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:52:49 -0500
Received: from os.eurotux.com ([216.75.63.6]:54336 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXLLOwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:52:49 -0500
Date: Wed, 12 Dec 2007 14:52:41 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: ldm@flatcap.org, ntfs-3g-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ntfs-dev@lists.sourceforge.net
Subject: Re: ldminfo compilation
Message-ID: <20071212145241.GA25092@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Alon Bar-Lev <alon.barlev@gmail.com>, ldm@flatcap.org,
	ntfs-3g-devel@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>,
	linux-ntfs-dev@lists.sourceforge.net
References: <9e0cf0bf0712120639r7bd5582bg63f8512164836989@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <9e0cf0bf0712120639r7bd5582bg63f8512164836989@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 12, 2007 at 04:39:18PM +0200, Alon Bar-Lev wrote:
> Hello,
>=20
> I need to compile the ldminfo utility of linux-ntfs's package
> linux-ldm. I need this as static or uclibc based.
>=20
> The author stated in the Documentation/filesystems/ntfs.txt:
> """You will find the precompiled (i386) ldminfo utility there.  NOTE:
> You will not be able to compile this yourself easily so use the binary
> version!"""
>=20
> I don't like to use binary versions, but this is not so important....
> I cannot use this dynamic linked x86 anyway.
>=20
> Looking at the sources, it seems that the linux headers used in order
> to build this are out of date...

Those are for the kernel module setting the partition tables. If you're
only interested in the ldminfo utility:
make -C ldmutil CPP=3D'g++ -static'

Substitute g++ for the C++ compiler you want to use.

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHX/W5inSul6a7oB8RAszuAKCOULjTQCPTauHoBRVeCjc+PEzmHgCeO+JS
EqqYlnPvmp6GqVelgi0jS2k=
=RNQ4
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
