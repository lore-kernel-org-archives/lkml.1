Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbYAOMGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbYAOMGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYAOMG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:06:26 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:36066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbYAOMGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:06:25 -0500
Subject: hrtimer.c devinit vs. cpuinit
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BsXEK8dIVobrjMRWcE5M"
Date: Tue, 15 Jan 2008 01:30:10 +0100
Message-Id: <1200357010.5887.72.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BsXEK8dIVobrjMRWcE5M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Looking through hrtimer.c I noticed

static void __devinit init_hrtimers_cpu(int cpu)

static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
                                        unsigned long action, void *hcpu)


Couldn't the first be __cpuinit as well?

johannes

--=-BsXEK8dIVobrjMRWcE5M
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4v+kaVg1VMiehFYAQLZ8A//bsItYV/xnnpQkPhQsh2Qn3RCkPbokz7U
XMFbeA1GPi3zxpJE5TMYfi5zUWHsFCcq2RgfjcyWygF2jANi5xVgkgKGyTEi/hDs
R92LDtLKsJ9W59oPZfVDz2H2u+NRwip/Ieow32BAHNdp0AWjxfbyNBP2WXfNztRt
+Vys54PJpFoT7wfM+4Lc08owOjNzdW74QUNDGdovi85l/OLIhBqErg66whGm1JAX
76FfUddtL1Fk5adgNNkA6t8oIFd78uiMLCReQ/TlxjDp5sFJzylmS8WBQTj6X8U7
dqqynRslfk3WQqHTMpXC9SiDRGeAeJgrlcFS0rzKPRfbpDxUNFMooCRp0X0oKByU
3ar+NBpnevpVsOxL4rnRbmTG0Wviv8w2TL1TCqwuLb5QirB9p1MdZa4tWj8Ebtl2
+37pOBfiMN5humEVO1HmIjus0Ivhc1956jezwBkDymuhqQbvQuY5+XXT8Ep5hVAs
/Q+LHcjwMN7K5H1Q4rUpjgy3oCFIu/9Ah+2Ea5zEoJrIdyH/K/DfXKKgWFIVagnt
zE4OsTPXSJXM4oZtmWGqRhDmvH8EPQTvuKs3WL5zUOCDStImKhJOJ+XuYo7W+IN6
zNExb8xcjBG+pMZmQTtuCdDUUu7VgzfSoxumLq7TUjSYSlpNLKxBDLtdE6REHV1L
aSmYD/+AUww=
=LHqE
-----END PGP SIGNATURE-----

--=-BsXEK8dIVobrjMRWcE5M--

