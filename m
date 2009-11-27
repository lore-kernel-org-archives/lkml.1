Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbZK0Kcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbZK0Kcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 05:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZK0Kcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 05:32:41 -0500
Received: from mail.klingt.org ([86.59.21.178]:47567 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbZK0Kck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 05:32:40 -0500
Message-ID: <4B0FAAC6.30906@klingt.org>
Date: Fri, 27 Nov 2009 11:32:38 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091124 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: "Leyendecker, Robert" <Robert.Leyendecker@lsi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: ext4: smp_processor_id() in preemptible
References: <4AC9C4FD.7080606@klingt.org> <8C8865ED624BB94F8FE50259E2B5C5B304593DAB98@palmail03.lsi.com>
In-Reply-To: <8C8865ED624BB94F8FE50259E2B5C5B304593DAB98@palmail03.lsi.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB66E6D3EFAF7D3F14E47A865"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Fri, 27 Nov 2009 11:32:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB66E6D3EFAF7D3F14E47A865
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

> I have similar crash, but probably different cause-vector, posted on th=
is list, fedora bugzilla, rt-users but no response so far from anyone. Di=
d you find any work around?  I tried looking at smp code for hints on pro=
blem it looks like in my case it could be trying to reschedule work on di=
fferent CPU at time of crash. However, I admit that I could be way, way o=
ff on that cause. In my case, if I hammer my network interface with packe=
ts while another app is reading packets, my host locks up and clients are=
 reporting dest unreachables.=20
>=20
> I don't think I have the problem in non-rt kernel. Have you tried booti=
ng without smp support?

i haven't tried to reproduce it since then ... it occurred, when i was
doing some heavy io tasks ...

tim

--=20
tim@klingt.org
http://tim.klingt.org

Nothing exists until or unless it is observed. An artist is making
something exist by observing it. And his hope for other people is that
they will also make it exist by observing it. I call it 'creative
observation.' Creative viewing.
  William S. Burroughs


--------------enigB66E6D3EFAF7D3F14E47A865
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksPqsYACgkQdL+4qsZfVstg+gCfTdLnqf51oy0Qy8MiD1uiyn/y
LH0AnjRVi/LFnuYvhDIpjdl2NVc2wskt
=zyB9
-----END PGP SIGNATURE-----

--------------enigB66E6D3EFAF7D3F14E47A865--
