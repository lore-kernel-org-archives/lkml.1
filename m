Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbYKZX3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbYKZX3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 18:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYKZX3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 18:29:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43342 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380AbYKZX3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 18:29:39 -0500
Date: Thu, 27 Nov 2008 10:29:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-arch@vger.kernel.org,
       Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RESEND:PATCH] [ARM] clearpage: provide our own
 clear_user_highpage()
Message-Id: <20081127102920.660303a5.sfr@canb.auug.org.au>
In-Reply-To: <1227719999.3387.0.camel@localhost.localdomain>
References: <20081126171321.GA4719@dyn-67.arm.linux.org.uk>
	<1227719999.3387.0.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__27_Nov_2008_10_29_20_+1100_A_H1BS4hZ8UrVxla"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Nov_2008_10_29_20_+1100_A_H1BS4hZ8UrVxla
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Wed, 26 Nov 2008 11:19:59 -0600 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> We'd like to pull this trick on parisc as well (another VIPT
> architecture), so you can add my ack.

If this is going to be used by more than one architecture during the next
merge window, then maybe the change to include/linux/highmem.h could be
extracted to its own patch and sent to Linus for inclusion in 2.6.28.
This way we avoid some conflicts and the architectures can do their
updates independently.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__27_Nov_2008_10_29_20_+1100_A_H1BS4hZ8UrVxla
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkt29AACgkQjjKRsyhoI8xlNwCdGtzz8Xqry+Mfoeqsp2kwONKg
QngAmwXaEVGMYIhL6oXlTDd1UfEWjmu9
=nQwJ
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Nov_2008_10_29_20_+1100_A_H1BS4hZ8UrVxla--
