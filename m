Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbXHTORT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbXHTORT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 10:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXHTORI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 10:17:08 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39221 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbXHTORG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 10:17:06 -0400
Message-ID: <46C9A262.2030305@bull.net>
Date: Mon, 20 Aug 2007 16:17:06 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: kvm-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH 2/4] Introduce a new fields "gtime" and	"cgtime"
 in task_struct and signal_struct
References: <46C99392.3050205@bull.net> <200708201552.57617.borntraeger@de.ibm.com>
In-Reply-To: <200708201552.57617.borntraeger@de.ibm.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 16:22:16,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 16:22:17,
	Serialize complete at 20/08/2007 16:22:17
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB7C4CEF00D92095640E9C9A9"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB7C4CEF00D92095640E9C9A9
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Christian Borntraeger wrote:
> Am Montag, 20. August 2007 schrieb Laurent Vivier:
>> Index: kvm/fs/proc/array.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- kvm.orig/fs/proc/array.c    2007-08-20 11:11:30.000000000 +0200
>> +++ kvm/fs/proc/array.c 2007-08-20 13:04:03.000000000 +0200
>=20
> Just a heads up, this patch collides with this fix in mm:
> http://marc.info/?l=3Dlinux-mm-commits&m=3D118737949222362&w=3D2
>=20
> If Ingo accepts this fix, your patch should be adopted in array.c to us=
e=20
> cputime_t for gtime as well. Lets see what Ingo thinks.

Thank you for the comment. No problem for me to rewrite the patch accordi=
ng the
fix in the mm.

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enigB7C4CEF00D92095640E9C9A9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGyaJl9Kffa9pFVzwRApCjAKCe61UmAJONVpmruC2jQ0iSfzAQDACgv7h3
hREWrJDr8F+ByyK8/OVNiHo=
=MOyq
-----END PGP SIGNATURE-----

--------------enigB7C4CEF00D92095640E9C9A9--
