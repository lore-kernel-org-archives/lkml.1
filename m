Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbXISXy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbXISXy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXISXyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:54:49 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38255 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497AbXISXys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:54:48 -0400
X-Sasl-enc: m7p3SQnOe5BI+hyZBV9MAEUKlpVW8a0zDFhyP0HO9vXq 1190246087
Message-ID: <46F1B706.70304@imap.cc>
Date: Thu, 20 Sep 2007 01:55:50 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tilman Schmidt <tilman@imap.cc>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: 2.6.23-rc6-mm1
References: <20070918011841.2381bd93.akpm@linux-foundation.org>	<46F1AA6E.1030708@imap.cc> <20070919162438.7264f06c.akpm@linux-foundation.org> <46F1B097.9020109@redhat.com>
In-Reply-To: <46F1B097.9020109@redhat.com>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF6463DD40A2D611D570DADB8"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF6463DD40A2D611D570DADB8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 20.09.2007 01:28 schrieb Chuck Ebbert:
> AFAICT the rtc problem is caused by misconfiguration: both the new
> and old rtc driver have been built and they are both trying to load.

Rats. Sorry. I remember now. That's not the first time I am hit by
that one. I had even made a resolution to try and find out the correct
options to set. So what are they? CONFIG_RTC=3Dy and CONFIG_RTC_DRV_CMOS=3D=
n?
Guess I should try that combination in my next round of tests.

Anyway, shouldn't there be a warning or at least some clear instructions?=

As it is, both the old and the new driver claim in Kconfig that you need
them in order to access your RTC, and none of them even mentions the
other, so it's way too easy to end up enabling both of them.

So are all my other woes a consequence of that one?

Thanks,
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigF6463DD40A2D611D570DADB8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG8bcGMdB4Whm86/kRAi2UAJ4kJf0zMTJIOydNRld4KFEhGd1hxACdHNJR
glNpz62LYKrrb+BBfxx79oU=
=oXbN
-----END PGP SIGNATURE-----

--------------enigF6463DD40A2D611D570DADB8--
