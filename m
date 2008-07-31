Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbYGaT0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbYGaT0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYGaTZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:25:54 -0400
Received: from xsmtp0.ethz.ch ([82.130.70.14]:21870 "EHLO XSMTP0.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbYGaTZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:25:53 -0400
Message-ID: <489211BB.9060507@gmx.de>
Date: Thu, 31 Jul 2008 21:25:47 +0200
From: Dieter Ries <clip2@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080617)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org, willy@linux.intel.com, pavel@suse.cz,
       len.brown@intel.com, linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: suspend to  ram regression in current GIT, bisected
References: <48920CF7.4060907@gmx.de> <200807311207.49335.jbarnes@virtuousgeek.org>
In-Reply-To: <200807311207.49335.jbarnes@virtuousgeek.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig489EF72CA91E12030138429A"
X-OriginalArrivalTime: 31 Jul 2008 19:25:51.0420 (UTC) FILETIME=[3E555FC0:01C8F343]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig489EF72CA91E12030138429A
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Jesse Barnes schrieb:
> On Thursday, July 31, 2008 12:05 pm Dieter Ries wrote:
>> Hi,
>>
>> starting from 2.6.27-rc1, my Laptop (Thinkpad T60) did not return from=

>> suspend to ram anymore.
>>
>> When it should resume, the sleep LED went off, power went on, HD LED
>> flashed once, but the display stayed black.
>=20
> Can you test the fix in http://bugzilla.kernel.org/show_bug.cgi?id=3D11=
178? =20
> Hopefully it's a DUP.

Yes the patch fixed it here. It also fixes IO garbage while shutting=20
down here.
Thanks!

>=20
> Thanks,
> Jesse
>=20

cu
Dieter

--=20
3rd Law of Computing:
         Anything that can go wr
fortune: Segmentation violation -- Core dumped


--------------enig489EF72CA91E12030138429A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkiSEb4ACgkQ5YzjaZZeXo3s/ACgku4aMrDa2jMbLksfQdrbebFb
PNwAoI0WLbD+JvgKhAzBFaJu1Lg0yyOM
=lmQr
-----END PGP SIGNATURE-----

--------------enig489EF72CA91E12030138429A--
