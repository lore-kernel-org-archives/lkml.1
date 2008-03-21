Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYCUAVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYCUAVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYCUAV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 20:21:28 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:56597 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbYCUAV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 20:21:27 -0400
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level suspend
	and hibernation callbacks (rev. 2)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
In-Reply-To: <200803210101.04706.rjw@sisk.pl>
References: <200803210101.04706.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vQriGRPJDJzKklLQ9jsd"
Date: Fri, 21 Mar 2008 01:21:03 +0100
Message-Id: <1206058863.16475.165.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vQriGRPJDJzKklLQ9jsd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> + * All of the above callbacks, except for @complete(), return error code=
s.
> + * However, the error codes returned by the resume operations, @resume()=
,
> + * @thaw(), and @restore(), are only printed in the system logs, since t=
he PM
> + * core cannot do anything else about them.

Why bother and not just make them return void, the error printing can
most likely be done much much better in the callback since that possibly
has information on why it failed.

> + * All of the above callbacks, return error codes, but the error codes r=
eturned
> + * by the resume operations, @resume_noirq(), @thaw_noirq(), and
> + * @restore_noirq(), are only printed in the system logs, since the PM c=
ore
> + * cannot do anything else about them.

Same here, of course.

johannes

--=-vQriGRPJDJzKklLQ9jsd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+L/baVg1VMiehFYAQJnWQ/6AuPtndPWLgLpc5zd2BHXP5G/sV51xRYp
hIk9R6Kskrnxy0aRsZlOJD4BUq8PwL0g//2D1m1yhSsqwa8TEZ5AS7CTRgxGWZ78
aXePkqNbqhcfVWpI6oUSwr+XvZU2emMJN41pLiE6HgFHlO9BitSC+41jNagzbUg7
V9eDfsDknDsS6Clzw5ttiwU91BsSCUOcjRq97XdlbNbs2DKgFzLTAxDzveZyNWux
JZ+VZ0tPr7+oqy8RdtOnaCL/k6t7OGHpP19rBpa1mfHhgKwj2BRBgfMc9JVLkGdA
ToIhojNrC4Pl+vB1F2pa3DlaclKiWcmhYj02OFp/4FKkJeYZLRjTi5EMBLKwqQ7K
pN5kKjIHCLb69k0QcV2iU6sAsnbD4+1GdAS5ACMu1VdDzXP01VO3VAHOuFiEx1b8
VwrRgva8/AnyCdOuun+GY55FO7ZlP2Qp0uePIwarJJR9rRh3lh6l7RUfn1ip8Tnp
9Ult7OWlPTi/onmeb72xpniMlnVITJ+/BduyeWqcbzfr9cbu0R/2UKUxXGeHRb3D
ORM/8cK2KqAO8u22o5jfXkXwM/MP0TIQjZvK12wvGQydQlSkrxKwa/JYZaUvHFkO
vC25ase7/VbsgMvT2q6fEG+c5KOdgMC+QtkT7Q97pURkFk5A2ByZfqf4WQU9zcB/
vI6+Thybyok=
=ZzFh
-----END PGP SIGNATURE-----

--=-vQriGRPJDJzKklLQ9jsd--

