Return-Path: <linux-kernel-owner+w=401wt.eu-S1751116AbXCCT72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116AbXCCT72 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 14:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbXCCT72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 14:59:28 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53531 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbXCCT71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 14:59:27 -0500
X-Sasl-enc: KB8hn1C0EOQx/nm5G4hjdRP7uOWRXCZ9ZWkaz+yNeHjR 1172951966
Message-ID: <45E9D3EB.7070909@imap.cc>
Date: Sat, 03 Mar 2007 21:00:43 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Christopher Meller <cmeller@innominate.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question on tty line discipline
References: <20070228134711.GA8631@innominate.com>
In-Reply-To: <20070228134711.GA8631@innominate.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6DF406CBBD94BA3916E108EB"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6DF406CBBD94BA3916E108EB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 28.02.2007 14:47 schrieb Christopher Meller:
> When the line discipline is set via ioctl from  user space to e.g. N_PP=
P and the userspace program returns without resetting  the line disciplin=
e back to N_TTY, the serial device cannot be used (ENODV) until an approp=
riate  ioctl (to N_TTY) is performed. Is there any reason for the fact th=
at the line discipline is not reset by the kernel , when closing the devi=
ce.=20

Is that really so? While testing a line discipline I have written
myself (N_GIGASET_M101) I came to the opposite conclusion.

Specifically, when I set the line discipline on eg. /dev/ttyS1 to
N_GIGASET_M101 from the user space daemon I have written for that
purpose, and that user space daemon exits, my line discipline is
removed, ie. its .close method is called. That is true even if I
kill the user space daemon by sending it an uncaught signal.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig6DF406CBBD94BA3916E108EB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF6dPzMdB4Whm86/kRAt0hAJ44lnrmrvH8rsQltVqcMgdFZ3aL+QCfVoUN
f9jhYjbYwSlYRFfuDy7x+ZM=
=puh5
-----END PGP SIGNATURE-----

--------------enig6DF406CBBD94BA3916E108EB--
