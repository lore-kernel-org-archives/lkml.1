Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYJXLVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYJXLVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbYJXLVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:21:46 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:1048 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYJXLVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:21:45 -0400
Message-ID: <4901AFB8.1030806@imap.cc>
Date: Fri, 24 Oct 2008 13:21:28 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCH 72/80] tty: fix up gigaset a bit
References: <20081013092758.21645.2359.stgit@localhost.localdomain>	<20081013094438.21645.30934.stgit@localhost.localdomain>	<48F762CA.4080608@imap.cc>	<20081017124004.64d3f2cf@lxorguk.ukuu.org.uk>	<48FB27F1.9010007@imap.cc> <20081022100045.2f06e977@lxorguk.ukuu.org.uk>
In-Reply-To: <20081022100045.2f06e977@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFD071BF516D1BB61349C2DC9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFD071BF516D1BB61349C2DC9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 22.10.2008 11:00 Alan Cox wrote:
> Fiddling with tty->disc_data by hand probably currently does the right
> thing. I don't guarantee it will continue to do so after the BKL remova=
l
> gets to ldisc setting.

I never expected you to guarantee anything. :-)
Anyway, I'll continue keeping my eyes open for changes in the tty area.
Should you come across a specific problem with the driver, feel free
to drop me a line.

> If you really don't need the poll then it can go - for 2.6.29. The
> current code isn't wrong on a functional level it just returns unexpect=
ed
> results in the unplug case.

Ok, if it won't make it for 2.6.28 anyway then I don't have to rush
and can take my time submitting this through the proper channels.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigFD071BF516D1BB61349C2DC9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJAa+5Q3+did9BuFsRAgjDAJ9kUQnm2yvUwjOfvTEyeXv85ODW6gCcCGnZ
AAcUcYXLRAw/4ByP3mSkSmo=
=lz0p
-----END PGP SIGNATURE-----

--------------enigFD071BF516D1BB61349C2DC9--
