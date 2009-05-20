Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZETRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZETRwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZETRwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:52:08 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:21581 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbZETRwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:52:07 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <4A144347.80303@dell.com>
Date: Wed, 20 May 2009 12:52:07 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
 suspend
References: <Pine.LNX.4.44L0.0905201010260.2914-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905201010260.2914-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB359AB15FA284C81FF087FC8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB359AB15FA284C81FF087FC8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Alan:

Alan Stern wrote:
> On Wed, 20 May 2009, Oliver Neukum wrote:
>
>  =20
>
> That's okay.  Inelegant, perhaps, but workable.  Besides, as we see=20
> below, the new rule would have to do more than the old rule.
>
>  =20
I agree this is a rather inelegant solution. A  new rule would have to
be added to hid2hci then.  It's much more preferable to be able to fix
kernel space from mucking up the device.  Is there a way to mark a
device to /not/ run reset-resume after S3?
>
> Does that create the same removal event?  If it does then you wouldd be=

> in an unfortunate state.  The script would have to check somehow
> whether the removal was deliberate or spontaneous.
>  =20
Yes it does create the same removal event when you switch to HID mode.=20
I don't know of any way that you can calculate if the switch was
intentional.


--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enigB359AB15FA284C81FF087FC8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoUQ0kACgkQ2CrZjkA73Ysy9gCfSMI5AHPnu9ESAQXALOUSWQFx
A7AAoJ7hcMAqSzOxokGhJWF5DRAOqi9o
=wsxt
-----END PGP SIGNATURE-----

--------------enigB359AB15FA284C81FF087FC8--
