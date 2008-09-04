Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYIDHsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYIDHsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYIDHsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:48:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45945 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYIDHsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:48:15 -0400
Date: Thu, 4 Sep 2008 17:48:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: linux-next: Tree for September 3
Message-Id: <20080904174801.5e448337.sfr@canb.auug.org.au>
In-Reply-To: <20080904001558.875f58b1.akpm@linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<20080903215455.792c78a3.akpm@linux-foundation.org>
	<20080904145744.3f791ca7.sfr@canb.auug.org.au>
	<20080903220546.bd673658.akpm@linux-foundation.org>
	<20080904152015.3145b06e.sfr@canb.auug.org.au>
	<20080903230129.806d54af.akpm@linux-foundation.org>
	<20080904001558.875f58b1.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Sep_2008_17_48_01_+1000_6/w36CFTaSknS3Yo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Sep_2008_17_48_01_+1000_6/w36CFTaSknS3Yo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 4 Sep 2008 00:15:58 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> I cannot find any of these patches on a mailing list.

Hmmm ...

> I cannot revert tty-kref-get-current-tty and I can't immediately spot
> the bug in it.

Yeah, it is a bit involved and caught up.

> I could revert the whole tty tree, but I'd prefer that you do it,
> please.  I've been trying for two days to get a -mm out, but I'm
> building on a foundation of straw :(

OK, I have done that for today ...  this is an actual revert (as I don't
have time this evening to go back and remerge everything after the ttydev
tree) so there is a bisect hole between when the tree gets merged and
when it gets reverted (not actually very large, but I though it was worth
mentioning).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Sep_2008_17_48_01_+1000_6/w36CFTaSknS3Yo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAki/krEACgkQjjKRsyhoI8xDIgCdF0mKOCJ2z+lYWhdPyEs8VE44
2tIAnRK+BwHBFDeUfUWZ0o+0JbOBshFI
=WHsv
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Sep_2008_17_48_01_+1000_6/w36CFTaSknS3Yo--
