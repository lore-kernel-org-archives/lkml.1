Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbYENXnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbYENXnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 19:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbYENXnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 19:43:08 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:37030 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755394AbYENXnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 19:43:07 -0400
Subject: Re: troubleshooting/debugging hard locks
From: Zan Lynx <zlynx@acm.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Lee Howard <faxguy@howardsilvan.com>, linux-kernel@vger.kernel.org
In-Reply-To: <2c0942db0805141543n20e6eb6eq5fe13fe1cb50d67e@mail.gmail.com>
References: <482B3D21.5020903@howardsilvan.com>
	 <2c0942db0805141543n20e6eb6eq5fe13fe1cb50d67e@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iW1iRdo2pcqYp8Y3LzXe"
Date: Wed, 14 May 2008 17:42:58 -0600
Message-Id: <1210808578.3784.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080514/1JwQcd-00048S-VR-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iW1iRdo2pcqYp8Y3LzXe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-05-14 at 15:43 -0700, Ray Lee wrote:
> On Wed, May 14, 2008 at 12:27 PM, Lee Howard <faxguy@howardsilvan.com> wr=
ote:

> >  But, without kernel messages indicating where to look to debug... what=
 is
> > the best approach to start troubleshooting and debugging this condition=
?  Is
> > there some general debug feature that can be enabled in the kernel that
> > would help hone in on the culprit?
>=20
> There's something called the NMI watchdog, that will print debugging
> messages out if it finds the system has hard locked. The short version
> is that you should add "nmi_watchdog=3D1" (no quotes) to the line in
> GRUB that has the kernel options. That assumes you have an APIC on the
> system. If that's not the case (you're on Uniprocessor, and no APIC)
> then you can try nmi_watchdog=3D2 instead. That'll only work on some
> systems, though.
>=20
> Better docs (than my cheesy writeup) are in
> Documentation/nmi_watchdog.txt in the kernel source distribution.

I was once told to add these to the kernel command line as well when
using NMI watchdog and they do seem to help it trigger more reliably:=20

"idle=3Dpoll nohz=3Doff"

--=20
Zan Lynx <zlynx@acm.org>

--=-iW1iRdo2pcqYp8Y3LzXe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkgreQIACgkQolqWs/Y4NLx/OQCeNJBtCwzzMB8ZummC7fxXYkug
UqkAnjgqjenFEJoEDRAXUlXeX1ZBW/Ua
=tb5t
-----END PGP SIGNATURE-----

--=-iW1iRdo2pcqYp8Y3LzXe--

