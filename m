Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZKCHqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZKCHqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbZKCHqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:46:01 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:36590 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666AbZKCHqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:46:00 -0500
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <1257232587.3420.55.camel@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>
	 <20091102.224957.32364226.davem@davemloft.net>
	 <20091103065238.GE3212@core.coreip.homeip.net>
	 <1257232587.3420.55.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TF7Xj/Q8kb7N9qAmaura"
Date: Tue, 03 Nov 2009 08:44:59 +0100
Message-ID: <1257234299.28469.25.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TF7Xj/Q8kb7N9qAmaura
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-03 at 16:16 +0900, Marcel Holtmann wrote:

> and can we please stop jumping the gun here and going past the subsystem
> maintainers. I think this happens a little bit too much lately.

I'll rant a bit too -- I've been very annoyed by this many times. Note
this isn't really against you (Dmitry) in particular, just another
case ... but it does tick me off that many times when somebody manages
to blame a failure on a specific commit the first thing they do is ask
somebody way "above" (in terms of patch flow into mainline) the person
writing the patch (like Linus here) to revert it.

It'd help communication and be so much more friendly if the subject was
"found problem with commit ..." instead of "please consider
reverting ..." (which was comparatively friendly already!). You can even
leave the body almost identical, but I think it's presumptuous to
effectively say "hey I know the solution for the problem already". I'll
venture a guess and say that wasn't even the intent, but it certainly
comes across like that if you write an email with this subject, and
start the body with "Hi Linus," not even addressing the patch author,
just adding them to CC out of courtesy.

Should I think this is accepted practice?

</rant>

Before you get the wrong impression, yes, certainly this particular
commit was bad, and it shouldn't have happened. I tested it, but clearly
not every aspect of it. That's clearly my fault, I apologise for that.

johannes

--=-TF7Xj/Q8kb7N9qAmaura
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7993AAoJEODzc/N7+QmaKdoP/0AM7H5kUttjAafmMRj324Az
okHOq6o2uDpI5aou5yzhXwdSp8V5rxdbH3vonaPLNPT5cWpUb4tAWgMi4H9TphrS
MMF9nHEI45B40zodygaV2JEBkOM/Bms1QhaQDhijEnLN8BV4++A5XYGjsyWIpCD9
pAfUTdW1uKeijnA7cmV5naZ0ujtKKhIoxARtpSi5v4Utfpfzh3oKGpqdWLU1N8f9
yF/j/QztqUZyxW6tjxZ4obBKxAsx1boYRZRhMZlwihncyE3sPe4AyDbV7eABawJI
tgmH/G5qv6ajTQl+C617nRWl8LeqIFNhh/jJazPK9NqcgFm8zhbJKissocCc3i1t
9QRsjKdGNXI14FzGaC+4D+DjajxKNtmdGc3lPHOD4ZEanz4zXyUd3nOniha5eipb
5C3oNHfaV5+AgqQtZdrcVJN4xlLC7OEXcCr13n+a70WbPd2WpbGQzaRI3cpIWZEO
aBXr5WCsShXtBAXsAfCefgOt1TrO2ewi+nkMzXjTuTvOPAZGw6/0emqsmqP7Y1rV
XGcAzstjvSJaFetcDY9Db1frwvHfFFZXDRLeO/unOeGQFJN1T6Jraiet8zP9bnja
BWpzcusiLmu+PU18yscGvwlH4ki6XucFFNE6I5TE6iZhVvHJCBn8iFefX4yAhaIy
qTGDP4h3604+vk4Sirho
=2BpU
-----END PGP SIGNATURE-----

--=-TF7Xj/Q8kb7N9qAmaura--

