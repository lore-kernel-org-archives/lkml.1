Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYDZLoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYDZLoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 07:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYDZLoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 07:44:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:59130 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751553AbYDZLoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 07:44:02 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19O83t+qp5Onzq3SDfReegWPIrCDNOV1g2q5yBCJk
	EyTJ12tBoexxfP
Subject: Re: [Bug 10328] New: [regression] performance drop for glx
From: Alexey Fisher <bug-track@fisher-privat.net>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       venkatesh.pallipadi@intel.com, jbarnes@virtuousgeek.org,
       keithp@keithp.com, airlied@gmail.com
In-Reply-To: <20080426000722.GJ14062@linux-os.sc.intel.com>
References: <bug-10328-27@http.bugzilla.kernel.org/>
	 <20080325152809.e2b07251.akpm@linux-foundation.org>
	 <20080326003912.GB3313@linux-os.sc.intel.com>
	 <47E9D42F.5080506@linux.intel.com> <1209101723.21553.1.camel@zwerg>
	 <20080426000722.GJ14062@linux-os.sc.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y7svv5w1sR+zcKq4PH1K"
Date: Sat, 26 Apr 2008 13:43:57 +0200
Message-Id: <1209210237.4583.4.camel@zwerg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-y7svv5w1sR+zcKq4PH1K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Freitag, den 25.04.2008, 17:07 -0700 schrieb Suresh Siddha:
> On Fri, Apr 25, 2008 at 07:35:23AM +0200, Alexey Fisher wrote:
> > > >> On Tue, 25 Mar 2008 15:11:15 -0700 (PDT)
> > > >> bugme-daemon@bugzilla.kernel.org wrote:
> > > >>
> > > >>> http://bugzilla.kernel.org/show_bug.cgi?id=3D10328
> > > >>>
> > > >>>            Summary: [regression] performance drop for glx
> > > >=20
> > > > Alexey, Can you please try the appended patch?
> > > >=20
> > > > Andrew, can you please push the appended patch for 2.6.25? Thanks.
> > > > ---
> > > >=20
> >=20
> >=20
> > This issue come again with commit:
> >=20
> > commit 2e5d9c857d4e6c9e7b7d8c8c86a68a7842d213d6
> > Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
> > Date:   Tue Mar 18 17:00:14 2008 -0700
> >=20
> >     x86: PAT infrastructure patch
> >=20
> >     Sets up pat_init() infrastructure.
> >=20
>=20
> Alexey, Sorry. I missed posting a fix in the post PAT series for this iss=
ue. Can you
> please try the appended patch and Ack?
>=20
> copying X folks get their attention and their Ack on the patch and next s=
teps outlined.
>=20
> Thanks.
> ---
>=20
> [patch] use UC minus for ioremap(), ioremap_nocache() and pci_mmap_page_r=
ange()
>=20
> Use UC_MINUS for ioremap(), ioremap_nocache() instead of strong UC.
> Once all the X drivers move to ioremap_wc(), we can go back to strong
> UC semantics for ioremap() and ioremap_nocache().
>=20

Thank you. This patch working.

Ack ?

--=-y7svv5w1sR+zcKq4PH1K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIExV9VVCoNUmKuAcRAtbZAKCjo97tjchJn/ntsK3WWqyR2VMRSwCeMjOD
pKOjS7F7DP88DMDhXCXOfg4=
=O3fr
-----END PGP SIGNATURE-----

--=-y7svv5w1sR+zcKq4PH1K--

