Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbZAOJO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbZAOJO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZAOJOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:14:40 -0500
Received: from mail.klingt.org ([86.59.21.178]:45921 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbZAOJOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:14:37 -0500
Subject: Re: 2.6.28-rc9: oprofile regression
From: Tim Blechmann <tim@klingt.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       venkatesh.pallipadi@intel.com
In-Reply-To: <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain>
References: <1229869416.6911.1.camel@thinkpad>
	 <1229894585.6898.6.camel@thinkpad>  <49544497.9020900@linux.intel.com>
	 <1230894257.6072.10.camel@thinkpad>
	 <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain>
	 <1231957184.13033.70.camel@thinkpad>
	 <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-N+fIvzBSS8TwDaBymhf7"
Date: Thu, 15 Jan 2009 10:14:13 +0100
Message-Id: <1232010853.6541.4.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Thu, 15 Jan 2009 10:14:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-N+fIvzBSS8TwDaBymhf7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 09:46 +0100, Thomas Gleixner wrote:
> Tim,
>=20
> On Wed, 14 Jan 2009, Tim Blechmann wrote:
> > this code (line 81/82), changes counter_width from 32 to 40.
> >=20
> > if (counter_width < eax.split.bit_width)
> >         counter_width =3D eax.split.bit_width;
> >=20
> > however when removing these lines, and thus keeping the value 32 for
> > counter_width, doesn't change the behavior, only one NMI per cpu.
>=20
> It would only help, when the reported bit_width would be bogus. We
> know that you get at least one NMI, so lets look at the results we get
> there.

it seems, that ppro_check_ctrs is never called:
[  982.238639] oprofile: using NMI interrupt.

hth, tim

--
tim@klingt.org
http://tim.klingt.org

Nothing exists until or unless it is observed. An artist is making
something exist by observing it. And his hope for other people is that
they will also make it exist by observing it. I call it 'creative
observation.' Creative viewing.
  William S. Burroughs

--=-N+fIvzBSS8TwDaBymhf7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklu/mAACgkQdL+4qsZfVstsVgCghUmmQPdQcaLohpKrTravPa1n
r1wAn0WI4pPaoPQusRuDgCt/MTUcWKPp
=Y8TE
-----END PGP SIGNATURE-----

--=-N+fIvzBSS8TwDaBymhf7--

