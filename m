Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbXIJO4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbXIJO4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760769AbXIJOxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:53:53 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57665 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760771AbXIJOxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:53:51 -0400
Message-ID: <46E55A6C.6070106@bull.net>
Date: Mon, 10 Sep 2007 16:53:32 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH 1/4] Introduce a new field "guest" in cpustat
References: <46E53267.3010305@bull.net> <46E55996.8050009@redhat.com>
In-Reply-To: <46E55996.8050009@redhat.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 16:59:30,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 16:59:31,
	Serialize complete at 10/09/2007 16:59:31
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig12D0C24DE32420F7B0F5D537"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig12D0C24DE32420F7B0F5D537
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Rik van Riel wrote:
> Laurent Vivier wrote:
>> [PATCH 1/4] as recent CPUs introduce a third running state, after
>> "user" and
>> "system", we need a new field, "guest", in cpustat to store the time
>> used by
>> the CPU to run virtual CPU. Modify /proc/stat to display this new fiel=
d.
>=20
> I think it would be good to always print out that number, even if
> it is zero without the CONFIG option set.
>=20
> Changing the format of /proc/stat depending on config options is
> probably worse than changing it when moving kernel versions.
>=20
> I guess reusing the "steal" field is not a good idea, since your
> new "guest time" has different semantics than the steal time field.
>=20

I agree with all.

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig12D0C24DE32420F7B0F5D537
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFG5Vpw9Kffa9pFVzwRArCsAJ4rfbdF40s6U3lRcvwmCtWCv1knzwCaA7V+
uomkHAaNoy5Hwpe6aiT1jsY=
=DvuM
-----END PGP SIGNATURE-----

--------------enig12D0C24DE32420F7B0F5D537--
