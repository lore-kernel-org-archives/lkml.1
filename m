Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbXIJMQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbXIJMQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932760AbXIJMQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:16:20 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37579 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439AbXIJMQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:16:19 -0400
Message-ID: <46E5357E.8090108@bull.net>
Date: Mon, 10 Sep 2007 14:15:58 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH 0/4] Virtual Machine Time Accounting
References: <46E5325D.1020902@bull.net> <20070910120758.GA26835@elte.hu>
In-Reply-To: <20070910120758.GA26835@elte.hu>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 14:21:57,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 14:21:59,
	Serialize complete at 10/09/2007 14:21:59
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC705708DF9DAF7325D95C21B"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC705708DF9DAF7325D95C21B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Laurent Vivier <Laurent.Vivier@bull.net> wrote:
>=20
>> Ingo, please, could you have a look to these patches ?
>>
>> The aim of these four patches is to introduce Virtual Machine time=20
>> accounting.
>>
>> [PATCH 1/4] as recent CPUs introduce a third running state, after=20
>> "user" and "system", we need a new field, "guest", in cpustat to store=
=20
>> the time used by the CPU to run virtual CPU. Modify /proc/stat to=20
>> display this new field.
>=20
> the concept certainly looks sane to me.
>=20
> The heavy-handed use of #ifdefs uglifies the code to a large degree, bu=
t=20
> this is not a fundamental problem: since basically all distros have KVM=
=20
> enabled (and lguest benefits from this too), could you just make all=20
> this new code unconditional?

No problem for me.

Thank you,
Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enigC705708DF9DAF7325D95C21B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFG5TWB9Kffa9pFVzwRAkEIAJ9l/GuvN/n6AYq4zxMNFfX8lvyX+QCcD9Eb
JuhcYaCKnPpxaFYu9Di6nvE=
=k0F5
-----END PGP SIGNATURE-----

--------------enigC705708DF9DAF7325D95C21B--
