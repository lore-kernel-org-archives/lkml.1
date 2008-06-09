Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbYFIJEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbYFIJEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 05:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbYFIJDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 05:03:45 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:46510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632AbYFIJDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 05:03:44 -0400
Subject: Re: Is configfs the right solution for configuration based fs?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Joel Becker <joel.becker@oracle.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>, Felix Fietkau <nbd@openwrt.org>,
       Al Viro <viro@ftp.linux.org.uk>, "H. Peter Anvin" <hpa@kernel.org>
In-Reply-To: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com> (sfid-20080608_232543_873639_74C0A387)
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
	 (sfid-20080608_232543_873639_74C0A387)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-djGUdjJlTFTxUVG1xU3+"
Date: Mon, 09 Jun 2008 11:03:07 +0200
Message-Id: <1213002187.698.62.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-djGUdjJlTFTxUVG1xU3+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I was really interested in looking to start a filesystem based
> approach for configuration of wireless a while back, an alternative to
> nl80211 if you will, but I stopped after I was told about some major
> issues with configfs. I forget the issues raised clearly so I'd like
> to bring this up for debate to see what really are the issues, what
> needs to be fixed so we can *properly* use a fs for configuration of
> subsystems.

Personally, I have a few issues with this:
 1) why bother with a second configuration interface that we have to
    maintain, adjust, ...? if we need scriptable access, then make a
    good userspace tool that is scriptable.
 2) string-based stuff is often messy, especially the varying attributes
    like MAC addresses etc. Unless we just use binary files again, which
    is not very useful again. Take, for example, the monitor flags. If
    we use the same flags then nobody really knows what's up=20
    (echo 0x3 > mntr_flags?) and if we use strings then we cannot easily
    ever rename the flag while keeping ABI/API compatibility.
 3) afaik configfs doesn't actually support the mkdir, ... stuff yet
    that you want for virtual interfaces.

johannes

--=-djGUdjJlTFTxUVG1xU3+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITPHIAAoJEKVg1VMiehFYdLcP/2bt2AWECyBOQuEE8+Td2nGA
8O6+oCgh3gvANEDRUluYZTHjQzBlwGxXOg9Dbh52YPP+RTHnUrZsaeFEkF3JC0ZW
CJTIfLXOfsH50RdSOEwokKDFOlETUcbAcd6HGcesBJtqLqHKN1DJlWEUNgEkewbn
X+CCkpBseJdu9F7bHq0Pi0ApxFisMhNcDusH/4b1Ca6+yRKZ7haj+qVsZJXA/JYM
xwdwriEmITXc61NoFojYdKvGIPzRaemQmxARAEc+S9pQ/26BXu1zwaqc72dDbSra
bVsZf/v9p2XR6i0UuXMZbP7z8tQzzTvnd041LEziI1zIq/Suh5YRXCDNr0w2nxAt
iBDvhWKD80oHjXqMEfQOFry9mmyw3ULdx3NGzD/WR60eJte+c/rt47EGqUF8GkHa
kRDOgCZzaE7o9RmxRicXx9+y6S/G3Tjn46cbuFnq690tsv30O61jPCFRyheekTzk
ayLhD26WPQqV/Xf06bl6YKUWz1+6L46WlZDJWJc1mgxllh8fOiAz2W7w8CTEN0QR
V7FVwp1WzKBxt0PhlyUGfRWaf8dGQpC5BO5wz+HVRZEq7J4vRmZUi3zj9FKvmuTM
UiO7KI8IQCD3VMDsgpJEEW0JYjDHTfs5HMabX/VXwEA0hi3lRd25LPAUb91au3Io
Y8hhP2DK2SUygqZteJKm
=Y/NG
-----END PGP SIGNATURE-----

--=-djGUdjJlTFTxUVG1xU3+--

