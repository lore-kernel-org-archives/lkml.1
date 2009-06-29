Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZF2UVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZF2UVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZF2UU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:20:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:34482 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbZF2UU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=mX+g7/yK5ykwdGOHvbMR91esurX1RsFY3r3ttm+2/etm9SWZXJjsfxU1PY73+Xc13R
         lBYWhQ9EaeI5edAZbvRQhrRFibgkH/F8Zl/hnsiBILj33ATaBd4PQfeplhmNnwG6bEcQ
         N5RSVdx9Y8zmigQxPZHPWpJ7+1vwX0gRbV3i8=
Subject: Re: MFD: mutex from ISR in ezx-pcap?
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
       laforge@openezx.org
In-Reply-To: <4A49175E.3020409@gmail.com>
References: <4A49175E.3020409@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kp8lMUFcUWqgGvscLGXk"
Date: Mon, 29 Jun 2009 17:20:40 -0300
Message-Id: <1246306840.18231.29.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kp8lMUFcUWqgGvscLGXk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Em Seg, 2009-06-29 =C3=A0s 21:34 +0200, Jiri Slaby escreveu:
> Hi,
>=20
> pcap_adc_irq tries to perform non-atomic operations in ISR which is not
> allowed. Above that, it may deadlock.
>=20
> Since all the operations there (read, write, mutex locking) may sleep,
> any objections to convert the ISR contents to a workqueue?

pcap_adc_irq actually already runs from a workqueue (pcap_isr_work).

--=20
Daniel Ribeiro

--=-kp8lMUFcUWqgGvscLGXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpJIhEACgkQw3OYl0G0liRgRACcCXXkn5jpihAFuFAEzE5tYb5Q
HTYAoJpBxMVmpfhW71R0zEuDFXcNLASV
=WO78
-----END PGP SIGNATURE-----

--=-kp8lMUFcUWqgGvscLGXk--

