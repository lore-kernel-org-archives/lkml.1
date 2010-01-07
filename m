Return-Path: <linux-kernel-owner+w=401wt.eu-S933179Ab0AGAEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179Ab0AGAEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571Ab0AGAEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:04:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58185 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568Ab0AGAE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:04:29 -0500
Date: Thu, 7 Jan 2010 11:04:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, phillip.lougher@gmail.com,
       tim.bird@am.sony.com,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: [PATCH V2 6/8] lzma: Make lzma available to non
 initramfs/initrd code
Message-Id: <20100107110422.3bc51a12.sfr@canb.auug.org.au>
In-Reply-To: <20100106140409.ba0f63d1.akpm@linux-foundation.org>
References: <E1NIuOW-0001ol-RC@dylan.lougher.demon.co.uk>
	<20100106140409.ba0f63d1.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Jan_2010_11_04_22_+1100_y6U+QuFA=24u49Ic"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Jan_2010_11_04_22_+1100_y6U+QuFA=24u49Ic
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 6 Jan 2010 14:04:09 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> So if I go ahead with that merge, linux-next will need fixing.  And I
> didn't get down and work what the appropriate fix is, and I don't want
> to break linux-next in serious ways.

Why not, everyone else does :-)

> So what to do?  I guess I could go ahead with the mainline merge, and
> Stephen drops <whatever that tree was> from linux-next until it has
> been fixed up?

Just do the merge ... I will just need to drop the squashfs tree until
they do a merge/rebase with Linus' tree and fix it all up.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Jan_2010_11_04_22_+1100_y6U+QuFA=24u49Ic
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktFJQYACgkQjjKRsyhoI8zIgACfTXVPPDd1NK4JnJWDtShtIDod
OT0AoJ7ue4wpGRSHlulNfApNzbF1iy8X
=/BwD
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Jan_2010_11_04_22_+1100_y6U+QuFA=24u49Ic--
