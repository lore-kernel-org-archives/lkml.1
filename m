Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbZDHSXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbZDHSXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbZDHSW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:22:57 -0400
Received: from mx0.hoeg.nl ([87.251.61.211]:62834 "EHLO palm.hoeg.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756892AbZDHSW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:22:57 -0400
Date: Wed, 8 Apr 2009 20:22:55 +0200
From: Ed Schouten <ed@FreeBSD.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Inconsistency between PTY read() return values
Message-ID: <20090408182255.GJ32098@hoeg.nl>
References: <20090408143631.GH32098@hoeg.nl> <20090408174716.6474af70@lxorguk.ukuu.org.uk> <20090408175603.GI32098@hoeg.nl> <20090408190916.0c213aba@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8884J15jRwcBTvu"
Content-Disposition: inline
In-Reply-To: <20090408190916.0c213aba@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8884J15jRwcBTvu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> A modem disconnect is a hang up which is quite different to an EOF and is
> effectively a security barrier as well (existing users of the tty port
> lose access to it aka revoke())

Ah, I see. I thought of a hangup as being a physical loss of carrier,
not the method of revoking processes from a TTY. So how come a hangup
can be seen by the pseudo-terminal master? Isn't that something that
should only cause file descriptors to the TTY to become invalid?

--=20
 Ed Schouten <ed@FreeBSD.org>

--n8884J15jRwcBTvu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (FreeBSD)

iEYEARECAAYFAknc634ACgkQ52SDGA2eCwU39gCeNp9tz6ymzhUEapSRBXy4wq9V
BJEAn2De2SPqsy5Q9JBXVqT1muT28Fhi
=EWHB
-----END PGP SIGNATURE-----

--n8884J15jRwcBTvu--
