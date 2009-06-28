Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbZF1Rtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbZF1Rtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZF1Rtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:49:32 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:39457 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbZF1Rtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=OuWwXa8RYmQldyUGb1lAQia3NokER0X3aDRNiW7rTKCPP3uEw+Tc86Znd+5EuN8trL
         eVPfAHACTuLpNKdmt0rddqW7mO/caurCTwlJqowhMcRmtU3i5s3sfzui5Ps1MKbooAuv
         bYu9dlmVm7cEbfg6MP64Oaj5sTpH3tcNoPN8w=
Subject: Re: [PATCH] PCAP touchscreen driver (for 2.6.32)
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Harald Welte <laforge@gnumonks.org>,
       Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <5d5443650906280015x4bddefa5v9dd36f888c5f2e92@mail.gmail.com>
References: <1246122138.3727.12.camel@brutus>
	 <5d5443650906280015x4bddefa5v9dd36f888c5f2e92@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SfBT2tL/ttvBt/0d8BXN"
Date: Sun, 28 Jun 2009 14:49:26 -0300
Message-Id: <1246211366.20525.12.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SfBT2tL/ttvBt/0d8BXN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em Dom, 2009-06-28 =C3=A0s 12:45 +0530, Trilok Soni escreveu:
> 2009/6/27 Daniel Ribeiro <drwyrm@gmail.com>:
> > Touchscreen driver for PCAP2 PMIC.

> Some more description in commit text really helps.

Well, there isn't much to say. :) Its a touchscreen driver for a
proprietary PMIC on Motorola phones.

> > +       err =3D request_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS),
> > +                       pcap_ts_event_touch, 0, "Touch Screen", pcap_ts=
);
> > +       if (err)
> > +               goto fail;
> > +
> > +       err =3D input_register_device(pcap_ts->input);
> > +       if (err)
> > +               goto fail_touch;
>=20
> Please move request_irq after input_register_device, as IRQ can get
> fired before input device gets available, right?

Yes, you are right, I will move it.

> Overall driver is nice and clean.

Thanks for the review! :)

--=20
Daniel Ribeiro

--=-SfBT2tL/ttvBt/0d8BXN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpHrSYACgkQw3OYl0G0liQi3ACfSDVv3efu5DlhtZwtw8n3DVrA
RNAAn068eXjwG/EmiDBpnv7O8b3ls/vs
=c6Ut
-----END PGP SIGNATURE-----

--=-SfBT2tL/ttvBt/0d8BXN--

