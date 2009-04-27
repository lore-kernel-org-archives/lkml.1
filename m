Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbZD0Ntu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbZD0Ntu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 09:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZD0Ntl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 09:49:41 -0400
Received: from intcomgrp.com ([216.54.13.120]:46104 "EHLO beta.intcomgrp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbZD0Ntk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 09:49:40 -0400
Message-ID: <49F5B774.5010501@beta.intcomgrp.com>
Date: Mon, 27 Apr 2009 09:47:32 -0400
From: James Kosin <jkosin@beta.intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Pavel Machek <pavel@ucw.cz>, Mike Rapoport <mike@compulab.co.il>,
       linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [RFD] voltage/current regulator consumer interface
References: <ct38K-3Fq-11@gated-at.bofh.it> <49EC9709.8070002@support.intcomgrp.com> <49ED628A.4000505@compulab.co.il> <49EDC935.7080308@beta.intcomgrp.com> <49EDD2A7.9090300@compulab.co.il> <20090425081933.GE2428@ucw.cz> <20090425090448.GA4210@sirena.org.uk>
In-Reply-To: <20090425090448.GA4210@sirena.org.uk>
X-Enigmail-Version: 0.95.7
OpenPGP: id=7BB59129
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE3DA2232FBA0E1049BC3B60A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE3DA2232FBA0E1049BC3B60A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Mark Brown wrote:
> On Sat, Apr 25, 2009 at 10:19:33AM +0200, Pavel Machek wrote:
>=20
>> Well, then you should teach serial driver to power the (GPS) device up=
 on
>> open() and power it off on close()...
>=20
> This all started because this approach was nacked for serial drivers.
> In any case, I'm not sure that'll scale - it may not be desirable or
> reasonable to do something like that for all devices.  For example, the=

> devices may be connected via a technology that's not suitable (I've
> worked on systems which used ethernet here).
>=20
Ethernet can be treated as a serial interface as well down to the
simplest level.  I'm leaving out a lot is making this assumption; but,
it is true to a fault.

Scalability has more to do with the generic interface you use... If you
tie things to ttySxx and don't allow configuration parameters you are
also restricting the usage and scalability as well.

The GPS should be configurable so the interface is generic and allows
getting from Ethernet/PCI/IDE/serial/parallel/etc.  The transport layer
should not matter to the GPS driver.  The trick will be to allow the
user to ultimately choose, if that is what you want.

The same applies to disk devices, now we have IDE/SATA/etc. the disk
device itself doesn't depend on the interface physically, the kernel
treats all these as suitable interfaces for disk/CDROM/tape devices and
the world is not turned on its ear just because there is a different
physical interface.

James


--------------enigE3DA2232FBA0E1049BC3B60A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn1t30ACgkQkNLDmnu1kSmhFQCfchPq8bFRmBRlclfLPMU4IgV6
l0YAni/zaHki0l4l3AUpxpk0dlHLvX5k
=SpOh
-----END PGP SIGNATURE-----

--------------enigE3DA2232FBA0E1049BC3B60A--
