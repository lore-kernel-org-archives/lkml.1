Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZESWUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZESWUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 18:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZESWTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 18:19:55 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:23443 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbZESWTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 18:19:54 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <4A13308E.4040703@dell.com>
Date: Tue, 19 May 2009 17:19:58 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
 suspend
References: <4A11C126.1000704@dell.com> <200905192326.46274.oliver@neukum.org> <4A1328D6.5090404@dell.com> <200905200016.49110.oliver@neukum.org>
In-Reply-To: <200905200016.49110.oliver@neukum.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig948EC0435FDE58DFE4091A13"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig948EC0435FDE58DFE4091A13
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi Oliver:

Oliver Neukum wrote:
> Am Dienstag, 19. Mai 2009 23:47:02 schrieb Mario Limonciello:
>  =20
>
> That is correct the devices have been successfully resumed and thus are=

> present. Generally the idea of suspened/resume is to have the same syst=
em
> after resumption. It is correct to not generate events. Usbcore cannot =
know
> that you use udev to switch the device from pure HID to HID + bluetooth=
=2E
>
>  =20
Right, which makes sense.
>
> Yes, the question is whether it is the clean thing to do.
>
> Marcel, are the HID devices usable after hid2hci has run? Should we
> choose to not resume from power loss any hid device which hid2hci
> operated on?
>
> 	Regards
> 		Oliver
>
>  =20
I can actually field this answer.  Currently those HID devices have no
purpose after hid2hci has operated on them.  If transitioned back into
full HID mode, then the mouse and keyboard HID devices can be functional.=


Regards

--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enig948EC0435FDE58DFE4091A13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoTMI4ACgkQ2CrZjkA73YuWnQCcDCG2bbVA1oZ9OrcOMPcmKQyd
gb4AoIiFinZdgpdW5+cw9jevG9Bf0ASQ
=wB0I
-----END PGP SIGNATURE-----

--------------enig948EC0435FDE58DFE4091A13--
