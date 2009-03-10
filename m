Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZCJRTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZCJRTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZCJRTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:19:04 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:55877 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbZCJRTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:19:02 -0400
Subject: Re: [PATCH 26/31] usb: Auto-load cdc_acm module when device opened.
From: Scott James Remnant <scott@canonical.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20090310170802.GA4923@kroah.com>
References: <cover.1236702228.git.scott@canonical.com>
	 <c9944f91c6740450d11cb26c4e8e19e2cb612abe.1236702228.git.scott@canonical.com>
	 <20090310170802.GA4923@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-O4W+ofcJEDXT/a7qYonv"
Date: Tue, 10 Mar 2009 17:18:58 +0000
Message-Id: <1236705538.6339.2.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O4W+ofcJEDXT/a7qYonv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-10 at 10:08 -0700, Greg KH wrote:

> On Mon, Mar 02, 2009 at 06:46:15PM +0000, Scott James Remnant wrote:
> > The cdc_acm module is missing the char-major-166-* alias that would
> > cause it to be auto-loaded when a device of that type is opened.  This
> > patch adds the alias.
>=20
> You really have users that are using a static /dev that need this kind
> of fix?  I thought we were phasing out the char-major- aliases as they
> don't make any sense anymore.
>=20
I don't think so.

But since we had aliases to support users, I wasn't going to drop them
without at least sending a patch upstream to see if they cared about
such things.

(and there are many modules which do have the char-major aliases, so at
least someone is trying to put them in).

As noted in the cover, feel free to drop these - I can use your reply
when a user complains <g>

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-O4W+ofcJEDXT/a7qYonv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm2oQIACgkQSnQiFMl4yK4X9gCgrh2Q8N27o+7aIiV/mJmKKbjl
tOsAoIypwuK1TcWBanVUnqQ3CuhdQNCj
=3Onx
-----END PGP SIGNATURE-----

--=-O4W+ofcJEDXT/a7qYonv--

