Return-Path: <linux-kernel-owner+w=401wt.eu-S1752307AbYKYHSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbYKYHSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYKYHSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:18:25 -0500
Received: from foo.birdnet.se ([213.88.146.6]:45490 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750910AbYKYHSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:18:24 -0500
Message-ID: <20081125071818.9256.qmail@stuge.se>
Date: Tue, 25 Nov 2008 08:18:18 +0100
From: Peter Stuge <peter@stuge.se>
To: Yuval Hager <yuval@avramzon.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Michael Buesch <mb@bu3sch.de>,
       bcm43xx-dev@lists.berlios.de
Subject: Re: BCM4312 Fails when xdm is started
Mail-Followup-To: Yuval Hager <yuval@avramzon.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Michael Buesch <mb@bu3sch.de>,
	bcm43xx-dev@lists.berlios.de
References: <200811151801.02369.yuval@avramzon.net> <200811241155.47079.mb@bu3sch.de> <492AD249.3020309@lwfinger.net> <200811250745.22487.yuval@avramzon.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
Content-Disposition: inline
In-Reply-To: <200811250745.22487.yuval@avramzon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Yuval Hager wrote:
> I played around with different video drivers and the results are:
> * If using the 'via' driver, I lose the PCIe card immediately upon=20
>   initialization
> * Using the 'openchrome' (trunk version), It works well in the
>   beginning.
>   After first blanking the register reads are all 1's, and then
>   when the screen is blank I get a different read (some registers
>   are correct, some are wrong), and when the screen is unblanked, I
>   get 0xff's again. Very consistent and predictabe (same read every
>   time).
> * Using the 'vesa' driver I could not recreate the problem. I could
>   not get the screen to blank for some reason, but closing the lid,
>   going on standby/hibernate, restarting X - all didn't matter much
>   to the PCI and the wireless card kept on working.

Good work! You have beyond any doubt established that the X graphics
driver can cause this problem.

Were you using a kernel framebuffer driver when you saw the problem
also without running X at all? If not, the cause of trouble then is
still unidentified.


//Peter

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFJK6a6hR3Q0dhIfEgRAuzFAJsE2hEB28Qq7hGhlGXnB3WDr2d5cwCgkn18
VaGfWMftljqwwjuAyDc/W/c=
=Bd8Y
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
