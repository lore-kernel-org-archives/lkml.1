Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbZBQV43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbZBQV43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZBQV4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:56:19 -0500
Received: from mail.klingt.org ([86.59.21.178]:43949 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZBQV4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:56:18 -0500
Message-ID: <499B3271.6020306@klingt.org>
Date: Tue, 17 Feb 2009 22:56:01 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc4 regression
References: <1229869416.6911.1.camel@thinkpad> <49932C35.3020300@klingt.org>	 <20090213190740.GD25042@erda.amd.com> <20090216112313.359ef437@thinkpad>	 <20090216113349.GF25042@erda.amd.com>  <499961AF.8030909@klingt.org> <1234856740.6867.22.camel@marge.simson.net>
In-Reply-To: <1234856740.6867.22.camel@marge.simson.net>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9468F76E8BCF31710310F8E5"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.1.8 (klingt.org [127.0.0.1]); Tue, 17 Feb 2009 22:56:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9468F76E8BCF31710310F8E5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>> hm, i just tried to compile 2.6.28 with this patch applied, and there
>> the NMIs are delivered correctly.
>>
>>> Thanks Tim, on later kernels, is it the behaviour you mentioned that
>>> no NMIs are delivered and you do not receive any NMI?
>> on the current 2.6.29-rc5, no NMIs are delivered. however i have also
>> applied the performance counter branch from tip, maybe that interferes=

>> with oprofile?
>=20
> Hm.
>=20
> If you're using latest tip, there _should_ be no interference.  There
> was a problem a short while back in that both perfcounters and oprofile=

> register die handlers, but that was resolved by increasing oprofile's
> handler priority, so that it takes over NMI handling while profiling.

well, it seems to be a perfcounters vs. oprofile issue. when i applied
the patch i posted earlier onto vanilla 2.6.29-rc5, NMIs were delivered .=
=2E.

best, tim

--=20
tim@klingt.org
http://tim.klingt.org

The composer makes plans, music laughs.
  Morton Feldman


--------------enig9468F76E8BCF31710310F8E5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmbMnsACgkQdL+4qsZfVst7BQCferUb03OQ7AChL1F6CVxDUSY+
rDAAn1EpbDo7+qLLAxjMF48uvM9PC7ok
=+Jlr
-----END PGP SIGNATURE-----

--------------enig9468F76E8BCF31710310F8E5--
