Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYBYIaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYBYIaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 03:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYBYI34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 03:29:56 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:3647 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYBYI3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 03:29:55 -0500
Date: Mon, 25 Feb 2008 09:29:33 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Matt Mackall <mpm@selenic.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linux-tiny@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       michael@free-electrons.com
Subject: Re: [RFC] [PATCH] x86: Use ELF section to list CPU vendor specific
 code (Linux Tiny)
Message-ID: <20080225092933.6a8dbc36@crazy>
In-Reply-To: <1203734617.14838.169.camel@cinder.waste.org>
References: <200802082347.25364.michael-lists@free-electrons.com>
	<20080208231130.GA10511@elte.hu>
	<200802112342.23493.michael-lists@free-electrons.com>
	<1202770566.12383.59.camel@cinder.waste.org>
	<47B0D3B7.6070308@zytor.com>
	<1202772532.12383.67.camel@cinder.waste.org>
	<47B0EE46.6050208@zytor.com>
	<20080215120023.252647bd@crazy>
	<1203734617.14838.169.camel@cinder.waste.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mW.of8IkwiAtBxwcwxRIt7G";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mW.of8IkwiAtBxwcwxRIt7G
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Sat, 23 Feb 2008 10:43:37 +0800,
Matt Mackall <mpm@selenic.com> a =C3=A9crit :

> This is not quite what Peter and I were thinking of, I think. It's not
> at all generic. How about a section that simply contains a set of
> function pointers, a macro to add things to that section, and a
> function that calls all the pointers in that section. Eg:
>=20
> CALLBACK_SECTION(init_cpu_amd, "cpuvendor.init");
> invoke_callback_section("cpuvendor.init");
>=20
> ..which would give us a generic facility we could use in various
> places.

I see. Probably doable. How would it work in the LD script file ? Your
mechanism allows to specify any section name, but AFAIK, the sections
must be explicitly listed in the kernel LD script in order to be
included in the final kernel image. Am I missing something ?

Sincerly,

Thomas
--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/mW.of8IkwiAtBxwcwxRIt7G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHwnxt9lPLMJjT96cRArueAKCgS1Q/arLDMzoRv/3q+TMJsrL06ACfQVro
NKAWx9ccApmkFhb2fIYiUvw=
=+5zb
-----END PGP SIGNATURE-----

--Sig_/mW.of8IkwiAtBxwcwxRIt7G--
