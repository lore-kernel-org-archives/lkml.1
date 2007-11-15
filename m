Return-Path: <linux-kernel-owner+w=401wt.eu-S933434AbXKOVcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434AbXKOVcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXKOVcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:32:35 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41232 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204AbXKOVce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:32:34 -0500
X-Sasl-enc: edtlBez39+V+teE07qpuu5SulKFvDmlEYJ0pkcw2vNfJ 1195162352
Message-ID: <473CBB1A.8080606@imap.cc>
Date: Thu, 15 Nov 2007 22:33:14 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: power-management.txt - disconnect clarification
References: <Pine.LNX.4.44L0.0711121435180.1567-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711121435180.1567-100000@netrider.rowland.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig506893AACF916B6802F38D6A"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig506893AACF916B6802F38D6A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 12.11.2007 20:42 schrieb Alan Stern:

> I don't like the second sentence very much.  How about something like=20
> this instead:
>=20
> +If the device is disconnected or powered down while it is suspended,
> +the disconnect method will be called instead of the resume or
> +reset_resume method.  This is also quite likely to happen when
> +waking up from hibernation, as many systems do not maintain suspend
> +current to the USB host controllers during hibernation.  (It's
> +possible to work around the hibernation-forces-disconnect problem by
> +using the USB-Persist facility, described in
> +Documentation/usb/persist.txt.)

Fine by me.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig506893AACF916B6802F38D6A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHPLsjMdB4Whm86/kRAlyyAJ9iR46/G8mRiybHcLboXF3atNpEHACeJ/EU
hty+C+RW/gyJ8AVMzMSi4TE=
=Ww4s
-----END PGP SIGNATURE-----

--------------enig506893AACF916B6802F38D6A--
