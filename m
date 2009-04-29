Return-Path: <linux-kernel-owner+w=401wt.eu-S1761270AbZD2VYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270AbZD2VYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbZD2VYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:24:39 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:17671 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663AbZD2VYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:24:38 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <49F8C59F.2010603@dell.com>
Date: Wed, 29 Apr 2009 16:24:47 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for more dell-wmi hotkeys
References: <49ECBAE2.2080308@dell.com> <49EE09D9.2060209@dell.com> <20090429165729.GB32619@srcf.ucam.org> <49F89981.10806@dell.com> <20090429183154.GC2325@srcf.ucam.org>
In-Reply-To: <20090429183154.GC2325@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7124979DF7E8A771191AD0B1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7124979DF7E8A771191AD0B1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthew:

Matthew Garrett wrote:
> It's a precision M6300 - I'm afraid I'm not sure what BIOS it's running=
=2E
>  =20
I've obtained one of these and taken a look at it with a copy of Win 7
and compared with dell-wmi and my patchset applied.  This platform's WMI
support was introduced before Win7's WMI spec was drafted, and so it
doesn't adhere to the spec.  I think the best thing to do will be create
a DMI table to match for keys that are only on a per system basis for
anything before this spec was ready.  I don't expect many other
platforms like this, but it will allow for additional granularity in
case something in the future ever deviates spec as well.

Regards
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enig7124979DF7E8A771191AD0B1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn4xZ8ACgkQ2CrZjkA73YteMQCffe5FY0RE/rSpmPs51cj67AVA
l/UAoIWNT40e6yLazHv9HZi5lOaffla6
=l75r
-----END PGP SIGNATURE-----

--------------enig7124979DF7E8A771191AD0B1--
