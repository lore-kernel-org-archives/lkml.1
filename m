Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0BUTsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 14:48:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:51117 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752925Ab0BUTsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 14:48:15 -0500
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX1/zbH4MoSHzgMsIR7URNmMiTTPJ8d7aVAVIfN0YOz
	aJLFcvgiQOr1ur
Date: Mon, 22 Feb 2010 08:47:53 +1300
From: Johannes Buchner <buchner.johannes@gmx.at>
To: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Ronni Holm-Nielsen <theronni@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [patch 0/7] per-bdi flushing model improvements. reiser4
Message-Id: <20100222084753.0a5d613c.buchner.johannes@gmx.at>
In-Reply-To: <4B68A68C.6030001@gmail.com>
References: <201002020255.46920.edward.shishkin@gmail.com>
	<20100202081728.GA2384@infradead.org>
	<4B6843E9.9070600@gmail.com>
	<20100202194208.GD5733@kernel.dk>
	<5e2ec5ac1002021345g569c743dtc5ccf77cde6738ae@mail.gmail.com>
	<4B68A68C.6030001@gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Feb_2010_08_47_53_+1300__Sx+aOQ/8.uWm8.0"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Feb_2010_08_47_53_+1300__Sx+aOQ/8.uWm8.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

Thank you Edward. The related bug was/is
http://bugzilla.kernel.org/show_bug.cgi?id=3D14915
It'd be great if someone could solve this, as the reiser4 patch is
not usable in its current state, with or without my illfated attempts
to fix it.

Kind regards,
Johannes

On Tue, 02 Feb 2010 23:26:20 +0100
Edward Shishkin <edward.shishkin@gmail.com> wrote:

> Hello everyone.
>=20
> The patches 1-3 are reverses for the following -mm stuff:
>=20
> http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-fixed-null-point=
er-dereference.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-generic_sync_sb_=
inodes-doesnt-exist-anymore.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-vfs-add-super_op=
erationssync_inodes-2.patch
>=20
> This is incorrect attempts to adjust reiser4 to the new per-bdi
> flushing model.
> The authors are cc-ed,
> any comments, suggestions are welcome.
>=20
> Thanks,
> Edward.
>=20
>=20
> Ronni Holm-Nielsen wrote:
> > To clarify (being a ReiserFS subscriber):
> >
> > patch 0, 4-6 sent to Andrew, ReiserFS, linux-fsdevel, linux-kernel,
> > xfs, jens.axboe
> > patch 1-3, 7 sent to Andrew, ReiserFS
> >
> > - Ronni
> >
> > On Tue, Feb 2, 2010 at 11:42 PM, Jens Axboe <jens.axboe@oracle.com>
> > wrote:
> >
> >  =20
> >> On Tue, Feb 02 2010, Edward Shishkin wrote:
> >>    =20
> >>> Christoph Hellwig wrote:
> >>>      =20
> >>>> I got this introduction twice, but patches 1-3 didn't make it to
> >>>> any of the lists.
> >>>>
> >>>>
> >>>>
> >>>>        =20
> >>> done
> >>>      =20
> >> Where?
> >>
> >> --
> >> Jens Axboe
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> reiserfs-devel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>    =20
> >
> >
> >
> >  =20


--=20
Emails k=F6nnen ge=E4ndert, gef=E4lscht und eingesehen werden. Signiere oder
versch=FCssele deine Mails mit GPG.
http://web.student.tuwien.ac.at/~e0625457/pgp.html

--Signature=_Mon__22_Feb_2010_08_47_53_+1300__Sx+aOQ/8.uWm8.0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkuBje4ACgkQ7X1+MfqVcr0wLgCeOJ7XVuqYHjy4twdFtIiBA82l
v6MAoJSr/2YiUOOLKnaAfONO7YbTKGUc
=1YuB
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Feb_2010_08_47_53_+1300__Sx+aOQ/8.uWm8.0--
