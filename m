Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbYFRHSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbYFRHSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYFRHSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:18:22 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:52578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYFRHSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:18:21 -0400
Subject: Re: Oops report for the week preceding June 16th, 2008
From: Johannes Berg <johannes@sipsolutions.net>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linville@tuxdriver.com, gregkh@suse.de
In-Reply-To: <48588255.9060400@linux.intel.com>
References: <4856AFDF.5080901@linux.intel.com>
	 <20080617092023.GA20621@elte.hu>
	 <20080617.022652.76635616.davem@davemloft.net>
	 <20080617153356.GA3510@elte.hu> <1213730654.3803.122.camel@johannes.berg>
	 <20080617194105.GA18177@redhat.com>  <48588255.9060400@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MMt84tuQnC1WQhB+vMjZ"
Date: Wed, 18 Jun 2008 09:17:26 +0200
Message-Id: <1213773447.3803.150.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MMt84tuQnC1WQhB+vMjZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > It's been something of a double edged sword.  It's great that users are
> > getting the latest drivers & fixes, but at the same time, it means they
> > get exposed to all the latest breakage at the same time.
> > Given the volume of change occuring, cherry-picking isn't an enviable t=
ask,
> > so distros are stuck between this reality, or leaving users hanging unt=
il we
> > get to the next point release.
> >=20
> > FWIW, wireless isn't unique in this regard. For eg, the last few months=
 we've
> > always been shipping the latest ALSA bits rather than what's in kernel.=
org too,
> > for similar reasons -- when bugs appear, the developers want to know
> > "does it still happen with the latest bits?"
> >=20
>=20
>=20
> this is the part that concerns me.  The fact that you feel the need to us=
e "not yet in mainline" pieces
> (I'm not so much talking about backporting from 2.6.26-git to 2.6.25; tha=
t's perfectly fine, but I'm
> talking about code not in 2.6.26-git) is NOT a healthy sign.... if that t=
ruely is the case then that code surely
> deserves to be in mainline as well?

That's more a case of Fedora living on the bleeding edge. The code is
fairly stable, all in linux-next, but the churn tends to be high because
of internal API changes that affect all drivers. Currently, I don't
think there is actually any _feature_ pending in linux-next, only
internal cleanups. Such cleanups are desirable, but at the same time can
lead to instability, hence being kept out of .26-git for the time being,
and are in -next for .27. Mostly because we only wrote them after .26
started.

johannes

--=-MMt84tuQnC1WQhB+vMjZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWLaDAAoJEKVg1VMiehFYaJcP/ja3vn//YULhslVk6MtEkn9m
zs8Jol9XxwGhxzc2e3gnUOGrUxqbtxAmLJxnc40Kp0s3VC2wjX3ZL2VUYlTrfrHE
Yr6DGUL1v4lITJdZkA7LDJWPXB7x5ETC8mua+K/vpE23llR612+rGhD9AXR/0MZU
pKZIk0a7uvUDbg7mdQGm1G6GsA3ing4qZD2RyDH/tLmRWDcVf+9c6sgGevf3yJ8O
ZHcElrkFDAlb7bOR0dh4XCiGCOomvelZgyW7MfdTbZgwuPOm8Rt+0TpU8itOiRcv
OVRv4eeEoOtumeO/LYfKmajuuIi8qGALJOFMArYT0WhFK5pTJkQD/ngm29eLDMCR
jvP3z4+S6XQbzZWVX0ia3TwDFI7wwquHsaRvZFlggSZ5LeyiL+O11ebeDLEmAr+m
GxfReLUDYkAxuasjiBEoNbYNDsHfXEIR2wn/HUYfoe9qLPZUWw3bOgmLjVvG5PyZ
yQ1mFo2RfLzQaWUDRlAx+sEr6OYL857jZHMOXHdS59XHQy13lGKeXySzY0RKWh9Q
6yMrVj5iAQ3fPlm0D0X6G6+e1O5o6Bpaxa4NYPYgTS/A9wb3ljuvbglF3BEkeVwM
L9znii9EnluasCN6Mz26zRxswoqSxeOzL48gdhJbAWdlzkPv8x7h7byS+UCaW8S2
bHTQkSpAeX5tsmPA1F8K
=fAp1
-----END PGP SIGNATURE-----

--=-MMt84tuQnC1WQhB+vMjZ--

