Return-Path: <linux-kernel-owner+w=401wt.eu-S1762968AbXGFKnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762968AbXGFKnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXGFKm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:42:56 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:58485 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXGFKmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:42:55 -0400
Subject: Re: [PATCH 2/2] workqueue: debug work related deadlocks with
	lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070705153648.GA236@tv-sign.ru>
References: <20070705110744.564273000@sipsolutions.net>
	 <20070705110820.622888000@sipsolutions.net>
	 <20070705153648.GA236@tv-sign.ru>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VP7R6UVcVnfGQZshlFq5"
Date: Fri, 06 Jul 2007 12:43:53 +0200
Message-Id: <1183718633.3818.96.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VP7R6UVcVnfGQZshlFq5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-05 at 19:36 +0400, Oleg Nesterov wrote:

> So, __WORK_INITIALIZER() uses work_struct itself as a "struct lock_class_=
key" ?
> How so?

Well, this is for work_structs that are static (not dynamically
allocated.) struct lock_class_key is just a single byte because its
whole purpose is to be a unique pointer, there's nothing actually in it.
Hence, taking the address of the work struct (when it's statically
allocated) is a unique pointer just as well.

johannes

--=-VP7R6UVcVnfGQZshlFq5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjhzp/ETPhpq3jKURArrFAKCZ8B0KURrQiRIdYCU6Totj5RYU/QCdGxLN
y2R/t61E8B9I3dbZThRpVak=
=tmYc
-----END PGP SIGNATURE-----

--=-VP7R6UVcVnfGQZshlFq5--

