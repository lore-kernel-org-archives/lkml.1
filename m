Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab0CMUiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 15:38:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46028 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759248Ab0CMUiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 15:38:04 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20100313002717.508317046@kvm.kroah.org>
References: <20100313002717.508317046@kvm.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/j4ySxuezJ1MhIVBbm9d"
Date: Sat, 13 Mar 2010 20:37:57 +0000
Message-ID: <1268512677.2664.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [141/145] KVM: x86 emulator: Check CPL level
 during privilege instruction emulation
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/j4ySxuezJ1MhIVBbm9d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-03-12 at 16:27 -0800, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let me =
know.
>=20
> ----------------
> From: Gleb Natapov <gleb@redhat.com>
>=20
> commit e92805ac1228626c59c865f2f4e9059b9fb8c97b upstream.
>=20
> Add CPL checking in case emulator is tricked into emulating
> privilege instruction from userspace.

There were more security fixes released along with this, which surely
belong in a stable update:

1871c6020d7308afb99127bba51f04548e7ca84e KVM: x86 emulator: fix memory acce=
ss during x86 emulation
f850e2e603bf5a05b0aee7901857cf85715aa694 KVM: x86 emulator: Check IOPL leve=
l during io instruction emulation
d4c6a1549c056f1d817e8f6f2f97d8b44933472f KVM: x86 emulator: Fix popf emulat=
ion

Ben.

--=20
Ben Hutchings
It's easier to fight for one's principles than to live up to them.

--=-/j4ySxuezJ1MhIVBbm9d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS5v3oOe/yOyVhhEJAQKvDxAAvAcSgFntgcrwY01L1zWwUeMdaZgW410S
aTKSkaGlheidHvdwwGWfI0mDoQGthisbboH1aBZ7qzITpTzqeQzZq+PDIHOY5Dqd
VDr7HpbXQmtosOhIhz+e8qF1r57pWdKzlvqLSMYmeE7EQwfHV1HXOXdrIVg/6ioc
ZPr8vsI72AkC2hjPv0JfCbuVwZMV2M5RPx8CsZx9+u+F4Iw5kUo3ZxUyqZIUEj5q
uoA5ZJtMS4QhrgF5Hd3aQ4u66vHeGZel3Aw+f/pi5CjtVUNE8Ay8R4/omRxxhxjp
LwKqnsl/PTFjCqHvvJfGFPOptrnMppSrLxBTVjlpYNiQAsfaR+dg9iJOs9kp5qJ+
TgnarYRBLdpp4acRI/hpcPpSahqWyhE39t1FWyHQd9Kec0r2O61/258jB4fO749t
M3+Rb/dnUfeSuzbMCEw+suAQ32XWcXA6EaSHvBwnOxufZuHRQbhu3lVuyEwl7jzR
1BoaL0yvsm+k3ntdi2dQC8hiAebFmNfwgXoKXl8JQlHgMvVNBrH0P3d89Ioc4PTf
TkvGFCKfjLzQt4a+yS6Tts+LAVWNSFYJOfBAwpLMf2BFGs2uaeYCMo50SFx6E25Q
S5DdOWA6uq+dzIRFwC8atgurM0rAX+t34yU8sMZCGOxnweMPbLsSa28LahLqA3G1
nH2v3I1GBr0=
=9wss
-----END PGP SIGNATURE-----

--=-/j4ySxuezJ1MhIVBbm9d--
