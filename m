Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbXKGDZC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbXKGDZC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:25:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXKGDYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:24:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53343 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbXKGDYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:24:53 -0500
Date: Wed, 7 Nov 2007 14:24:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David <david@unsolicited.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc1 - Regularly getting processes stuck in D state on
 startup
Message-Id: <20071107142453.4379532e.sfr@canb.auug.org.au>
In-Reply-To: <20071106174626.3c7d3a14.sfr@canb.auug.org.au>
References: <472F5F8B.7090200@unsolicited.net>
	<20071106174626.3c7d3a14.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Nov_2007_14_24_53_+1100_TWlY8ZVexOPPP=HF"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Nov_2007_14_24_53_+1100_TWlY8ZVexOPPP=HF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Nov 2007 17:46:26 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> I am seeing something very similar on a PowerPC machine where copying a
> file from an LVM volume with ext3 on it to a simple scsi partition (again
> ext3) on the same disk will hang in congestion_wait.  If I am patient
> enough, the copy makes very slow progress.  A kill -9 will kill it
> eventually, but a simple control-C will not.

Turns out a simple control-C would kill the copy, I was just not patient
enough :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Nov_2007_14_24_53_+1100_TWlY8ZVexOPPP=HF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHMTAITgG2atn1QN8RAj1rAJ9ceEJX5cQN8SASDqIZfTXA+WpVLwCffb4d
BJoHHuyTyhUypfOxutP8W4o=
=0v+m
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Nov_2007_14_24_53_+1100_TWlY8ZVexOPPP=HF--
