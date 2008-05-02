Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbYEBRPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbYEBRPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYEBRPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:15:46 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:34083 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752521AbYEBRPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:15:45 -0400
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       jirislaby@gmail.com, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080501153048.2a8d356f.akpm@linux-foundation.org>
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
	 <20080501142305.77433e50.akpm@linux-foundation.org>
	 <481A3781.8080100@gmail.com>
	 <1209679559.14864.33.camel@localhost.localdomain>
	 <20080501153048.2a8d356f.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/8A+6Yta2xd3JkPmWYma"
Date: Fri, 02 May 2008 11:15:33 -0600
Message-Id: <1209748533.239501.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080502/1Jryr8-0006Xs-8w-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/8A+6Yta2xd3JkPmWYma
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-01 at 15:30 -0700, Andrew Morton wrote:
[cut]=20
> > CONFIG_HOTPLUG is only settable to 'n' if you're CONFIG_EMBEDDED which
> > has a zero set intersection with the users of megaraid, so in practical
> > terms, there's no actual box it could kill.
>=20
> who suspends and resumes servers?

I read an article not long ago about a guy running an AMD renderfarm.
He was working on power management techniques, including suspending
systems that weren't in use.  It made a huge difference in power costs,
apparently.

I believe suspend is also used in some virtual server farms where
physical systems are resumed and virtuals are migrated to satisfy higher
CPU demands.

I could also see using it combined with a load balancer or proxy to
bring up backup web or database servers.

Compared to using networked/USB power bars or management controllers to
bring systems up and down, suspend/resume provides a faster response.
--=20
Zan Lynx <zlynx@acm.org>

--=-/8A+6Yta2xd3JkPmWYma
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkgbTDUACgkQolqWs/Y4NLwaEACfWnrTZ3AybWOj/gfBkSje0+uJ
ah4AoKKomNwEs/DB7TOcDFenIccDTcd2
=Q2ui
-----END PGP SIGNATURE-----

--=-/8A+6Yta2xd3JkPmWYma--

