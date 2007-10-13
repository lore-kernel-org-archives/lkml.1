Return-Path: <linux-kernel-owner+w=401wt.eu-S1761755AbXJMJqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761755AbXJMJqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 05:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbXJMJqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 05:46:23 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:20169 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751022AbXJMJqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 05:46:22 -0400
Subject: Re: [PATCH 5/7] RT: Add support for low-priority wake-up to
	push_rt feature
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071013001559.7444.4125.stgit@novell1.haskins.net>
References: <20071013001052.7444.8363.stgit@novell1.haskins.net>
	 <20071013001559.7444.4125.stgit@novell1.haskins.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4VwZ6l1GB6tyvBFlZrSq"
Date: Sat, 13 Oct 2007 11:46:18 +0200
Message-Id: <1192268778.27435.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4VwZ6l1GB6tyvBFlZrSq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-12 at 20:15 -0400, Gregory Haskins wrote:

> +/* Push all tasks that we can to other CPUs */
> +static void push_rt_tasks(struct rq *this_rq)
> +{
> +	while (push_rt_task(this_rq));
> +}

I'd like to see an additional termination condition to this loop (might
just be paranoia though).


--=-4VwZ6l1GB6tyvBFlZrSq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHEJPqXA2jU0ANEf4RAj2sAJ9AntN2u/dQBMve5zSxj1hwiFYSEwCggsQ3
2Y8duIYjzPXL4VLgNZr+waU=
=RJZF
-----END PGP SIGNATURE-----

--=-4VwZ6l1GB6tyvBFlZrSq--

