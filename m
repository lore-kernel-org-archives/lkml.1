Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbZHaL7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbZHaL7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZHaL7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:59:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40550 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZHaL7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:59:09 -0400
Date: Mon, 31 Aug 2009 21:59:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: linux-next: i2c tree build failure
Message-Id: <20090831215905.caadce2f.sfr@canb.auug.org.au>
In-Reply-To: <20090831131647.3f609ad4@hyperion.delvare>
References: <20090831111935.5059565b.sfr@canb.auug.org.au>
	<20090831120449.3f64aa74@hyperion.delvare>
	<20090831210335.f382d7ff.sfr@canb.auug.org.au>
	<20090831131647.3f609ad4@hyperion.delvare>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__31_Aug_2009_21_59_05_+1000_fpPjmB2PgN2pdiIT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Aug_2009_21_59_05_+1000_fpPjmB2PgN2pdiIT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Mon, 31 Aug 2009 13:16:47 +0200 Jean Delvare <khali@linux-fr.org> wrote:
>
> OK, thanks for the clarification. I did not notice Greg had split some
> of his trees that way. Makes sense.
>=20
> > It you decide to leave that patch out and
> > change the dependency, please let me know as I will then have to merge
> > your tree after Greg's (it is currently earlier.
>=20
> Regardless of what I do, I think it would make sense to merge
> driver-core before driver subsystem trees. I would insert if before pci.

I merge driver-core near the end because it often has API changes in it
and Linus suggested that the pain of API changes should be with the
changer.

> I am also surprised that I would have to tell you. What is the purpose
> of the NEXT_BASE tag if you do not check for dependencies automatically?

I use the tag to choose the base when I import the quilt series into git.
So far I have not needed to automate the ordering of the imports.

> Anyway, if you say git can deal with duplicate patches OK, then I think
> I'll simply re-add the patch on my end. But I do not have a strong
> opinion on this either, so if you prefer clean dependencies and
> ordering without duplicate patches, it is just as easy for me to leave
> the redundant patch out and restore the NEXT_BASE tag.

I prefer less dependencies (so you could put the patch back in), however,
that means if Greg changes the patch, then we will have two slightly
different versions to merge.  I can cope with that as well.

Just readd the patch :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__31_Aug_2009_21_59_05_+1000_fpPjmB2PgN2pdiIT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqbuwkACgkQjjKRsyhoI8z07gCffwjDfqIS5/sUxWXYacczmbjg
eFEAnAp5PjUq9vBsQJPEQx+fKIFZq9bu
=GYIO
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Aug_2009_21_59_05_+1000_fpPjmB2PgN2pdiIT--
