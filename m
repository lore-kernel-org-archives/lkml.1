Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZETUQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZETUQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 16:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZETUQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 16:16:47 -0400
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:56558 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755338AbZETUQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 16:16:46 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/3] ath5k: add support for radio LED
Date: Wed, 20 May 2009 22:16:42 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-rc6; KDE/4.2.85; i686; ; )
Cc: linville@tuxdriver.com, mickflemm@gmail.com, lrodriguez@atheros.com,
       me@bobcopeland.com, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1242850139-25438-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1501703.Y9m31oCrUy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905202216.43996.tobias.doerffel@gmail.com>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 85efea2434610bb461976c4d7ea3ef3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1501703.Y9m31oCrUy
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Am Mittwoch, 20. Mai 2009 22:08:57 schrieb Jiri Slaby:
> From: Tobias Doerffel <tobias.doerffel@gmail.com>
>
> I found these patches on the web not being merged since Jan. Was
> there any reason why they shouldn't be accepted?
Yes - they needed further work. The approach was wrong because the GPIO doe=
s=20
not control the LED rather than some internal rfkill mechanism (which itsel=
f=20
controls the LED). I therefore reworked things to have general RFKILL suppo=
rt=20
in ath5k and proposed the patches. They were reviewed by Bob Copeland and I=
=20
addressed most of the issues so far but didn't come up with a new patch yet=
,=20
as there're still minor things to be worked out. If there's interest, I'll=
=20
prepare a new patch which represents the current state.

Toby

--nextPart1501703.Y9m31oCrUy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoUZSsACgkQHsjdpw2OaacIQwCbB3fCcItVpkfOF2UHj9KJF0LZ
jR8AoLx4RPtL3JLOb64PHd6J7uevblc2
=KfUF
-----END PGP SIGNATURE-----

--nextPart1501703.Y9m31oCrUy--
