Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbZL1Mng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbZL1Mng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 07:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZL1Mnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 07:43:35 -0500
Received: from mail.klingt.org ([86.59.21.178]:40325 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZL1Mne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 07:43:34 -0500
Message-ID: <4B38A707.4060904@klingt.org>
Date: Mon, 28 Dec 2009 13:39:35 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8pre) Gecko/20091226 Shredder/3.0.1pre
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: perf: counter and event question
References: <4B389391.8050303@klingt.org> <1261999573.7135.83.camel@laptop>
In-Reply-To: <1261999573.7135.83.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3B29FD9E88BD69C5B8EA44E1"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Mon, 28 Dec 2009 13:39:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3B29FD9E88BD69C5B8EA44E1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/28/2009 12:26 PM, Peter Zijlstra wrote:
> On Mon, 2009-12-28 at 12:16 +0100, Tim Blechmann wrote:
>> like it is impossible to sample instructions with a period of 1?=20
>=20
> Pretty much, imagine the cpu getting a trap every cycle.

is this a hardware restriction? a slowdown is acceptable for me, as long
as i am able to collect a huge number of samples accurately ...

> In order to avoid the machine grinding to a halt, we've implemented a
> throttle which defaults to 100k samples/s, anything over that will be
> discarted.

i just found the proc interface for perf_event_max_sample_rate ... it
would be nice to have a short section on the event throttling in
tools/perf/design.txt ...

thanks, tim

--=20
tim@klingt.org
http://tim.klingt.org

art is short - life is long
  Jack Kerouac


--------------enig3B29FD9E88BD69C5B8EA44E1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAks4pwoACgkQdL+4qsZfVstcGQCfX62aMsVJsX3lWnc6/nzMTkwU
aXwAoJ9ZyvYjQm/JjeEPA82rLUchk0M6
=RvG6
-----END PGP SIGNATURE-----

--------------enig3B29FD9E88BD69C5B8EA44E1--
