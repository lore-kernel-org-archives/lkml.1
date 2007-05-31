Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbXEaWCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbXEaWCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbXEaWCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:02:44 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49443 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbXEaWCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:02:44 -0400
X-Sasl-enc: PQvrfsi5hhFSY9YbFgC0EQJ8Y0nm8dwejVbT5UgrXYef 1180648962
Message-ID: <465F46CC.30008@imap.cc>
Date: Fri, 01 Jun 2007 00:06:04 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Andrew Morton <akpm@linux-foundation.org>, kkeil@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/06] Use menuconfig objects 4 - ISDN part 2/6 (CONFIG_ISDN_I4L)
References: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net> <Pine.LNX.4.61.0705302137560.11140@yvahk01.tjqt.qr> <465EF4F4.1090507@imap.cc> <Pine.LNX.4.61.0705312152580.11140@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705312152580.11140@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBA36FB3171BDA6B49E56BA19"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBA36FB3171BDA6B49E56BA19
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 31.05.2007 21:53 schrieb Jan Engelhardt:
> On May 31 2007 18:16, Tilman Schmidt wrote:
[...]
>> This results in a rather strange and inconsistent presentation in
>> "make xconfig", with ISDN4Linux appearing as a subtree in the left
>> pane but CAPI only visible in the right pane after selecting ISDN.
>=20
> That's a gconfig/xconfig b^H missing feature.

Send patch. :-)

Anyway, treating ISDN4Linux and CAPI that differently is certainly
not appropriate, regardless of any xconfig bug, feature or other.

>> IMHO it looks much saner like this:
>=20
> But then you'd still have to descend into ISDN4Linux to deactivate it.

I don't know what you mean. The only menus I have to enter first
in order to deactivate them are the ones you left alone:
"Passive cards" (ISDN_DRV_HISAX), "Active cards" (no top-level
option), "Active AVM cards" (CAPI_AVM) and "Active Eicon DIVA
Server cards" (CAPI_EICON). There's no problem deactivating
ISDN_I4L or ISDN_CAPI (or both, should the fancy take me)
directly in the ISDN menu, neither in "make xconfig" nor in
"make menuconfig".

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigBA36FB3171BDA6B49E56BA19
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGX0bWMdB4Whm86/kRAiKKAJ4pcmdF+EjA28AzhrD+YMZCGK39xACfZdqI
p5V5xZYrqzTpzLVDlkn1CHM=
=pygI
-----END PGP SIGNATURE-----

--------------enigBA36FB3171BDA6B49E56BA19--
