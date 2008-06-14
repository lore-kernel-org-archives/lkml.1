Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbYFNQ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbYFNQ3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 12:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYFNQ3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 12:29:12 -0400
Received: from server.drzeus.cx ([85.8.24.28]:52733 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752659AbYFNQ3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 12:29:11 -0400
Date: Sat, 14 Jun 2008 18:28:31 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Marc Pignat <marc.pignat@hevs.ch>, Eric BENARD <ebenard@free.fr>,
       Andrew Victor <linux@maxim.org.za>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Anti Sullin <anti.sullin@artecdesign.ee>,
       =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>,
       Ville =?UTF-8?B?U3lyasOkbMOk?= <syrjala@sci.fi>
Subject: Re: [PATCH 0/7] mmc: at91_mci: rework to allow better transfer
Message-ID: <20080614182831.0360bd77@mjolnir.drzeus.cx>
In-Reply-To: <484E4F61.7010007@atmel.com>
References: <483FE9E7.7020707@atmel.com>
	<20080609124623.5b6bda48@mjolnir.drzeus.cx>
	<484E4F61.7010007@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.2; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-10677-1213460525-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-10677-1213460525-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jun 2008 11:54:41 +0200
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

>=20
> Russell King highlights that patch #4 is not well inserted in the series=
=20
> : it have to be after #5 (after correcting bytes_xfered update).
>=20
> If you want I can reorder them... or you manage to do it.
>=20
> I will take into account Marc's comment and new Ville patch series in=20
> another round ;-)

Will you redo this series, or are you planning further patches? (i.e.
should I merge this set or wait for an update?)

--=_freyr.drzeus.cx-10677-1213460525-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhT8bQACgkQ7b8eESbyJLgwbACgr1DRfwjcu2BvbcvVaGcLnP0k
xC8An3yWU2OI4foeu9x+1RZgFK3pR8MW
=48xl
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-10677-1213460525-0001-2--
