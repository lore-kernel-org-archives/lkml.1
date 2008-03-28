Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYC1VBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYC1VBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbYC1VB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:01:26 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:35995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbYC1VBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:01:25 -0400
Subject: Re: Oops/Warning report for the week of March 28th 2008
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>
In-Reply-To: <alpine.LFD.1.00.0803281329340.14670@woody.linux-foundation.org> (sfid-20080328_205203_254278_BF9EB41F)
References: <47ED3F1A.1090101@linux.intel.com>
	 <alpine.LFD.1.00.0803281310480.14670@woody.linux-foundation.org>
	 <alpine.LFD.1.00.0803281329340.14670@woody.linux-foundation.org>
	 (sfid-20080328_205203_254278_BF9EB41F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zqqsyyNKmcZl1QiQ/AFF"
Date: Fri, 28 Mar 2008 22:01:11 +0100
Message-Id: <1206738071.22530.80.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zqqsyyNKmcZl1QiQ/AFF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Hmm. Definitely not from the kernel mailing list. I'm intrigued, where di=
d=20
> that oops #5814 come from (picked a recent one at random)?

Can't tell you this, but

> The thing is recent, and oopses on "mutex_lock(dev->mutex)" in=20
> input_release_device. In particular, the path *seems* to be this one:
>=20
>   evdev_release ->
>     evdev_ungrab ->
>       input_release_device ->
>         mutex_lock ->
>           mutex_lock_nested ->
>             __mutex_lock_common ->
>               list_add_tail(&waiter.list, &lock->wait_list)

That I've seen before, analysed a bit and posted:
http://permalink.gmane.org/gmane.linux.kernel.input/4281

johannes

--=-zqqsyyNKmcZl1QiQ/AFF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+1clqVg1VMiehFYAQKalRAAsL+CGxIvsoqw03G2gmdGyPGIzcIGD0Dx
1HI9nNwxTWbKFriXLDMY/gbjuJIzSvMboNoMptMFY60WeBGV9uixClEq1gpmBBPf
2iDQD58wFaKRJvmVhKDx01vziaExGCE36C2Vjrvgnwyri2Qw4PdA6JZIGv/FnZXb
FC3ALXs9TuYUJUZL0+UyKzE8LBT7NumQ7rvBYfSwn+bKeQ9ntk+0WLgeDZMuUvYr
3K+fnqA5GaouFD6I0nelPFOBFvqm89IMVuLILluFPGdErA0eSvvk1U8foCG4p+jk
i9rMYTJBY5qqgH06ZhBUkIo29r7Xpc16iVKEbxO8JVKxbCJDnB9/9n/AFUtbStjB
vaq6QB+rpyLxkXqHEOrZwniM7FQRS6lFMa2T9w2lma30Z+LKaBXOFtFpxT1wA3Ds
HcsQbyY3l51ojfxq6FZVCXe5gRl5TEYPf7fOaHam1xm474NLpT1T470ox2wf6DQG
3GZBzfsxZNKlan/87kA2E1cza3w7z7Lq3hLuc0BHbKlGm4Yc/E7PeK6mIcmvqr2b
7pb36jNxxXENNyAXQxywHo0QF1oEsgHywYiQvE8xr1/pLuBaz6ychXAs8IrbGH0H
/yGeeANSj1DO1mB81uod2kPMS/L3j3RpUUjKeBgBRVVJGPjUt+7POP7rLtZsymhE
eXVw3cptLSk=
=ZZhr
-----END PGP SIGNATURE-----

--=-zqqsyyNKmcZl1QiQ/AFF--

