Return-Path: <linux-kernel-owner+w=401wt.eu-S1764621AbYBUK70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764621AbYBUK70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 05:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764007AbYBUK7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 05:59:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42315 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786AbYBUK7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 05:59:03 -0500
Date: Thu, 21 Feb 2008 21:58:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-net@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-net: no next-20080221 tree
Message-Id: <20080221215856.53bbecc5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Feb_2008_21_58_56_+1100_lwvabIx0dGd7e6AF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Feb_2008_21_58_56_+1100_lwvabIx0dGd7e6AF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have *not* released a new tree today (If you want to see why, have a
look at the left most column of
http://kisskb.ellerman.id.au/kisskb/branch/9).  This was caused my me
removing one of Greg KH's patches because it did not apply due to an
inadequacy in my procedures.

Basically, I have three quilt series from Greg and one of the patches in
the second one depends on something in the first series.  The BASE tag we
have implemented for series files was supposed to point to the place in
Linus' tree where the series should apply cleanly.  This (obviously)
turns out to be inadequate.  So we have a new tag NEXT_BASE which may
name another git tree/quilt series that is also included in the
linux-next tree.  This is most useful for those who have supplied more
than one series but may be used between consenting adults who trust each
other to keep their trees/series consistent enough.  Unfortunately this
will introduce a loose ordering between trees/series, but I think it will
be manageable.  I don't expect it to be used very much.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_Feb_2008_21_58_56_+1100_lwvabIx0dGd7e6AF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHvVl0TgG2atn1QN8RAhw6AJoDTDQIKINQ5tnnob2tBdJnzwphbACaAzUn
vN+W2m9aV2dnT+seNjaqwDg=
=O/Mq
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Feb_2008_21_58_56_+1100_lwvabIx0dGd7e6AF--
