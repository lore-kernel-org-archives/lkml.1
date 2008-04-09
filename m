Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYDIL6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYDIL6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 07:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYDIL56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 07:57:58 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:4209 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYDIL55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 07:57:57 -0400
Message-ID: <47FCAF35.4000500@imap.cc>
Date: Wed, 09 Apr 2008 13:57:41 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       pavel@ucw.cz
Subject: Re: [2.6.25-rc6] possible regression: X server dying
References: <47E82D68.5070305@imap.cc>	 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>	 <47E83D14.8070800@imap.cc>	 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com>	 <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>	 <47F1FA3F.3010206@imap.cc> <47FA9EC2.6030801@imap.cc> <2c0942db0804071555w2dc2e43fw7cce64d4a5ba004@mail.gmail.com>
In-Reply-To: <2c0942db0804071555w2dc2e43fw7cce64d4a5ba004@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE45BC0E8597F0E0DFE8D2830"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE45BC0E8597F0E0DFE8D2830
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Ray Lee schrieb:
> If you think it's one of the screensavers but don't know which one,
> then open up a bash shell and do a
>=20
> for i in /usr/lib/xscreensaver/*; do echo $i; $i ; done
>=20
> hitting control-c to break out of the screensaver when you think it's
> been cleared of any wrongdoing.

Good idea. I did one pass through the screensavers that way, letting
each one run a couple of seconds until it seemed to become repetitive.
None of this crashed my X server, which at least seems to tell me that
it is not one particular screensaver always triggering the problem.

But: twice during that test I was called away, left the thing running,
and came back to find the X server had exited again, apparently after
the "real" screensaver had kicked in. Twice in a day, that's much more
than ever before. So you may have found me a way to trigger the crash
with greater probability.

Thanks,
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enigE45BC0E8597F0E0DFE8D2830
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH/K81Q3+did9BuFsRAu4NAJ99+GRIH+RUILQULVauRDUaQwVsZACfa3YI
aH2T9paJdauuC/NtbC4JxPo=
=NpvP
-----END PGP SIGNATURE-----

--------------enigE45BC0E8597F0E0DFE8D2830--
