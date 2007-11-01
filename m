Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbXKASUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbXKASUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXKASTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:19:55 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38602 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824AbXKASTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:19:54 -0400
X-Sasl-enc: 88/5G9fs/Cd8jgL3svudlaJzIhLqR5TAbkKoSmlcqsmU 1193941193
Message-ID: <472A18D7.7020703@imap.cc>
Date: Thu, 01 Nov 2007 19:20:07 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net, hjlipp@web.de, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH 1/2] usb_gigaset: suspend support [v2]
References: <20071029185311.4C955FC04C@xenon.ts.pxnet.com>	<20071029214131.70EABFC043@xenon.ts.pxnet.com> <20071030140124.984aba58.akpm@linux-foundation.org>
In-Reply-To: <20071030140124.984aba58.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5CE5EA2FD04DAC3BF543D4E4"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5CE5EA2FD04DAC3BF543D4E4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 30.10.2007 22:01 schrieb Andrew Morton:
> On Mon, 29 Oct 2007 22:41:30 +0100 (CET)
> Tilman Schmidt <tilman@imap.cc> wrote:
>=20
>> From: Tilman Schmidt <tilman@imap.cc>
>>
>> Add basic suspend/resume support to the usb_gigaset driver.
>> (Corrected version.)
>>
>=20
> You're not a big fan of checkpatch, I see.

Sorry. I promise to mend my ways.

>> +static int gigaset_suspend(struct usb_interface *intf, pm_message_t m=
essage)
>> +{
>> +	struct cardstate *cs;
>> +	struct usb_cardstate *ucs;
>> +
>> +	if ((cs =3D usb_get_intfdata(intf)) =3D=3D NULL ||
>> +	    (ucs =3D cs->hw.usb) =3D=3D NULL) {
>> +		err("%s: no cardstate", __func__);
>> +		return -EFAULT;
>> +	}
>=20
> Is the above reeeeeely needed?  I bet it never happens.

I'm a great believer in defensive programming. :-)

Anyway, to be sure these checks aren't needed, I would need the
assurance that the suspend and resume methods are serialized with
the probe and disconnect methods. Are they?

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig5CE5EA2FD04DAC3BF543D4E4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHKhjnMdB4Whm86/kRAteYAJ0fO9MAIm0RVN6pEr89epJCd0/5WgCePm2h
PZc/r29ua0pHr463lhh4a2I=
=CcwU
-----END PGP SIGNATURE-----

--------------enig5CE5EA2FD04DAC3BF543D4E4--
