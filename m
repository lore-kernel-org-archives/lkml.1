Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbXLMVdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbXLMVdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXLMVcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:32:50 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54179 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933336AbXLMVcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:32:47 -0500
X-Greylist: delayed 1193 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 16:32:47 EST
X-Sasl-enc: XJkKS3iFzCM+LPg+467D4gz1zYTaODT4hQHi3lDTSlKf 1197580373
Message-ID: <4761A0A9.6020901@imap.cc>
Date: Thu, 13 Dec 2007 22:14:17 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.22.1] spurious (?) message "BUG: lock held at task exit
 time"
References: <469E23F9.2080304@imap.cc>
In-Reply-To: <469E23F9.2080304@imap.cc>
X-Enigmail-Version: 0.95.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8611CA46C88ECE085A97B682"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8611CA46C88ECE085A97B682
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 18.07.2007 16:30, me myself I wrote:
> When testing the serial Gigaset driver with kernel release 2.6.22.1
> I get a kernel BUG message:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ BUG: lock held at task exit time! ]
> -------------------------------------
> gigasetm101d/5970 is exiting with locks still held!
> 1 lock held by gigasetm101d/5970:
>  #0:  (&cs->hw.ser->dead_mutex){--..}, at: [<c02d8bc7>] mutex_lock+0x1c=
/0x1f
[...]
> Who is at fault here?

Ok, I accidentally solved this myself now, so please don't bother answeri=
ng.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig8611CA46C88ECE085A97B682
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHYaCxMdB4Whm86/kRAsu6AJ479AQrJijpFj09xOuu41aOw5c4bQCeKps9
Z+5I+VT6+jJi+3MmUFCxCoE=
=bpKK
-----END PGP SIGNATURE-----

--------------enig8611CA46C88ECE085A97B682--
