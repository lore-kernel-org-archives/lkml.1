Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYJTMjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYJTMjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYJTMjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:39:31 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYJTMja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:39:30 -0400
Subject: Re: iwl3945 broken in current git
From: Johannes Berg <johannes@sipsolutions.net>
To: Dieter Ries <clip2@gmx.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <48FC7B1A.10307@gmx.de> (sfid-20081020_143609_718157_68144039)
References: <48FC6C05.6020901@gmx.de>
	 <20081020121710.GA3607@isilmar.linta.de>
	 (sfid-20081020_141718_690091_E56EF8AB) <1224506010.27899.23.camel@johannes.berg>
	 <48FC7B1A.10307@gmx.de> (sfid-20081020_143609_718157_68144039)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nj5obBVel5qcw7mIH0Nn"
Date: Mon, 20 Oct 2008 14:39:26 +0200
Message-Id: <1224506366.27899.25.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nj5obBVel5qcw7mIH0Nn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 14:35 +0200, Dieter Ries wrote:
> Johannes Berg schrieb:
> > On Mon, 2008-10-20 at 14:17 +0200, Dominik Brodowski wrote:
> >=20
> >>> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> >>> iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq
> >>> 0x4416 ser 0x0000004B
> >>> iwl3945: Can't stop Rx DMA.
> >> It needs a more recent uCode -- the driver really should scream out lo=
udly
> >> that the old firmware no longer suffices.
> >=20
> > You could try reverting ef224ca2ce55e81acc6c3a74c3e8c00a00941c70, that'=
s
> > the only commit I can find that seems to be vaguely related to the
> > problem as Tomas described it. Not that it might not be hidden in some
> > other commit...
>=20
> The new firmware did it. It works now, but it should really scream out
> loud ...

Do you still have the old one? Would you try anyway?

johannes

--=-nj5obBVel5qcw7mIH0Nn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/Hv3AAoJEKVg1VMiehFYL/oP/3YlM8QuhkbJhQWaHkx114py
fxPmhteHU17A40vpgrZ3BQnqp1NM5Upf7Zx4ILDtkrz65vIOIWvyg3zGpL9QI4Ih
M3SJxLGAv/1HrzLAtD7E/X4rkgNTXg3W9RD/OcMIfRWxSZgpfkV9RTWRIyy3RmEQ
eJuzJDNcJY7NZTdU6IfKGovQJ509cUlQS0UaMzzQimqxWfn84Hmh0LQHLxnNUviW
qCE3RbkSCNkZcKhtegzCaQa2N9JuOWN/R4mCIDLMj8+746HkRwNDXS5Rl68azcfN
4dyRe4fTNUG80w5+g1y+zeAaZuNnYPk4GzATcUvAJta5wGvnuoMfZRo0w93SBcZv
yC5xCYz9N7U1EmXqT149XdMN0cht0ZwxUNbx/9QvBhd4ZGj1BRl+cybYVPCYMKuc
h2U5sUyNL2GPzrf7OcmhD7sZITCljMqYdjhjVSRKZ0O74tHjOe1z4FjINFhxl1Zu
QDTdEB1qh94u2UwTSnBgc5rBFqY7YaQr/RtVpPKxIzJjFMCovK3lbAz6dOpJv3R2
T0kUkABv7aRreL0pds3HHRbrhjTITBlIIA35BfZZK4MB3rM28Hbs7Dt+AjmJfHu6
U4hR+OuzOW/PC5OaZsBRKYOZ0QBRmH/wb4Au4REwzW/UxmLITQ737O7FJcoE8JeU
kgVcPRjq6q9WcS6Jmzkq
=2Tha
-----END PGP SIGNATURE-----

--=-nj5obBVel5qcw7mIH0Nn--

