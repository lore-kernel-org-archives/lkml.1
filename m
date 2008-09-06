Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbYIFUvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbYIFUvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 16:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYIFUvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 16:51:44 -0400
Received: from bavaria.utcluj.ro ([193.226.5.35]:54133 "EHLO bavaria.utcluj.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYIFUvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 16:51:43 -0400
X-Greylist: delayed 1911 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Sep 2008 16:51:43 EDT
Subject: Power management stuff
From: Cristi Magherusan <cristi.magherusan@net.utcluj.ro>
Reply-To: cristi.magherusan@net.utcluj.ro
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4KryEtvPS9ZYxxm36+Lf"
Organization: Universitatea Tehnica din Cluj-Napoca, Centrul de Comunicatii
	"Pusztai Kalman"
Date: Sat, 06 Sep 2008 23:19:46 +0300
Message-Id: <1220732386.18701.68.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4KryEtvPS9ZYxxm36+Lf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello,


I have a few ideas/questions about some power management-related issues:

1) How could we get the current frequency/voltage settings for the CPU,
fr example when using SpeedStep by using the /proc filesystem?

2) It would be nice to modify a bit the CPU throttling API to be able to
set a max value when using dynamic governors, like ondemand.=20
The frequency/voltage pair should be set to the minimum allowed by
construction, just like it was before, and scale up to a max value set
by the user. This would allow the user set the best balance between
responsiveness and power consumption that suits its needs.
Also, targeting a certain temperature would be a great feature to have.

3) Is there any plan to improve the current battery framework and
provide information about the estimated recharging time, as it was
before. I guess the versions before 2.6.24 used to provide this but the
newer versions don't do it anymore.

Thanks,
Cristi


--=-4KryEtvPS9ZYxxm36+Lf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjC5eIACgkQfwrBISYVZFUdbACgjJJCOBOwhHFGd770k6z/zqt7
qsoAoI9SIpux2Uvn3X1+NYE1jORpissu
=Fgmt
-----END PGP SIGNATURE-----

--=-4KryEtvPS9ZYxxm36+Lf--

