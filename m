Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZGYMTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZGYMTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 08:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbZGYMTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 08:19:40 -0400
Received: from ms01.sssup.it ([193.205.80.99]:40861 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752539AbZGYMTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 08:19:39 -0400
Subject: Re: report a bug about sched_rt
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jamie Lokier <jamie@shareable.org>, sen wang <wangsen.linux@gmail.com>,
       mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <1248451279.6987.138.camel@twins>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <1248437670.6987.26.camel@twins>
	 <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
	 <1248441290.6987.52.camel@twins>
	 <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
	 <1248442415.6987.56.camel@twins>
	 <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com>
	 <1248443656.6987.61.camel@twins>
	 <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com>
	 <1248446910.6987.111.camel@twins>  <20090724154036.GG27755@shareable.org>
	 <1248451279.6987.138.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kQx414Ydk6TJgdBLzHrj"
Date: Sat, 25 Jul 2009 14:19:14 +0200
Message-Id: <1248524354.8429.100.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kQx414Ydk6TJgdBLzHrj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-24 at 18:01 +0200, Peter Zijlstra wrote:
> For bugs the throttle works, like I said a well functioning system is
> not supposed to hit the throttle, obviously a bug precludes the well
> functioning qualification :-)
>=20
Yes, I also think a bandwidth isolation/throttling mechanism could help
a lot either with bugs or when you need hard real-time, soft real-time
and non real-time applications to live together in one single system
such as Linux is --or is about to become.

> Unpredictable calculation times can be dealt with on the application
> design level, for example using techniques such as outlined here:
>=20
>   http://feanor.sssup.it/~faggioli/papers/OSPERT-2009-dlexception.pdf
>=20
Thanks Peter! :-)

We're getting more citation in this ML than in 'our' academic world...
I'm not sure it is useful for our PhD and research career, but, indeed,
I like that very much anyway! :-P

The mechanism proposed in that paper is one way for providing developers
with the capability of specifying some typical real time "attributes" of
an application (or part of it), such as deadline and/or expected (worst
case?) execution time.

It is probably not always the best way of doing, but it's something we
think it could be useful somewhere. Therefore, we are still working on
it, e.g., improving timer resolution, adding the support for new
semantic and programming models, etc. Moreover, we are open to any
suggestion and contribution about this work, especially from the
community!

> These really are things you should know about before writing an RT
> application ;-)
:-D

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-kQx414Ydk6TJgdBLzHrj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpq+DsACgkQk4XaBE3IOsS+3wCfcfVmo81T8Gu7jh8nD9LwQfJv
nV4AoIr241zF5+CM+PT3GIgv+q4ba1Bc
=pbF4
-----END PGP SIGNATURE-----

--=-kQx414Ydk6TJgdBLzHrj--

