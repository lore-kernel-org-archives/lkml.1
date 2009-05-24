Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZEXXy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZEXXy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 19:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZEXXyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 19:54:50 -0400
Received: from ns2.puck.ch ([153.109.180.3]:54722 "EHLO puck.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753381AbZEXXyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 19:54:49 -0400
X-Greylist: delayed 1616 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 May 2009 19:54:49 EDT
Date: Mon, 25 May 2009 01:27:50 +0200
From: Olivier Bornet <Olivier.Bornet@puck.ch>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Olivier Bornet <Olivier.Bornet@puck.ch>
Subject: Problem with iuu_phoenix module
Message-ID: <20090524232750.GE13019@puck.ch>
Mail-Followup-To: Olivier Bornet <Olivier.Bornet@puck.ch>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
X-From: Olivier Bornet <Olivier.Bornet@puck.ch>
X-Url: http://puck.ch/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have just update my kernel to the last available, and I have some troubles
with the iuu_phoenix.c usb module. (update was from 2.6.22 to 2.6.29.2).

The problem seems to come at close(). I mean, when I do a close() of the
ttyUSBx device, the driver not only do the close(), but it's like that we
insert a new physical device.

For example, I have /dev/ttyUSB0. I have one programm successfully using it.
When this program close the device, a new one is coming up (/dev/ttyUSB1 if=
 I
have no other ttyUSB devices). Then, the "old" ttyUSB0 disaspear. This cause
troubles, because at each close(), the device change.

Is this a "feature", or a bug ?
Is this related to iuu_phoenix only, or to the USB system ?

Before, I was using the iuu_phoenix version 0.9 from
http://eczema.ecze.com/iuu_phoenix.html and this problem wasn't present.
But it's no more compatible with the kernel since 2.6.25 (or 26), due to the
changes in the USB structures. I have make a port of the changes done since=
 the
0.5 (which was the base used for the kernel version) to 0.9, and the same
problem exists. If the list is interested, I will be happy to send my patch.

TIA for any help.

Have a nice day.

        Olivier
--=20
Olivier Bornet
Olivier.Bornet@puck.ch
Swiss Ice Hockey Results : http://puck.ch/
Get my PGP-key at http://puck.ch/pgp or at http://pgp.mit.edu/

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFKGdf2dj3R/MU9khgRArxmAKDQvuCA8R4n5uLJJMPh4/p6wuQ6cwCgogjN
MIAq+J0HFxfKndIcDTpDVkY=
=H/jm
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
