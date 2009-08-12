Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZHLIWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZHLIWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZHLIWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:22:38 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:47098 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbZHLIWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:22:37 -0400
Date: Wed, 12 Aug 2009 10:22:25 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Avi Kivity <avi@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Minchan Kim <minchan.kim@gmail.com>,
       kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Page allocation failures in guest
Message-ID: <20090812102225.5a2e2305@mjolnir.ossman.eu>
In-Reply-To: <4A8272B2.3030309@redhat.com>
References: <20090713115158.0a4892b0@mjolnir.ossman.eu>
	<20090811083233.3b2be444@mjolnir.ossman.eu>
	<4A811545.5090209@redhat.com>
	<200908121249.51973.rusty@rustcorp.com.au>
	<20090812081934.33e8280f@mjolnir.ossman.eu>
	<4A8272B2.3030309@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-5206-1250065356-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-5206-1250065356-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Aug 2009 10:43:46 +0300
Avi Kivity <avi@redhat.com> wrote:

> On 08/12/2009 09:19 AM, Pierre Ossman wrote:
> > Will it still trigger the OOM killer with this patch, or will things
> > behave slightly more gracefully?
> >   =20
>=20
> I don't think you mentioned the OOM killer in your original report?  Did=
=20
> it trigger?
>=20

I might have things backwards here, but I though the OOM killer started
doing its dirty business once you got that memory allocation failure
dump.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-5206-1250065356-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqCe8YACgkQ7b8eESbyJLj9hgCg86rzitLuQSw9vdaqxVRvfPkh
1dkAnAjP+OomDPfKMCevlAMJyAgmiZ/x
=uk06
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-5206-1250065356-0001-2--
