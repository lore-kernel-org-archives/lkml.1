Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbXEYEIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbXEYEIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 00:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750731AbXEYEHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 00:07:54 -0400
Received: from iucha.net ([209.98.146.184]:42504 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbXEYEHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 00:07:53 -0400
Date: Thu, 24 May 2007 23:07:52 -0500
To: Jan Kara <jack@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops in dentry_iput with 2.6.22-rc2 on AMD64
Message-ID: <20070525040752.GB5762@iucha.net>
References: <20070522041036.GD6074@iucha.net> <20070522095711.GB27428@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <20070522095711.GB27428@atrey.karlin.mff.cuni.cz>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 22, 2007 at 11:57:11AM +0200, Jan Kara wrote:
> > I was running a multithreaded perl application that leaks some memory
> > so it gets to eat up a significant chunk of my 2 GB and even push a
> > bit into swap.  I left it running before going out for a walk.
>   Hmm, what seems suspitious is, that in R12 (which probably contains
> the address dereferenced later) is address ffff9100... while all other
> addresses start with ffff8100. So it seems to me it could be a 1-bit
> flip. Care to check your memory with memtest?

I let it run overnight: 8 passes and no surprises.  This is a system
that has been quite stable for a year and a half, except finding the
occasional kernel bug ;)

>   Also this is a code all other people use all the time so I guess we
> would see more reports if this was some general bug...

Haven't got any more oopses like that, either.

Thanks,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGVmEYND0rFCN2b1sRAnM/AKCABqe1Axv8e76SYi+nGaoYiU2VDACcD03n
xH/Q6x7l/78tv4zJAlOni28=
=BGQY
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
