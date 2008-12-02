Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYLBO7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYLBO7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 09:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYLBO7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 09:59:10 -0500
Received: from mail.anarazel.de ([217.115.131.40]:58055 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbYLBO7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 09:59:09 -0500
From: Andres Freund <andres@anarazel.de>
To: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>
Subject: Re: EXT4 ENOSPC Bug
Date: Tue, 2 Dec 2008 15:58:53 +0100
User-Agent: KMail/1.10.90 (Linux/2.6.28-rc6-andres-00007-ged31348-dirty; KDE/4.1.80; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
References: <200811291418.24672.andres@anarazel.de> <200812012116.08510.andres@anarazel.de> <20081202075712.GA16172@mit.edu>
In-Reply-To: <20081202075712.GA16172@mit.edu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1255987.1abemzJ8u6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812021559.05103.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1255987.1abemzJ8u6
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ted, Hi Andreas,

On Tuesday 02 December 2008 08:57:12 Theodore Tso wrote:
> So.... could you apply this patch, attached below.  You can trigger it
> using the attached program, debug-ioctl.  If the filesystem is
> quiscent, and you've typed sync once or twice, you should get the
> following in your printk logs:
Ok. The system now runs (without problems) with the patch enabled and I can=
=20
get the debug output.
30 Minutes after boot the system still returns to zero dirty blocks and the=
=20
free blocks seem to stay in a sensible range.
I will let it run for a while and report back if either something interesti=
ng=20
happens or the problem reappears and I am seeing no significant amount of d=
irty=20
blocks.

Andres



--nextPart1255987.1abemzJ8u6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk1TS4ACgkQporPraT14ihobACfcJNYo+LhCCgD89/gehefDsN5
InkAniaB8QjY/XoXcn0efhWOpVCeP1sG
=7pCf
-----END PGP SIGNATURE-----

--nextPart1255987.1abemzJ8u6--
