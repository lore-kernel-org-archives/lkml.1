Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYK2Vbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYK2Vbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 16:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYK2Vbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 16:31:38 -0500
Received: from mail.anarazel.de ([217.115.131.40]:49123 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbYK2Vbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 16:31:37 -0500
From: Andres Freund <andres@anarazel.de>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4 ENOSPC Bug
Date: Sat, 29 Nov 2008 22:31:29 +0100
User-Agent: KMail/1.10.90 (Linux/2.6.28-rc6-andres-00007-ged31348; KDE/4.1.73; x86_64; ; )
Cc: adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
References: <200811291418.24672.andres@anarazel.de> <20081129211533.GG3372@mit.edu>
In-Reply-To: <20081129211533.GG3372@mit.edu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1439713.8OiprKbeP5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811292231.33799.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1439713.8OiprKbeP5
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 29 November 2008 22:15:33 Theodore Tso wrote:
> On Sat, Nov 29, 2008 at 02:18:19PM +0100, Andres Freund wrote:
> > On a testsystem (spare laptop) with ext4 as root filesystem sometimes t=
he
> > system starts to return ENOSPC to all write/create syscalls.
> > Sometimes the system runs without problems, at other times it starts
> > having problems soon after boot.
> Hmm.... Is there anything interesting log messages relating to ext4 or
> jbd2 showing up in /var/log/messages or in dmesg?
Nothing else than telling that barriers are not used (I am using dm-crypt..=
=2E),=20
but that shouldnt be related.

Andres

--nextPart1439713.8OiprKbeP5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkxtLIACgkQporPraT14igADwCfc5S8z5HUe+cNFzwAHQthKfyJ
sgMAniaE+RdaZalu3MYbSHSQEHSao4HI
=bUZF
-----END PGP SIGNATURE-----

--nextPart1439713.8OiprKbeP5--
