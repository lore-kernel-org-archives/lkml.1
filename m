Return-Path: <linux-kernel-owner+w=401wt.eu-S934039AbXDBNUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039AbXDBNUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 09:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934041AbXDBNUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 09:20:17 -0400
Received: from cel.leonerd.org.uk ([62.49.94.186]:3816 "EHLO cel.leo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934039AbXDBNUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 09:20:16 -0400
Date: Mon, 2 Apr 2007 14:20:14 +0100
From: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Daniel Jacobowitz <dan@debian.org>
Subject: Re: [PATCH 17/16] Do not reset UTF8 on terminal reset
Message-ID: <20070402132013.GM26707@cel.leo>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012001130.12316@yvahk01.tjqt.qr> <1175496595.4614.11.camel@daplas> <Pine.LNX.4.61.0704020904460.1245@yvahk01.tjqt.qr> <20070402112607.GK26707@cel.leo> <1175514253.4431.7.camel@daplas> <20070402115411.GL26707@cel.leo> <1175518079.4545.3.camel@daplas>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="84ND8YJRMFlzkrP4"
Content-Disposition: inline
In-Reply-To: <1175518079.4545.3.camel@daplas>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--84ND8YJRMFlzkrP4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 02, 2007 at 08:47:59PM +0800, Antonino A. Daplas wrote:
> How about this? This should allow us to reset the terminal without
> affecting utf, and also allows setting of a global utf default that can
> be set via boot option or sysfs:
>=20
> echo 1 > /sys/module/vt/parameters/default_utf

That's almost exactly what my suggestion was :)

(except that mine went into /proc/tty/vt/default_utf8_mode, but anywhere
is good really)

--=20
Paul "LeoNerd" Evans

leonerd@leonerd.org.uk
ICQ# 4135350       |  Registered Linux# 179460
http://www.leonerd.org.uk/

--84ND8YJRMFlzkrP4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGEQMN7eTlovtaLtYRAoMVAKDAtu4dCEHTeNBmprvqtYd3Xjp/8gCfabOM
eVbX11DH6hIpc3kBK2djFJw=
=lYTT
-----END PGP SIGNATURE-----

--84ND8YJRMFlzkrP4--
