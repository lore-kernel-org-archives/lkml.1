Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbZHZEzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbZHZEzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 00:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbZHZEzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 00:55:10 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:46380 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbZHZEzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 00:55:09 -0400
Date: Wed, 26 Aug 2009 06:55:01 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Avi Kivity <avi@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, netdev@vger.kernel.org
Subject: Re: Page allocation failures in guest
Message-ID: <20090826065501.7ab677b9@mjolnir.ossman.eu>
In-Reply-To: <200908261147.17838.rusty@rustcorp.com.au>
References: <20090713115158.0a4892b0@mjolnir.ossman.eu>
	<200908121501.53167.rusty@rustcorp.com.au>
	<20090813222548.5e0743dd@mjolnir.ossman.eu>
	<200908261147.17838.rusty@rustcorp.com.au>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-655-1251262508-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-655-1251262508-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Aug 2009 11:47:17 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Fri, 14 Aug 2009 05:55:48 am Pierre Ossman wrote:
> > On Wed, 12 Aug 2009 15:01:52 +0930
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > Subject: virtio: net refill on out-of-memory
> ...=20
> > Patch applied. Now we wait. :)
>=20
> Any results?
>=20

It's been up for 12 days, so I'd say it works. But there is nothing in
dmesg, which suggests I haven't triggered the condition yet.

I wonder if there might be something broken with Fedora's kernel. :/
(I am running the same upstream version, and their conf, for this test,
but not all of their patches)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-655-1251262508-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqUwCkACgkQ7b8eESbyJLhvfgCeJdWl6lSQa8Zi7CGsSLbjyr4x
1+EAnjLeYeg7bXuVqJ3AACXj23IMc+uk
=tuHm
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-655-1251262508-0001-2--
