Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYGTLN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYGTLN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 07:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYGTLNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 07:13:19 -0400
Received: from server.drzeus.cx ([85.8.24.28]:36770 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755863AbYGTLNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 07:13:18 -0400
Date: Sun, 20 Jul 2008 13:13:10 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: ian <spyro@f2s.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/3] at91_mci: Enable MMC_CAP_SDIO_IRQ only when it
 actually works
Message-ID: <20080720131310.74d83d54@mjolnir.drzeus.cx>
In-Reply-To: <1216547739.3200.5.camel@wirenth>
References: <487F120F.2050305@atmel.com>
	<20080717125544.36f41947@mjolnir.drzeus.cx>
	<48809B00.1070405@atmel.com>
	<20080719010143.142d59a0@mjolnir.drzeus.cx>
	<1216547739.3200.5.camel@wirenth>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-23563-1216552396-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-23563-1216552396-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 20 Jul 2008 10:55:39 +0100
ian <spyro@f2s.com> wrote:

> On Sat, 2008-07-19 at 01:01 +0200, Pierre Ossman wrote:
> > > In your opinion, a printed warning that says to be sure to use only=20
> > > 4-bit mode SDIO cards on slot B... is not acceptable ?
> >=20
> > It's not really up to the user. The SDIO spec does not mandate 4-bit
> > support, so some cards will not have it.
>=20
> That seems overly rigid.
>=20
> its not linux violating the spec, its the SDIO controller in this case.
>=20
> I see no harm in supporting what the hardware is actually capable of.
>=20
> It wouldnt be the first bit of broken hardware supported by linux.
>=20

It does tend to make a mess of things when you start adding up all the
gotchas of each and every broken controller out there (it seems like
every controller decides to violate the spec in their own creative
way).

What about David's idea? Reconfiguring the PIN to be a GPIO pin with an
interrupt shouldn't be that difficult?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-23563-1216552396-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiDHcoACgkQ7b8eESbyJLid7wCg+Ia9YZSshVm9vRWdfs6JFIeP
CxgAoIxJ7BoFiutFWrn5Ahn9uJbtERgS
=KNwY
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-23563-1216552396-0001-2--
