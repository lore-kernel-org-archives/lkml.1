Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZJUVhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZJUVhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZJUVhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:37:39 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:32914 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172AbZJUVhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:37:38 -0400
X-Sasl-enc: XGj3Bv4qFI1YjnAzPZvG4dDWgatIGuQ6ZEbftGnFPXnA 1256161061
Message-ID: <4ADF7F14.7000109@imap.cc>
Date: Wed, 21 Oct 2009 23:37:24 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless@vger.kernel.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org,
       Michael Buesch <mb@bu3sch.de>, Oliver Hartkopp <oliver@hartkopp.net>
Subject: Re: [PATCH] net: Adjust softirq raising in __napi_schedule
References: <4AD31213.6020006@imap.cc> <20091015114052.GA9870@ff.dom.local>	 <4AD76184.6030900@gmail.com> <4ADF5710.4030505@imap.cc>	 <20091021211906.GA11401@ami.dom.local> <1256160330.12174.2.camel@johannes.local>
In-Reply-To: <1256160330.12174.2.camel@johannes.local>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDAACCF859094B8E8B38A9ACE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDAACCF859094B8E8B38A9ACE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Johannes Berg schrieb:

> This still doesn't make any sense.
>=20
> There may or may not be a lot of code that assumes that everything else=

> is run with other tasklets disabled, and that it cannot be interrupted
> by a tasklet and thus create a race.
>=20
> Can you prove that is not the case, across the entire networking layer?=


So what's the solution you propose?

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enigDAACCF859094B8E8B38A9ACE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFK338hQ3+did9BuFsRAtISAJ4oNk4ReXpVPsa9anMPGvdsfNvsfwCgk2IP
MEhjd2ockMWp9P01SjKtdOA=
=18hp
-----END PGP SIGNATURE-----

--------------enigDAACCF859094B8E8B38A9ACE--
