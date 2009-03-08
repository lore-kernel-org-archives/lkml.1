Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZCHM1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZCHM1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 08:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZCHM1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 08:27:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41215 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256AbZCHM1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 08:27:08 -0400
X-Sasl-enc: Jg6gF/itm95yPbWX7lZAy5FW5n/05PIVhu/6N+0k7WRB 1236515224
Message-ID: <49B3B97B.5090308@imap.cc>
Date: Sun, 08 Mar 2009 13:26:35 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Paul Bolle <pebolle@tiscali.nl>, Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCH 1/2] gigaset: return -ENOSYS for unimplemented functions
References: <20090307-patch-00.tilman@imap.cc>	<20090307-patch-01.tilman@imap.cc>	<20090307142609.2995bb3d@infradead.org>	<49B30FC4.5040305@imap.cc>	<20090307163522.1165494b@infradead.org>	<49B3176A.7000004@imap.cc> <20090307173819.36d352c8@infradead.org>
In-Reply-To: <20090307173819.36d352c8@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig40F7EB796403E0284CD5E062"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig40F7EB796403E0284CD5E062
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 08.03.2009 02:38 schrieb Arjan van de Ven:
> from the ioctl manpage:
>=20
> ERRORS
> 	[snip]
>=20
>        ENOTTY The specified request does not apply to the kind of
>        object that the descriptor d references.

Ok, I'm convinced. I'll redo the patch with ENOTTY instead of ENOSYS.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig40F7EB796403E0284CD5E062
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFJs7mSQ3+did9BuFsRAsXxAJ9CLmk6MvK7v9kU1MLf1ihqIAoGDgCfbK5p
5R6NfmJYTYjA5i9j+mEUBI8=
=TRh8
-----END PGP SIGNATURE-----

--------------enig40F7EB796403E0284CD5E062--
