Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbYBZIdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbYBZIdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 03:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYBZIdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 03:33:38 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:34587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYBZIdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 03:33:37 -0500
Subject: Re: iwl4965 dropping packets and __dev_addr_discard: address
	leakage! da_users=1
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Connors <tconnors@astro.swin.edu.au>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20080225223823.db13a7fe.akpm@linux-foundation.org> (sfid-20080226_063910_557503_849EE5CE)
References: <slrn-0.9.7.4-5027-27940-200802261551-tc@hexane.ssi.swin.edu.au>
	 <20080225223823.db13a7fe.akpm@linux-foundation.org>
	 (sfid-20080226_063910_557503_849EE5CE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6XvJQkheEHFwzQkxYFib"
Date: Tue, 26 Feb 2008 09:33:18 +0100
Message-Id: <1204014798.13162.209.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6XvJQkheEHFwzQkxYFib
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Possibly because of the frequent renegotiating my iwl4965 card has
> > been making, it has now decided it's not going to pass packets
> > reliably until presumably next time I reboot.

Can't say anything about that.

> > I've noticed messages in syslog that I hadn't seen when things were
> > working fine.  The problem possibly has only surfaced after rmmodding
> > the iwl4965 module, then remodding it.  It stays with me through being
> > removed and modprobed again.  It is being bonded in conjunction with a
> > physical ethernet, if that is relevant, although I think I reproduced
> > it when it was on its lonesome.

> > Feb 23 03:05:23 dirac kernel: __dev_addr_discard: address leakage! da_u=
sers=3D1

I've seen that before on other hardware but so far haven't managed to
track it down or even reliably reproduce it.

johannes

--=-6XvJQkheEHFwzQkxYFib
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8POzaVg1VMiehFYAQKhww//SEO+VtjEo+LA61LYh3MSt8w8TgUZ6kCv
Rv0yTBY98fhJ++XHyvjaUNq9fslu8eZD1TU1+oAW1ZjWnED08Twc2N5PT2Vvgcge
/WcpQbd1oxX7rbsuSyniTBOW7N7wVCyaO7YDaUr5yvlkGZM0IDJn16Lk8zUXQHnS
o+fhBUURk/X3oAHiR761WuoxLBYzux/V+GDxxD8A440azGiuxxOixwxKiDmAlqyA
/1Vw+DJZ9jOM/l39xj25APMKT+65Lg8Mn61qnUE3OBQV1Q7CsS7qnQ68lfqpnHZR
kJRrK8JvuvdQZf+q60zfsCoSPo4151bvKJmkou/B2dDdRzXTMwKDKURZYBgOSyyz
sSBL5l9WCEdCW2HQLB8Z0ewNl2UFzF1TvlrczfHrOnzbRNKqQQo5ptj95ReVN13r
En0t/5WgTc2xO49Kb0MFFsJwy59ahk5KRj8/xhXbVeZELs6x0T3hu3C4XS1x3JnD
/qir5obFZZVPEehyfG/TlJ4X8J+XUzecx9FNNN/L8ugzZwAemMO53pBBSowhVpjT
fGXMRe9/9QV5nZGr4X4Fd/fmMEz/UzZryDrrevk/ge+JOp2CJGmT4mmE16DbIWMD
AxrXwbUAxdZS75HdtGL//NhcpWVQ+3gV7X+ghiZGLROA4Zt1JlRiZHT4a0Lnbbx6
mmklZ+J/UVI=
=9nnG
-----END PGP SIGNATURE-----

--=-6XvJQkheEHFwzQkxYFib--

