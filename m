Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZE2Wd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZE2Wd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 18:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZE2WdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 18:33:16 -0400
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:53191 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753086AbZE2WdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 18:33:15 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] ath5k: added initial RFKILL support
Date: Sat, 30 May 2009 00:33:07 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-rc7; KDE/4.2.85; i686; ; )
Cc: Bob Copeland <me@bobcopeland.com>, Jiri Slaby <jirislaby@gmail.com>,
       ath5k-devel@venema.h4ckr.net, mickflemm@gmail.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com> <200905260124.03287.tobias.doerffel@gmail.com> <1243294366.29222.10.camel@johannes.local>
In-Reply-To: <1243294366.29222.10.camel@johannes.local>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1459946.JtoeU42TSx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905300033.12204.tobias.doerffel@gmail.com>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: e12d97d61532ad8cf10729288984e4c0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1459946.JtoeU42TSx
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Am Dienstag, 26. Mai 2009 01:32:46 schrieb Johannes Berg:
> On Tue, 2009-05-26 at 01:24 +0200, Tobias Doerffel wrote:
> > +       err =3D rfkill_register(sc->rf_kill.rfkill);
> > +       if (err) {
> > +               sc->rf_kill.rfkill =3D NULL;
> > +               return -1;
> > +       }
>
> Missing rfkill_free, and why -EPERM?
Thanks for this remark. I fixed the code and will post an updated patch soo=
n.

Any other comments on the patch? If not, any chance to get it merged into=20
wireless-testing branch?

> Could you try to work against v11
> of my rfkill patch, or better even against the cfg80211 rfkill instead?
I didn't look at both of them yet. However I think we first should try to g=
et=20
current rfkill support into mainline as fast as possible. Improvements and=
=20
adaptations to reworked rfkill framework can follow.

Regards,

Toby

--nextPart1459946.JtoeU42TSx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkogYqQACgkQHsjdpw2OaadN3gCgmnp8YkuYbmoDpD+o3x73WjkM
jUEAn3ldLHI0oFAtuWuFXFmEKZG61aUX
=plLt
-----END PGP SIGNATURE-----

--nextPart1459946.JtoeU42TSx--
