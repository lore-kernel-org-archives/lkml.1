Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXLLMtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXLLMtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 07:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbXLLMtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 07:49:12 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:43068 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750786AbXLLMtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 07:49:11 -0500
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jie Chen <chen@jlab.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <475F0B07.2060303@jlab.org>
References: <20071205210222.GA30089@elte.hu> <47572353.4040606@jlab.org>
	 <20071206104318.GB30838@elte.hu> <47582367.6060602@jlab.org>
	 <20071210105943.GA5370@elte.hu> <475D9BB5.20808@jlab.org>
	 <20071211105149.GA24250@elte.hu> <475EAC81.1020408@jlab.org>
	 <20071211155226.GA1056@elte.hu> <475EBD30.1010506@jlab.org>
	 <20071211212352.GF6902@elte.hu>  <475F0B07.2060303@jlab.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aghquV/EiD6MWW7kBRd9"
Date: Wed, 12 Dec 2007 13:49:06 +0100
Message-Id: <1197463746.7042.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aghquV/EiD6MWW7kBRd9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-12-11 at 17:11 -0500, Jie Chen wrote:
> Ingo Molnar wrote:
> > * Jie Chen <chen@jlab.org> wrote:
> >=20
> >> The following is pthread_sync output for 2.6.21.7-cfs-v24 #1 SMP=20
> >> kernel.
> >=20
> >> 2 threads:
> >=20
> >> PARALLEL time =3D       11.106580 microseconds +/- 0.002460
> >> PARALLEL overhead =3D    0.617590 microseconds +/- 0.003409
> >=20
> >> Output for Kernel 2.6.24-rc4 #1 SMP
> >=20
> >> PARALLEL time =3D              19.668450 microseconds +/- 0.015782
> >> PARALLEL overhead =3D           9.157945 microseconds +/- 0.018217
> >=20
> > ok, so the problem is that this PARALLEL time has an additional +9 usec=
s=20
> > overhead, right? I dont see this myself on a Core2 CPU:
> >=20
> > PARALLEL time =3D                           10.446933 microseconds +/- =
0.078849
> > PARALLEL overhead =3D                       0.751732 microseconds +/- 0=
.177446
> >=20

On my dual socket AMD Athlon MP

2.6.20-13-generic

PARALLEL time =3D                           22.751875 microseconds +/- 21.3=
70942
PARALLEL overhead =3D                       7.046595 microseconds +/- 24.37=
0040

2.6.24-rc5

PARALLEL time =3D                           17.365543 microseconds +/- 3.29=
5133
PARALLEL overhead =3D                       2.213722 microseconds +/- 4.797=
886



--=-aghquV/EiD6MWW7kBRd9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHX9jCXA2jU0ANEf4RAnBjAJ99Iji2UkXzvwntBmBwu3oR0Nt4XQCfWh3U
5Fc05OYJe6yEVOpYEMAidcs=
=fv/f
-----END PGP SIGNATURE-----

--=-aghquV/EiD6MWW7kBRd9--

