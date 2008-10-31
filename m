Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbYJaNQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbYJaNQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbYJaNQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:16:15 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:41683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYJaNQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:16:14 -0400
Subject: Re: [RFC] B+Tree library
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081026124643.GA1328@logfs.org>
References: <20081026124643.GA1328@logfs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xNoa0cpkf290t6vbzRRH"
Date: Fri, 31 Oct 2008 14:16:14 +0100
Message-Id: <1225458974.5546.6.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xNoa0cpkf290t6vbzRRH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static inline size_t btree_visitorl(struct btree_headl *head, long opaqu=
e,
> +		visitorl_t func2)
> +{
> +	return btree_visitor(&head->h, &btree_geo32, opaque, visitorl, func2);
> +}

Incidentally, do you think it would be possible to implement a kind of=20

btree_for_each_entry(e, ...) {
	do something with e
}

macro or function/macro combination? You seem to be doing a recursive
walk across the tree, would it be useful to have a linked list at the
lowest level of nodes to be able to iterate more easily?

johannes

--=-xNoa0cpkf290t6vbzRRH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCwUaAAoJEKVg1VMiehFYnfoP/0VymjftVsbTs+Xqbla4vHP6
11/u7Ehwafsgcrlpy6Kp3uHhbcKvjPcbdQFELrDTub8Vv9P9id6OLVW+hvV5WAtN
aazMli8DjbfQNIz+T63uZKYoo5fpX4oSPmy3aCD242UplJ9O7FikCVksPGCjFHCA
Vf315W7YITROzzM6FPWMVG1MU8+BGNhqKz11/hzzYRxcfjYF99QmnzYmPpodEBkx
aKje5wK+h8pueNr6zdhR4pk17Uvcwz0b3ayQH9zhCT6V8CTPbABJQBAVtHM5FofC
xnNPWdxG1uG2cf5V432a8RjUKHL8tBR9uIgdnT+DBnUMGAiVz4MjiXUasyhRUzSn
vj0B4yznbo7DOdjUovp3jfRMSCOvAFe93OV+vGCj/vB1eimZHWAkIoJYr/RSA8ZY
KIMltZARlAIZ69+kWC0O3FQmhTHo+r3GZlHVcX1okHP1dAz3gKOqgU1Y+CPxPn+K
cHCB4vKretfk1nm0HwwQO1kWV3YF+3WH9W5K6Gxj4lsayZ8bh/wiVLr1hKXDAhjK
6l7T0jMOr9VrUK4Y3xQ6Y/uwzKpEQb1VPZiS+LUtyOQl07k8XCpkfn3D94BLBzS1
nWCG0rhSmhBtMPFvw5FkSV+4/8Sej7r1siTDRvD1F4T6mu008EUs1yicDw7tQPkF
67z3v9DNBFql4MuGwD6S
=Efm0
-----END PGP SIGNATURE-----

--=-xNoa0cpkf290t6vbzRRH--

