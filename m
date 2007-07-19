Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbXGSE7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbXGSE7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 00:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbXGSE7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 00:59:24 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:56503 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbXGSE7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 00:59:24 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>, Rafael Wysocki <rjw@sisk.pl>
Subject: Re: which signal is sent to freeze process?
Date: Thu, 19 Jul 2007 14:59:18 +1000
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707191218.32730.nigel@nigel.suspend2.net> <A3258B497F1C1441AD36A2E8B45FD6285508CB@scsmsx412.amr.corp.intel.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD6285508CB@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5700424.vk7ziQt0cb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707191459.20998.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5700424.vk7ziQt0cb
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 19 July 2007 14:09:56 Agarwal, Lomesh wrote:
> Can you point me to code where kernel captures process in signal
> handling and code which runs after suspend to ram is finished?

Sure.

It's in kernel/signal.c (get_signal_to_deliver) for x86 and x86_64, and=20
arch/<name>/kernel/signal.c for other arches. The support for other arches =
is=20
the place x86 & x86_64 used to use - I wonder if they should be going away=
=20
(Rafael cc'd to raise this point with him).

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart5700424.vk7ziQt0cb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGnu+oN0y+n1M3mo0RAtktAKCWaDywCZet2am1biPmqAGIQu9kPgCeJwL9
HWz0gZSQElm78LgAC3GS0mY=
=IQ97
-----END PGP SIGNATURE-----

--nextPart5700424.vk7ziQt0cb--
