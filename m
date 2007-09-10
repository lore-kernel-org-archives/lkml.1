Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbXIJNJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbXIJNJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbXIJNJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:09:08 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53009 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbXIJNJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:09:06 -0400
Message-ID: <46E541DD.4080202@bull.net>
Date: Mon, 10 Sep 2007 15:08:45 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH 0/4] Virtual Machine Time Accounting
References: <46E5325D.1020902@bull.net> <20070910120758.GA26835@elte.hu> <46E53D96.4050409@qumranet.com>
In-Reply-To: <46E53D96.4050409@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 15:14:46,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 15:14:46,
	Serialize complete at 10/09/2007 15:14:46
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9F1DD347F5C140BC2C9AC7CF"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9F1DD347F5C140BC2C9AC7CF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Ingo Molnar wrote:
>> * Laurent Vivier <Laurent.Vivier@bull.net> wrote:
>>
>> =20
>>> Ingo, please, could you have a look to these patches ?
>>>
>>> The aim of these four patches is to introduce Virtual Machine time
>>> accounting.
>>>
>>> [PATCH 1/4] as recent CPUs introduce a third running state, after
>>> "user" and "system", we need a new field, "guest", in cpustat to
>>> store the time used by the CPU to run virtual CPU. Modify /proc/stat
>>> to display this new field.
>>>    =20
>>
>> the concept certainly looks sane to me.
>>
>> The heavy-handed use of #ifdefs uglifies the code to a large degree,
>> but this is not a fundamental problem: since basically all distros
>> have KVM enabled (and lguest benefits from this too), could you just
>> make all this new code unconditional?
>>  =20
>=20
> I imagine the embedded people will complain... perhaps move all the cod=
e
> to a #ifdef section above with a full implementation and a stub
> implementation.
>=20

I'm going to repost patches without #ifdefs for readability.
Then we could discuss if we should introduce #ifdefs and how.

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig9F1DD347F5C140BC2C9AC7CF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFG5UHl9Kffa9pFVzwRApg5AJ0bNIss+j6AQsur4tLxcPRX+V5IkQCg2RIX
lP/ytPf1wRfnO4U40VyCOAg=
=W8LY
-----END PGP SIGNATURE-----

--------------enig9F1DD347F5C140BC2C9AC7CF--
