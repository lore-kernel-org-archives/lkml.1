Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbZD1LyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbZD1LyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759421AbZD1Lxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:53:47 -0400
Received: from mxpdbe1.wincor-nixdorf.com ([80.154.98.129]:40286 "EHLO
	mxpdbe1.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758668AbZD1Lxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:53:46 -0400
Message-ID: <49F6ED54.7040200@wincor-nixdorf.com>
Date: Tue, 28 Apr 2009 13:49:40 +0200
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.19 (X11/20090107)
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Document the bcm5974 driver
References: <1240916817-18995-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1240916817-18995-1-git-send-email-rydberg@euromail.se>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2EECE7D1B2EAF52641D020BF"
X-OriginalArrivalTime: 28 Apr 2009 11:53:29.0475 (UTC) FILETIME=[F26B7D30:01C9C7F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2EECE7D1B2EAF52641D020BF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Henrik,

Henrik Rydberg wrote:
> This patch adds documentation for the bcm5974 to Documentation/input/.
>=20
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
=2E..
> +Debug output
> +------------
> +
> +To ease the development for new hardware version, verbose packet outpu=
t can
> +be switched on with the debug kernel module parameter. The range [1-9]=

> +yields different levels of verbosity. Example (as root):
> +
> +rmmod bcm5974 && sudo modprobe bcm5974 debug=3D9
> +
> +tail -f /var/log/debug
> +
> +rmmod bcm5974 && sudo modprobe bcm5974 debug=3D0

What about skipping rmmod and modprobe by doing
	echo -n 9 > /sys/module/bcm5974/parameters/debug
and
	echo -n 0 > /sys/module/bcm5974/parameters/debug
?

Kind regards,
Niels



--------------enig2EECE7D1B2EAF52641D020BF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFJ9u1U5KAkGQPO/QoRAqnIAKCV/5dqEhWrqiVbIsgjA1H2WgbLqQCgvJwo
dwPVB1xUngT7fFAso9TBK0k=
=KxUs
-----END PGP SIGNATURE-----

--------------enig2EECE7D1B2EAF52641D020BF--
