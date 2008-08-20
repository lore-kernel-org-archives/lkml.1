Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYHTTlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYHTTlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbYHTTlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:41:09 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:12096 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbYHTTlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:41:06 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jayakumar.lkml@gmail.com, npiggin@suse.de,
       a.p.zijlstra@chello.nl, hugh@veritas.com, hannes@saeurebad.de,
       jeremy@goop.org, kel@otaku42.de, armbru@redhat.com
In-Reply-To: <20080820123056.8f0c9d3f.akpm@linux-foundation.org>
References: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>
	 <20080818233824.5d219105.akpm@linux-foundation.org>
	 <1219220003.3996.29.camel@localhost.localdomain>
	 <20080820013736.ec64baae.akpm@linux-foundation.org>
	 <1219258673.3996.46.camel@localhost.localdomain>
	 <20080820123056.8f0c9d3f.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F8KKW1rjWiG071Y8WgGV"
Date: Wed, 20 Aug 2008 20:40:54 +0100
Message-Id: <1219261254.3996.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F8KKW1rjWiG071Y8WgGV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-08-20 at 12:30 -0700, Andrew Morton wrote:
> On Wed, 20 Aug 2008 19:57:53 +0100 Ian Campbell <ijc@hellion.org.uk>
> wrote:
>  	}
> > +#ifdef CONFIG_FB_DEFERRED_IO
> > +	if (info->fbdefio)
> > +		fb_deferred_io_open(info, inode, file);
> > +#endif
>=20
> eww, hacky, but drivers/video/fbmem.c already got hacky:
>=20
> #ifdef CONFIG_FB_DEFERRED_IO
>         .fsync =3D        fb_deferred_io_fsync,
> #endif
>=20
> so it's not an original sin.

That's what I figured.

> Does it work?

Yep.

Ian.
--=20
Ian Campbell

Nobody knows what goes between his cold toes and his warm ears.
		-- Roy Harper

--=-F8KKW1rjWiG071Y8WgGV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkisc0YACgkQM0+0qS9rzVl13QCfYVR1yXFoQjHOPfvaUmJRn9RV
ev8AoNyZhImYmVIINbZ8uFw226/8+5hC
=v/nI
-----END PGP SIGNATURE-----

--=-F8KKW1rjWiG071Y8WgGV--

