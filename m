Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbXGKM1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbXGKM1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbXGKM1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:27:10 -0400
Received: from ag-out-0708.google.com ([72.14.246.251]:27984 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbXGKM1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=SYVaYRM9ZSZYezFkj9U2EJGOC4YMCmdFB9wLxpZmj2LnNeFcQqr6VtvH9qaRVwHA08wHpNk3iG+yzVDlrMg5+qIOh5AQ9D1s98541RTcM+X/1vexZfLagz6jCLYEB48UfWzFo5te1n7RHNwgB3ZaRNJkcR2aqq/5XGzwcS81Utc=
Date: Wed, 11 Jul 2007 09:26:58 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Hawkins" <darthmdh@gmail.com>, "Con Kolivas" <kernel@kolivas.org>,
       "ck list" <ck@vds.kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Jackson" <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Message-Id: <20070711092658.645023b9.kjwinchester@gmail.com>
In-Reply-To: <20070710181419.6d1b2f7e.akpm@linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<200707102015.44004.kernel@kolivas.org>
	<b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>
	<20070710181419.6d1b2f7e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Jul_2007_09_26_58_-0300_kP.9Jx2_N8V1N9lE"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Jul_2007_09_26_58_-0300_kP.9Jx2_N8V1N9lE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jul 2007 18:14:19 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 11 Jul 2007 11:02:56 +1000 "Matthew Hawkins" <darthmdh@gmail.com>=
 wrote:
>=20
> > We all know swap prefetch has been tested out the wazoo since Moses was=
 a
> > little boy, is compile-time and runtime selectable, and gives an import=
ant
> > and quantifiable performance increase to desktop systems.
>=20
> Always interested.  Please provide us more details on your usage and
> testing of that code.  Amount of memory, workload, observed results,
> etc?
>=20

I only have 512 MB of memory on my Athlon64 desktop box, and I switch betwe=
en -mm and mainline kernels regularly.  I have noticed that -mm is always m=
uch more responsive, especially first thing in the morning.  I believe this=
 has been due to the new schedulers in -mm (because I notice an improvement=
 in mainline now that CFS has been merged), as well as swap prefetch.  I ha=
ven't tested swap prefetch alone to know for sure, but it seems pretty like=
ly.

My workload is compiling kernels, with sylpheed, pidgin and firefox[1] open=
, and sometimes MonoDevelop if I want to slow my system to a crawl.

I will be getting another 512 MB of RAM at Christmas time, but from the oth=
er reports, it seems that swap prefetch will still be useful.

[1] Is there a graphical browser for linux that doesn't suck huge amounts o=
f RAM?

--=20
Kevin Winchester

--Signature=_Wed__11_Jul_2007_09_26_58_-0300_kP.9Jx2_N8V1N9lE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGlMyXKPGFQbiQ3tQRApQiAJ0ef9OKRssy6Sppc3l8B+tyGiLf1wCfUqBI
/QAl7d0HbCfZgECvIWZa+x8=
=Uck0
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Jul_2007_09_26_58_-0300_kP.9Jx2_N8V1N9lE--
