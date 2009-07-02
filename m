Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbZGBRKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbZGBRKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZGBRKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:10:12 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:56394 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZGBRKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:10:11 -0400
Message-ID: <4A4CE9EA.6090807@novell.com>
Date: Thu, 02 Jul 2009 13:10:02 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Zoltan Bus <zoltan.bus@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problem with wake_up using real-time scheduling
References: <233789ed0906300144q209886b3qfb6737175a3660a0@mail.gmail.com>
In-Reply-To: <233789ed0906300144q209886b3qfb6737175a3660a0@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig883A1B3E3F1D94CF99F5D58D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig883A1B3E3F1D94CF99F5D58D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Zoltan Bus wrote:
> Hello,
>
> I have a problem on kernel 2.6.26.3. I have a real-time task which
> uses the select system call to poll my audio driver. The sleeping task
> is waken up by wake_up() from an interrupt handler.
> The problem is, that the wake_up() function  sometimes does not wake
> up the task if real-time priority is used.
>
> The try_to_wake_up() returns from the out_running section, because of t=
he check
>
>       if (p->se.on_rq)
>               goto out_running;
>
> There are no other tasks running when the poll function is called.
>
> Is this a known problem? Is it fixed somehow in newer versions?
> Unfortunately I do not have the possibility to change the newest kernel=
 version.
> I am a newbie at linux, thank you very much for your help.
>
>  =20

That *should* work fine.  Can you post your code?

Regards,
-Greg


--------------enig883A1B3E3F1D94CF99F5D58D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpM6e4ACgkQlOSOBdgZUxnloQCfWlj3Zb6gDZSiackEg1aT93dU
ejwAn1cbMHIbh19/MthL5xXuDzMDY7xC
=1job
-----END PGP SIGNATURE-----

--------------enig883A1B3E3F1D94CF99F5D58D--
