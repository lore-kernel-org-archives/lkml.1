Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbZF1RxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbZF1RxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZF1RxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:53:05 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:64635 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZF1RxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=gg9TkQ1ofK5UL4XjFrhdpu+eG/fHqvD4X1NocQHDA3xr6uvK64MKMzsdr8aEX1aN/C
         iPjmCrJ8KW3VZAhN2HR0lysLIFT4nQfGfGc/lpmYAUtp/e2P7SVKH/UNTYdmF1DrqN/l
         saoi5FSUmXLpCU8K934NVzAhUiRI0fYoStG+I=
Subject: Re: [PATCH] PCAP misc input driver (for 2.6.32)
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       inux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Ilya Petrov <ilya.muromec@gmail.com>
In-Reply-To: <5d5443650906280019m1e7d9343qd44875716b540e4b@mail.gmail.com>
References: <1246122592.3727.20.camel@brutus>
	 <5d5443650906280019m1e7d9343qd44875716b540e4b@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3m9lNdsoaTIHCXtaZ16l"
Date: Sun, 28 Jun 2009 14:52:57 -0300
Message-Id: <1246211577.20525.14.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3m9lNdsoaTIHCXtaZ16l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em Dom, 2009-06-28 =C3=A0s 12:49 +0530, Trilok Soni escreveu:
> > +       pcap_keys->input->evbit[0] =3D BIT_MASK(EV_KEY) | BIT_MASK(EV_S=
W);
> > +       set_bit(KEY_POWER, pcap_keys->input->keybit);
> > +       set_bit(SW_HEADPHONE_INSERT, pcap_keys->input->swbit);
> > +       set_bit(KEY_HP, pcap_keys->input->keybit);
>=20
> __set_bit please.

Ok.

> > +
> > +       err =3D request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF=
),
> > +                       pcap_keys_handler, 0, "Power key", pcap_keys);
> > +       if (err)
> > +               goto fail_dev;
> > +
> > +       err =3D request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_HS),
> > +                       pcap_keys_handler, 0, "Headphone jack", pcap_ke=
ys);
> > +       if (err)
> > +               goto fail_pwrkey;
> > +
> > +       err =3D request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC),
> > +                       pcap_keys_handler, 0, "MIC jack/button", pcap_k=
eys);
> > +       if (err)
> > +               goto fail_jack;
> > +
> > +       err =3D input_register_device(pcap_keys->input);
> > +       if (err)
> > +               goto fail_mic;
>=20
> Same comment as given in PCAP touchscreen driver.

Ok.

> > +static struct platform_driver pcap_keys_device_driver =3D {
> > +       .probe          =3D pcap_keys_probe,
> > +       .remove         =3D pcap_keys_remove,
>=20
> __devexit_p ?

Ok.

Thanks for the review, I will send new versions addressing your comments
as soon as possible.

--=20
Daniel Ribeiro

--=-3m9lNdsoaTIHCXtaZ16l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpHrfkACgkQw3OYl0G0liQ2FwCgl0DvjPcP3tGZLVVuomyjODdG
1TAAnRAsUqEExIJJFh49dUK3f3cm5Umy
=ZXt+
-----END PGP SIGNATURE-----

--=-3m9lNdsoaTIHCXtaZ16l--

