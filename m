Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbZHLGTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbZHLGTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 02:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZHLGTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 02:19:42 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36098 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZHLGTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 02:19:41 -0400
Date: Wed, 12 Aug 2009 08:19:34 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Avi Kivity <avi@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Page allocation failures in guest
Message-ID: <20090812081934.33e8280f@mjolnir.ossman.eu>
In-Reply-To: <200908121249.51973.rusty@rustcorp.com.au>
References: <20090713115158.0a4892b0@mjolnir.ossman.eu>
	<20090811083233.3b2be444@mjolnir.ossman.eu>
	<4A811545.5090209@redhat.com>
	<200908121249.51973.rusty@rustcorp.com.au>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-3535-1250057980-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-3535-1250057980-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Aug 2009 12:49:51 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

>=20
> It's kind of the nature of networking devices :(
>=20
> I'd say your host now offers GSO features, so the guest allocates big
> packets.
>=20
> > > I doesn't get out of it though, or at least the virtio net driver
> > > wedges itself.
>=20
> There's a fixme to retry when this happens, but this is the first report
> I've received.  I'll check it out.
>=20

Will it still trigger the OOM killer with this patch, or will things
behave slightly more gracefully?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-3535-1250057980-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqCXvsACgkQ7b8eESbyJLj8dwCgyJNVA/HvKHZRcWTNV2HHSoHc
obUAoPCiGgEIC8eYz09sJwwz0c741bns
=xvSg
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-3535-1250057980-0001-2--
