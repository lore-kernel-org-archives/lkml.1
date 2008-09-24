Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbYIXOKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbYIXOKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYIXOKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:10:30 -0400
Received: from bavaria.utcluj.ro ([193.226.5.35]:63973 "EHLO bavaria.utcluj.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbYIXOK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:10:29 -0400
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
From: Cristi Magherusan <cristi.magherusan@net.utcluj.ro>
Reply-To: cristi.magherusan@net.utcluj.ro
To: Yan Li <elliot.li.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, joerg.roedel@amd.com,
       rjmaomao@gmail.com, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
In-Reply-To: <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com>
References: <48D12490.5010003@zytor.com>
	 <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-V5xXsQf1BtKtKoUE5a8C"
Organization: Universitatea Tehnica din Cluj-Napoca, Centrul de Comunicatii
	"Pusztai Kalman"
Date: Wed, 24 Sep 2008 17:10:24 +0300
Message-Id: <1222265424.5708.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V5xXsQf1BtKtKoUE5a8C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-24 at 20:22 +0800, Yan Li wrote:
> Detects whether we are running as a VMware guest or not. Detection is
> based upon DMI vendor string.
>=20
> It provides a function:
> int is_vmware_guest(void)
> that can be used easily to detect if we are running as a VMware guest
> or not.

We can also use this feature to force the HZ value to 100 or 250 at most
when running in a virtual environment, since VirtualBox had some issues
with this by taking a lot of CPU time when the HZ was set to 1000.

Cristi

--=20
Cristi M=C4=83gheru=C8=99an,
Inginer de sistem/retea
Universitatea Tehnic=C4=83 din Cluj-Napoca
Centrul de Comunica=C8=9Bii "Pusztai Kalman"
Tel. 0264/401247  http://cc.utcluj.ro

--=-V5xXsQf1BtKtKoUE5a8C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjaSlAACgkQfwrBISYVZFWpggCeOWzdiWDyk0s6udCHheNDkLwe
ETsAnApovgTSQlID5bGxDIKm9JAOmyAx
=ReHD
-----END PGP SIGNATURE-----

--=-V5xXsQf1BtKtKoUE5a8C--

