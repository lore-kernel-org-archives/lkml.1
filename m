Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZBTR34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZBTR34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbZBTR3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:29:46 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:57042 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZBTR3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:29:45 -0500
Subject: Re: [PATCH] cpufreq: Change link order of x86 cpufreq modules
From: Scott James Remnant <scott@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ingo Molnar <mingo@elte.hu>, davej@codemonkey.org.uk,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
In-Reply-To: <20090218183641.GA20203@srcf.ucam.org>
References: <20090218182822.GA19902@srcf.ucam.org>
	 <20090218183137.GD26802@elte.hu>  <20090218183641.GA20203@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fcMsO8zNWKHrHMcjyeRu"
Date: Fri, 20 Feb 2009 17:29:52 +0000
Message-Id: <1235150992.6467.66.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fcMsO8zNWKHrHMcjyeRu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-18 at 18:36 +0000, Matthew Garrett wrote:

> On Wed, Feb 18, 2009 at 07:31:37PM +0100, Ingo Molnar wrote:
>=20
> > Nice fix! Where does this information come from? Distro module=20
> > ordering magic? It's rather non-trivial.
>=20
> Pretty much. p4-clockmod is never the preferred option because it does=20
> no voltage scaling. speedstep-centrino is now almost entirely=20
> functionally replaced with acpi-cpufreq. The powernow-k8 issue was a=20
> personal communication from davej.
>=20
In fact, we've noticed severe regressions with p4-clockmod over simply
having no scaling driver at all - and are not going to built it into our
kernels.

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-fcMsO8zNWKHrHMcjyeRu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkme6JAACgkQSnQiFMl4yK5zuQCgpMFmzGL4DJqlYQ0lgGXZg6H5
P+EAn37gsFpDM8ZhgTLHIh2Oe4wB94Wf
=eti4
-----END PGP SIGNATURE-----

--=-fcMsO8zNWKHrHMcjyeRu--

