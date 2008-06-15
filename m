Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYFOXKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYFOXKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 19:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYFOXKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 19:10:30 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55611 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756031AbYFOXKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 19:10:12 -0400
X-Sasl-enc: opmToQyqxmXxGgabfoQrS9dzFmNDQt2OGOt5RNf6IZhg 1213571411
Message-ID: <4855A145.90803@imap.cc>
Date: Mon, 16 Jun 2008 01:09:57 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andreas Herrmann <aherrman@arcor.de>
CC: Hansjoerg Lipp <hjlipp@web.de>, gigaset307x-common@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kkeil@suse.de
Subject: Re: [PATCH] gigaset: fix module reference counting
References: <20080606223918.GA10348@kodscha>
In-Reply-To: <20080606223918.GA10348@kodscha>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig56C37E01A1215C31AC0A9CA5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig56C37E01A1215C31AC0A9CA5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Andreas,

On 2008-06-07 00:39, Andreas Herrmann wrote:
> bas_gigaset can't be unloaded due to wrong module reference counting.
> Ensure that module_put is called whenever a channel is freed.

I'm not quite happy with that patch. Specifically, I see a risk of
module_put being called too often.

Could you explain in some more detail what bug you are trying to fix?
Do you have a sequence of events which leads to a situation where the
bas_gigaset module cannot be unloaded but should be?


Thanks,
Tilman


--------------enig56C37E01A1215C31AC0A9CA5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIVaFQQ3+did9BuFsRAiFFAJ9zpkPsucd5Hwuw22vbAQeiKKDQAwCfUZb7
ZJ4M7sfH1cL1PEpfYYRIjwQ=
=+5NR
-----END PGP SIGNATURE-----

--------------enig56C37E01A1215C31AC0A9CA5--
