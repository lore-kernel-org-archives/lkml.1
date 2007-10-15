Return-Path: <linux-kernel-owner+w=401wt.eu-S1765570AbXJORK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765570AbXJORK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765079AbXJORKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:10:37 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:37412 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764976AbXJORKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:10:35 -0400
Subject: Re: WANTED: kernel projects for CS students
From: Zan Lynx <zlynx@acm.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, dm-devel <dm-devel@redhat.com>
In-Reply-To: <20071014190128.6e3cdb44@bree.surriel.com>
References: <20071014190128.6e3cdb44@bree.surriel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K6uLPj3enC5h1iRdtyhd"
Date: Mon, 15 Oct 2007 11:10:32 -0600
Message-Id: <1192468232.8642.39.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20071015/1IhTSa-0007HJ-FL-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-K6uLPj3enC5h1iRdtyhd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-10-14 at 19:01 -0400, Rik van Riel wrote:
> The kernel newbies community often gets inquiries from CS students who
> need a project for their studies and would like to do something with
> the Linux kernel, but would also like their code to be useful to the
> community afterwards.
>=20
> In order to make it easier for them, I am trying to put together a
> page with projects that:
> - Are self contained enough that the students can implement the
>   project by themselves, since that is often a university requirement.
> - Are self contained enough that Linux could merge the code (maybe
>   with additional changes) after the student has been working on it
>   for a few months.
> - Are large enough to qualify as a student project, luckily there is
>   flexibility here since we get inquiries for anything from 6 week
>   projects to 6 month projects.
>=20
> If you have ideas on what projects would be useful, please add them
> to this page (or email me):
>=20
> http://kernelnewbies.org/KernelProjects

How about this in the Device Mapper raid-1/mirror code?
	/* FIXME: add read balancing */

That comment has been in there for many releases.  I've wanted read
balancing for several servers and had all sorts of ideas about it, like
adding functions to the underlying device queues to return a "queuing
cost" to determine which is the best queue to add the read request.  I
think that could work better for queues like CFQ than the MD
closest-head.

An implementation would also need to be benchmarked against the MD
raid-1.

Along with the time to submit it to LKML, get it reviewed and polish it
up, it might make a good student project.
--=20
Zan Lynx <zlynx@acm.org>

--=-K6uLPj3enC5h1iRdtyhd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHE58IG8fHaOLTWwgRAtOfAJ9EAkLcicDb7dv9DQSq7SrzYiyukwCeJt83
Dl95wjgr/JEQPFzYpQxJu54=
=ufyD
-----END PGP SIGNATURE-----

--=-K6uLPj3enC5h1iRdtyhd--

