Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbZC0TXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbZC0TXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZC0TXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:23:13 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:62352 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZC0TXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:23:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type;
        b=DLFaf1zqFnPASZAbgLv08FH+zVBqO6mnebbLz57PylNEgb+q058k/PpP6ClAvGMokw
         c//YYACFZAanEEn0ydBMCdWDomn6xHZedCa+loQ18yQJRmf9YPQwm/CGzXLWe+9rY8C5
         MAuQs5Fut1hXb0JhrB1DnV7GQN3TY3Y8w6Hzk=
Date: Fri, 27 Mar 2009 20:24:06 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: cbou@mail.ru
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Using POWER or APM for battery handling
Message-Id: <20090327202406.60885d4a.kristoffer.ericson@gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Mar_2009_20_24_06_+0100_4sEUbgdgn=I4i3xN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Mar_2009_20_24_06_+0100_4sEUbgdgn=I4i3xN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Anton,

My machines (HP Jornada 600-series and HP Jornada 700-series) both
rely on batteries for power. Now, in the past it has all
been handled by an APM_EMULATION driver that
essentially detects the current state (loading YES/NO,=20
POWER_LEFT, ESTIMATED TIME LEFT,...) and adjusts
the state of the machine.

My question is should I port this to instead
use the power class (drivers/power) or not.

The batteries are same for both 600/700 but
contain no internal chip so I would need
seperate battery drivers for both machines.

Best wishes
Kristoffer Ericson

--=20
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Signature=_Fri__27_Mar_2009_20_24_06_+0100_4sEUbgdgn=I4i3xN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknNJ9YACgkQPQls10ERAGfkwgCcCcu7Fgka9nEvwUUzrQt1ykz5
M5EAoJirieqgGYT+rwopeP+V+7GxNr00
=tyl/
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Mar_2009_20_24_06_+0100_4sEUbgdgn=I4i3xN--
