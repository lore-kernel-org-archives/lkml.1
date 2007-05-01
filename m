Return-Path: <linux-kernel-owner+w=401wt.eu-S1031677AbXEALYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031677AbXEALYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031676AbXEALYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:24:05 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33671 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031677AbXEALYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:24:04 -0400
X-Sasl-enc: 8YZp+JeCLadnm0VGwlbe/yWfvQSIyYfHwoJOHNG9bHk0 1178018642
Message-ID: <463723F4.8060009@imap.cc>
Date: Tue, 01 May 2007 13:26:44 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative!
 (-1)
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>	<46338AEB.2070109@imap.cc>	<20070428141024.887342bd.akpm@linux-foundation.org>	<4636248E.7030309@imap.cc>	<20070430112130.b64321d3.akpm@linux-foundation.org>	<46364346.6030407@imap.cc> <20070430124638.10611058.akpm@linux-foundation.org>
In-Reply-To: <20070430124638.10611058.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig169B8AB500AA3D3DC48A5AF1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig169B8AB500AA3D3DC48A5AF1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 30.04.2007 21:46 schrieb Andrew Morton:
> Sure, but what about 2.6.21-git3 (or, better, current -git)?

2.6.21-git3 crashed with panic blink at "scanning usb: .."
(Nothing in the log this time.)

Will continue bisecting -rc7-mm2.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- Undetected errors are handled as if no error occurred. (IBM) -


--------------enig169B8AB500AA3D3DC48A5AF1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGNyP7MdB4Whm86/kRAu6NAKCCDqVmTb3bFAHvg6W3Mt6BHg28RgCeIQFg
y3R14g7jgk7fchI3j2WEdAE=
=HysZ
-----END PGP SIGNATURE-----

--------------enig169B8AB500AA3D3DC48A5AF1--
