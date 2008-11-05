Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbYKET53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbYKET53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYKET5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:57:19 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:33674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbYKET5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:57:18 -0500
Subject: Re: [RFC] B+Tree library V2
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081101155958.GA28776@logfs.org>
References: <20081026124643.GA1328@logfs.org>
	 <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org>
	 <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org>
	 <20081101155958.GA28776@logfs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JgZBELHvnyxTSicT8WKe"
Date: Wed, 05 Nov 2008 20:57:20 +0100
Message-Id: <1225915040.3619.155.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JgZBELHvnyxTSicT8WKe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

sorry for the late reply.

On Sat, 2008-11-01 at 16:59 +0100, J=C3=B6rn Engel wrote:

> Not only compiles, also survives muserspace test harness and no longer
> looks like a bulldog with lipstick.

cool :)

> You might note that "less complicated than expected" means I'm still
> bending the rules a bit.  I only merge underpopulated nodes with
> neighbours.  If the neighbour is too full for a merge I don't steal
> entries.  That bit is for someone else to implement. :)

That sounds fair, after all at least it limits the tree size, but I'm
too lazy to calculate the worst case right now.

I'd use this as-is for the WIP cfg80211 code that keeps track of BSSes,
as a hash-table/list on steroids.

johannes

--=-JgZBELHvnyxTSicT8WKe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEfqcAAoJEKVg1VMiehFYC4kP/Av+ABSgq7vvaqZhs4RKXwF8
3q8W2wwpwPu2H421QHH8u7fR1jNMY3brW5MMP1Liiy4Nksv7RpE8XDv5xR72Mlnw
ewdkcOmgNiqUm41/UHROWP7oOSt23x2qOxqEaX3yPbDcDoboOqMHqETHe/75L2fo
Dr1acLgosk6mdEOkwjF/uiJ8mGP/XdSmqFl7EhG8IqIwyTGDd1gKWXn0tI4A8d03
2i25mZC+8p6SgWJuFotlfPmjXEbO6EZKl2Z+MTAc+rXTd46M7fJq1iuYumHHSlY0
pRi7VB8pZZjMMHvswVRKlhk3S0ZkFS7Vco4BohFKCdTGhf2UfSprtEZYAgWSqsnc
qYauZRkPwZqqpOQ6Gs+IrlE2U3FOVwJaU03sP5ByuONwCu/UC2UUyV6SfjbGS+Ip
L5XI+2C3fUziJcI4piQ5gdOtUMJpRQBnFL6C+MBypjOCLoB3Y+LXU2cXCvxL8eSQ
ygDzvFDqKFVxwSnR2z6LBA2kK+3msh4G4fdwsBUMAsROyfwflAjZLO2KixTsXHR+
FCOAArovypjFYq0ZNuhTItFGJx3OSofhaxIdNv4fG+BG8Y9ck80AzC9bX7IKrP9N
1ix6Le9AzXofzzmfEevGpvybGauRxh9cdCjZkzS9S5CqHOrrTwMJLMfiCNvPmAx9
KyOgQye+KQTY5+OREBPQ
=SGAW
-----END PGP SIGNATURE-----

--=-JgZBELHvnyxTSicT8WKe--

