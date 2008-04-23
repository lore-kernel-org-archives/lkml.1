Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbYDWKOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbYDWKOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYDWKOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:14:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:30919 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYDWKOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:14:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:sender;
        b=OxOoVa8+oQG61buqTrVGSeSDJtK43b2lo56KS2KzMo6+Zi9dCfij/wXBhHet8uWSN38ZtiNE2hew4ESgWgx6YWKjqMWs/8cNc8mLIlOu6wIMKvvvqCQBvHq5aTaI8B3Y0MecOCTru5oAsyJxwgKrNbvPey1LbrYELRKoovZA0aw=
Date: Wed, 23 Apr 2008 12:14:16 +0200
From: Rodney Lorrimar <rodney@rodney.id.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, jikos@suse.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew McNabb <amcnabb@mcnabbs.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Input: adbhid - restore_capslock_events fixes
Message-ID: <20080423101416.GA4735@solaria.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dmitry,

Would you consider these for review and inclusion in the input tree?

They fix 2 out of 3 problems I know of in the simulation of capslock
up/down key events on Apple laptop keyboards. The third problem - that
sometimes the capslock key gets stuck down - I haven't looked at
properly yet, but I know that the "capslock key up" packet is never
received by adbhid_keyboard_input so the problem is in adb.c or
via-pmu.c, or possibly the hardware never sends the event at all.

Pavel Machek suggested removing the parameter, and I would do this
after fixing the third problem. This would probably happen after the
once-or-twice-a-day event of stuck capslock annoys me enough to have a
deeper look.


Thanks,

Rodney



Rodney Lorrimar (2):
  Input: adbhid - fix capslock key state after suspend
  Input: adbhid - capslock and power button fix

 drivers/macintosh/adbhid.c |   58 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 49 insertions(+), 9 deletions(-)


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIDwv3bBchLr+YxKcRAmGGAKCP8cVCUMrzXcLlc2DXW4DtSK7Z/wCdEJxO
WLe0JxlHc+iKvKTdO70xcE4=
=Oea7
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
