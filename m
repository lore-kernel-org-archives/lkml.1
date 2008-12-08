Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYLHTNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYLHTNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 14:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYLHTNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 14:13:33 -0500
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:59799 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYLHTNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 14:13:32 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2008 14:13:32 EST
Subject: Re: ALPS input driver problem with DualPoint on Dell E6400/E6500
 [patch]
From: Alexander Hofbauer <alex@derhofbauer.at>
To: linux-kernel@vger.kernel.org
Cc: Matthew Chapman <matthewc@cse.unsw.edu.au>
In-Reply-To: <20081208141438.GA30462@cse.unsw.EDU.AU>
References: <1227638742.5353.5.camel@mobian>
	 <20081208141438.GA30462@cse.unsw.EDU.AU>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-M6guejIb0X6bRoq5186Q"
Date: Mon, 08 Dec 2008 20:06:45 +0100
Message-Id: <1228763205.3637.28.camel@mobian>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
X-Df-Sender: 420630
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M6guejIb0X6bRoq5186Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Die, 2008-12-09 at 01:14 +1100, Matthew Chapman wrote:
> Hi,
>=20
> Here's a patch that implements the 9-byte packet format, which solves
> the problem for me.

Thank you.


Indeed, the patch seems to work except for losing "grip" when using e.g.
the DualPoint Stick and the touchpad buttons at the same time.

Let's assume I click a window decoration drawn by compiz
(gtk-window-decorator) to move the window and the use the Stick. At
"normal" speed the window is dropped immediately. If I start dragging
very slowly I can sometimes move it successfully.

Playing around and trying to get some usable output from xev I could
reproducibly freeze the whole system (at least graphical output and
keyboard/mouse input) but I don't know if this is related to using
2.6.28-rc7 or the video drivers+compiz or the ALPS DualPoint anyway.

I nevertheless also experimented with metacity. Dragging works most of
the time but even metacity sometimes seems to interpret a double click
and maximizes the window instead of starting to move it.


So I'm quite positive that this patch still has some rough edges and
events that don't belong where they appear (or at least are not expected
by the window managers) because not mixing Touchpad's and -stick's
controls doesn't have any issues at all.



Greetings from Austria,
Alex

--=-M6guejIb0X6bRoq5186Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk9cEEACgkQER+ES1ZqwmW57gCggjDZsWXDWb0gwntWsWJlmgrD
d9kAn1RMYwJ9lxDqr5qZ6YLmwXH1FWxx
=jZuF
-----END PGP SIGNATURE-----

--=-M6guejIb0X6bRoq5186Q--

