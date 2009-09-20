Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZITNus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZITNus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 09:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZITNur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 09:50:47 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46181 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbZITNuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 09:50:46 -0400
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Sep 2009 09:50:46 EDT
X-Sasl-enc: Wo+f79gTft+ZixGe/T5+NkHpjqBr8jyUxwUGqpYsMNay 1253454011
Message-ID: <4AB630AD.90207@imap.cc>
Date: Sun, 20 Sep 2009 15:39:57 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Status of Bug 8094 -  ipaq oops on connecting "Vodafone VPA-II" 
 ?
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig13F0B5C8F802056F43320F51"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig13F0B5C8F802056F43320F51
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

When I connect my "T-Mobile MDA compact III" to my PC, running
kernel 2.6.31 with openSUSE 10.3 userspace, I get exactly the
symptoms described in:

http://bugzilla.kernel.org/show_bug.cgi?id=3D8094

But that bug is marked as "CLOSED CODE_FIX", though reading through
the comments I found no clear indication what was actually fixed,
and from reading through the source files drivers/usb/serial/ipaq.c
and drivers/usb/serial/usb-serial.c I get the impression that the
problem of ipaq_open() oopsing because it gets called with
port->read_urb=3D=3DNULL is still present.

So can someone tell me what is the status of this bug?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig13F0B5C8F802056F43320F51
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKtjC3Q3+did9BuFsRAsH7AJ9B1FprU2gDeDbaOXlMFYrNZaVNiwCeJt4C
TF2vMSg+A9OS+3PvyiSl+N4=
=4oBc
-----END PGP SIGNATURE-----

--------------enig13F0B5C8F802056F43320F51--
