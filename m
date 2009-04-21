Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbZDUTGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbZDUTGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbZDUTGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:06:42 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:36039 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZDUTGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:06:42 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <49EE1945.2080808@dell.com>
Date: Tue, 21 Apr 2009 14:06:45 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for more dell-wmi hotkeys
References: <49ECBAE2.2080308@dell.com> <49EE09D9.2060209@dell.com> <20090421183100.GA8120@srcf.ucam.org>
In-Reply-To: <20090421183100.GA8120@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4E8FC30A4E0F432844B1FDAB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4E8FC30A4E0F432844B1FDAB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthew:

Matthew Garrett wrote:
> On Tue, Apr 21, 2009 at 01:00:57PM -0500, Mario Limonciello wrote:
>  =20
>
> Hmm. I'll take a look over these - I was under the impression that Dell=
=20
> volume control was already of the software controlled type? The comment=
s=20
> about the ones that will send events via both is a bit disconcerting,=20
> but I'll check how we're handling these keys at the moment.
>  =20
Volume controls are still controlled via scan codes sent out by the EC.=20
This means the behavior doesn't change at all.  The keycodes that come
via WMI are just to inform the OS (or more specifically an application
on the OS) of the volume change.

On the Windows side this WMI event is used to display a volume OSD from
a Dell utility called Quick Set.

Regards
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enig4E8FC30A4E0F432844B1FDAB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknuGUUACgkQ2CrZjkA73YunAACfeiNAgclWhVxowWvrXfOiQpQL
C1wAn1/bEo8xSu38Aqp6e27Ffcne5C4b
=MG8M
-----END PGP SIGNATURE-----

--------------enig4E8FC30A4E0F432844B1FDAB--
