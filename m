Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435Ab0AUXIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0AUXIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 18:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277Ab0AUXIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 18:08:45 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36854 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834Ab0AUXIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 18:08:44 -0500
X-Sasl-enc: 83/MH1TO/rS19XRvzWYDkHyz16xcbmQ4Fsa6L23CAuGj 1264115313
Message-ID: <4B58DC99.9040302@imap.cc>
Date: Fri, 22 Jan 2010 00:00:41 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 21
References: <20100121165713.7b8a746d.sfr@canb.auug.org.au> <20100121131339.5e86dfef.akpm@linux-foundation.org>
In-Reply-To: <20100121131339.5e86dfef.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF4E8330C0909BE9E4D8FE4DD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF4E8330C0909BE9E4D8FE4DD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 21.01.2010 22:13 schrieb Andrew Morton:
> On Thu, 21 Jan 2010 16:57:13 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
>> I have created today's linux-next tree at
>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>=20
> It includes this screwed up commit:
>=20
> :commit e303d9eadc64907535a0a104afa5871d2b83275e
> :Author:     Tilman Schmidt <tilman@imap.cc>
> :AuthorDate: Thu Jan 14 23:18:41 2010 +0100
> :Commit:     Jesse Barnes <jbarnes@virtuousgeek.org>
> :CommitDate: Fri Jan 15 10:08:07 2010 -0800
> :
> :    PCI/ISDN: push deprecated pci_find_device() function to last user =
(isdn)
> :   =20
> :    The ISDN4Linux HiSax driver family contains the last remaining use=
rs of
> :    the deprecated pci_find_device() function. This patch creates a pr=
ivate
> :    copy of that function in HiSax, and removes the now unused global
> :    function together with its controlling configuration option,
> :    CONFIG_PCI_LEGACY.
> :   =20
> :    Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> :    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>=20
> It adds a bunch of files which are compile-time generated:
>=20
> include/linux/autoconf.h
> include/linux/bounds.h
> include/linux/compile.h
> include/linux/utsrelease.h

That's not the patch I submitted. Mine did not add any new files.

What's more, I've since submitted a new version, fixing the reported
build failure with CONFIG_PCI=3Dn:

Subject: [PATCH/v2] pci: push deprecated pci_find_device() function to la=
st user
Message-Id: <20100118162410.4562840108@xenon.ts.pxnet.com>
Date: 	Mon, 18 Jan 2010 17:24:10 +0100 (CET)

So please drop the patch above, and include the latter one instead.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigF4E8330C0909BE9E4D8FE4DD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAktY3KYACgkQQ3+did9BuFvH2gCdHRqgcX+B8yaGEYce3ipXoq6k
5OsAoIha0DT8krEOsI4CJ+0jRQzjB/VU
=QY+f
-----END PGP SIGNATURE-----

--------------enigF4E8330C0909BE9E4D8FE4DD--
