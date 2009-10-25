Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZJYXhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZJYXhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 19:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZJYXhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 19:37:07 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59187 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753850AbZJYXhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 19:37:05 -0400
X-Sasl-enc: nPsQQ1BN+QjnReAwQNY9F2nnwnIU6KqbzRtjDHJAyfqS 1256513830
Message-ID: <4AE4E11A.7000303@imap.cc>
Date: Mon, 26 Oct 2009 00:36:58 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
CC: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>,
       Hansjoerg Lipp <hjlipp@web.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH 6/9] ser_gigaset: checkpatch cleanup
References: <20091023-patch-gigaset-00.tilman@imap.cc>	<20091023-patch-gigaset-06.tilman@imap.cc> <20091025203705.273e1c14@lxorguk.ukuu.org.uk>
In-Reply-To: <20091025203705.273e1c14@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7E1AB0FC8147A4887EAAB293"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7E1AB0FC8147A4887EAAB293
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Alan Cox schrieb:

>> -		if (!(bcs->tx_skb =3D skb_dequeue(&bcs->squeue)))
>> +		nextskb =3D skb_dequeue(&bcs->squeue);
>> +		if (!nextskb)
>>  			/* no skb either, nothing to do */
>>  			return;
>> +		bcs->tx_skb =3D nextskb;
>=20
> This does not do the same thing as before
>=20
> Previously the NULL case assigned to bcs->tx_skb, now it does not.

bcs->tx_skb is guaranteed to be NULL already at this point because
of the enclosing "if (!bcs->tx_skb)".

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig7E1AB0FC8147A4887EAAB293
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFK5OEjQ3+did9BuFsRAl/4AKCV+POputvvUCb+0CmnP2lU9GLN/gCcCOic
b2ztIds8HlT3P/6E3nIeaQY=
=/tZZ
-----END PGP SIGNATURE-----

--------------enig7E1AB0FC8147A4887EAAB293--
