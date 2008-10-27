Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYJ0TOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYJ0TOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYJ0TNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:13:54 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbYJ0TNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:13:52 -0400
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Soeren Sonnenburg <kernel@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20081027191118.GA4058@localhost.aei.mpg.de>
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <200810271832.40717.rjw@sisk.pl> <1225130844.4466.0.camel@localhost>
	 <1225132278.3796.32.camel@johannes.berg>
	 <1225133082.3796.35.camel@johannes.berg>
	 <20081027190011.GA3951@localhost.aei.mpg.de>
	 <1225134195.3796.39.camel@johannes.berg>
	 <20081027191118.GA4058@localhost.aei.mpg.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KMtfDeYdhhrHMcPb16hw"
Date: Mon, 27 Oct 2008 20:13:43 +0100
Message-Id: <1225134823.3796.45.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KMtfDeYdhhrHMcPb16hw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 20:11 +0100, Carlos R. Mafra wrote:

> > Do you get any kernel messages output? If you do, could you put message=
s
> > into each line of ieee80211_set_disassoc to see where it hangs?
>=20
> No messages appear, just a black screen.
>=20
> But I can use the SysRq keys, and when I umount the
> screen shows the message that umount succeed. I also tried SysRq+t but
> the messages appear to fast to read.

Ok, but that means you _can_ get messages, it would help a lot if you
could put a few printks into the set_disassoc function before/after each
other function call, so we know where exactly it hangs. Pretty much all
of them could possibly hang if there is some sort of locking error
happening or anything relies on userspace to be running...

johannes

--=-KMtfDeYdhhrHMcPb16hw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBhLjAAoJEKVg1VMiehFYtUEQAI40VHy8uvSWuKcpeHm5q4Nf
snMqWHg67wia13KqdKZPQbALU5d9Ck00n3j6r6ye2bH7yPXLVqQpnQYsVO+waBBR
5PyRSCKb5AouHcBczpIcDFSt0g5Tyqks55p56kF1ZC5aozsVqshtVobP47liLFsD
uC4+ZcDuYuUI4gmFsdlztw31NOWGGGtaymNOHnVNURwq1Ytf5l4GSgDDIzNHidMP
qo4ls8dLVeHKrqP7A6nBYxFeLK2mmMk5u8Kql4XAkJq5qC+2CgaI4zBiwVDaaUOl
6+EC//Y1xAiV+b/+DXJHAvuc3d9dZ8C947nEmBiSi7qq+NLpX5uUj/oWmQMgQe2B
zUOe1HkBBg5m6xcusfBXgn2JemCp8wyKP3twMrnbmj/8raF8sa77IBHFziDpaXQP
uBt4JF26a1iSu7ui0DWgJ+eIS2VUVo8XgVtyer0sWHfqTAuDbD1xw/qsRj4KCGjZ
acwES60/sRYrJhi+SCud13n5ZXNiop9Zy5JsFMiQIF15Ew5GPDxZeYazRf3NWymT
49/xEFpSwkLeZNWzYC3spmoSX0zSlLy4zOylyYKD5tck1r9qSELtYxFPqKznOzjd
PkDtPzE4tRhMO9h2DF1GMZ37gNE5hwbEaG+qrhRuyyB4pJEzA57Wqj5/0huTKQ0T
0e9eO5uh+JNgBIJXL0R3
=R6Rm
-----END PGP SIGNATURE-----

--=-KMtfDeYdhhrHMcPb16hw--

