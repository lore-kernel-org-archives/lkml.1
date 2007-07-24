Return-Path: <linux-kernel-owner+w=401wt.eu-S934841AbXGXIwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934841AbXGXIwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934702AbXGXIv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:51:56 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:1170 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763209AbXGXIvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:51:54 -0400
Message-ID: <46A5BD97.10601@imap.cc>
Date: Tue, 24 Jul 2007 10:51:35 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: LKML <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       nix.or.die@googlemail.com
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc> <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc> <46A5444D.4080304@goop.org>
In-Reply-To: <46A5444D.4080304@goop.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig97A0DCD1E7F067FE38BC0653"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig97A0DCD1E7F067FE38BC0653
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Jeremy Fitzhardinge schrieb:
> Well, it looks to me like it all falls over once it hits usermode;
> everything up till then is identical (except for the Xen-related
> initcalls which naturally don't exist in the non-Xen case).

Just a wild thought: could the actual problem be with accessing the
initrd? After all, everything that's failing is based on modules
which are stuffed there. But I know far too less about initrd to
pursue this thought further.

> I'm at a loss.  I don't know if there's some way to debug the initrd in=

> more detail.  I suspect that its failing all PCI probing, rather being =
a
> specific SCSI/AHCI problem (since none of the other messages appear eit=
her).
>=20
> Does the Xen case just hang, or reboot, or what?  The kernel messages
> just appear to stop.  I'd expect it to at least complain about not
> mounting the root filesystem or something.

Yes, of course. Sorry, I thought I'd mentioned that. It shows the
standard behaviour of a Suse that cannot mount its root filesystem:
first a message: "waiting for /dev/system/root to appear" followed
by a series of dots, and then fallback into a standalone /bin/sh.

> Andi, any thoughts about how to debug the suse boot sequence?
>=20
>     J

<listening eagerly>

T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig97A0DCD1E7F067FE38BC0653
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGpb2XMdB4Whm86/kRAiCTAJ4gYaeRDnjOAn5jDSVmWoT41IsV4gCffFgy
UZFlnMfA2UceR3MSjoSynQU=
=gCZv
-----END PGP SIGNATURE-----

--------------enig97A0DCD1E7F067FE38BC0653--
