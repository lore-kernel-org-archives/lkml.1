Return-Path: <linux-kernel-owner+w=401wt.eu-S934677AbXHYXgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677AbXHYXgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 19:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbXHYXgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 19:36:45 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55957 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428AbXHYXgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 19:36:43 -0400
X-Sasl-enc: 55OCXdWJTE6S2BAXD7or3K2YXXSPuT6mqfli3LglEqAg 1188085002
Message-ID: <46D0BD22.2020200@imap.cc>
Date: Sun, 26 Aug 2007 01:37:06 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>, Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, rol@witbe.net
Subject: Re: 2.6.23-rc3-mm1
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	<46CF695D.1020008@imap.cc>	<20070824170702.a2c51084.akpm@linux-foundation.org>	<46CF7C3F.10707@imap.cc>	<20070824203000.1d710cee.akpm@linux-foundation.org>	<20070825042809.GA15863@redhat.com> <20070825095513.699423f3@tux.DEF.witbe.net>
In-Reply-To: <20070825095513.699423f3@tux.DEF.witbe.net>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD496A5677F8B2027EA8C9C76"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD496A5677F8B2027EA8C9C76
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 25.08.2007 09:55 schrieb Paul Rolland:

> On Sat, 25 Aug 2007 00:28:09 -0400
> Dave Jones <davej@redhat.com> wrote:
>=20
>> On Fri, Aug 24, 2007 at 08:30:00PM -0700, Andrew Morton wrote:
>> =20
>>  > > -<6>rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
>>  > > -<4>rtc_cmos: probe of 00:03 failed with error -16
>>  >=20
>>  > I wonder if that was supposed to happen.  It's also happening in
>>  > 2.6.23-rc3 base.
>> =20
>> EBUSY. I've seen this happen when you have both CONFIG_RTC and
>> CONFIG_RTC_DRV_CMOS set.
>=20
> This one is becoming quite worth an entry in a FAQ, it pops up one ever=
y
> month ;)
> There was a discussion about preventing both being set at the same time=

> when configuring, but I don't remember how it ends...=20

I must have missed that discussion. I have:
CONFIG_RTC=3Dy
CONFIG_RTC_DRV_CMOS=3Dm
because both of these options claim in their help texts that you
should select them if you want to access the PC RTC.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigD496A5677F8B2027EA8C9C76
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG0L0jMdB4Whm86/kRAsyeAJ4lCzenlF5PYALuuVQlhf82gU0+LgCePQEw
iokEW/S7WoEp4ldNo76fG7U=
=XO+a
-----END PGP SIGNATURE-----

--------------enigD496A5677F8B2027EA8C9C76--
