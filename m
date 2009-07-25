Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbZGYLK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbZGYLK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 07:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZGYLK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 07:10:28 -0400
Received: from ms01.sssup.it ([193.205.80.99]:36807 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751029AbZGYLK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 07:10:27 -0400
Subject: Re: report a bug about sched_rt
From: Raistlin <raistlin@linux.it>
To: sen wang <wangsen.linux@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       akpm@linux-foundation.org, kernel@kolivas.org, npiggin@suse.de,
       arjan@infradead.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <1248437670.6987.26.camel@twins>
	 <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
	 <1248441290.6987.52.camel@twins>
	 <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UbEEriwUFsQL5Y+pkkRt"
Date: Sat, 25 Jul 2009 13:10:24 +0200
Message-Id: <1248520224.8429.83.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UbEEriwUFsQL5Y+pkkRt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-24 at 21:26 +0800, sen wang wrote:
> If cpu is free and there is a running state task,how can you scdedule
> idle task up?
>
Well, if you drop an eye to what Peter is trying to point out, you'll
find a lot of examples where providing an RT application with _more_ CPU
than it asks, lead to catastrophic consequences... They are some of what
we call "scheduling anomalies", and there are plenty of examples of
that! :-O

I think sched_rt determinism could be improved... But giving some random
task some random more bandwidth is just going in the opposite
direction! :-(

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-UbEEriwUFsQL5Y+pkkRt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpq6BoACgkQk4XaBE3IOsSdJgCePa+yokK1jxyXMHmRmXLrWHBI
RVYAoKDCVfmJduvH9UiIkzGqbCRpE6vu
=Tv02
-----END PGP SIGNATURE-----

--=-UbEEriwUFsQL5Y+pkkRt--

