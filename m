Return-Path: <linux-kernel-owner+w=401wt.eu-S934771AbXHYX0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934771AbXHYX0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 19:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbXHYX0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 19:26:18 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45462 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934665AbXHYXZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 19:25:57 -0400
X-Sasl-enc: Gxp2k5pxwDdyK00OpkFFPT33WOBLI99LZQYJsApU51rP 1188084356
Message-ID: <46D0BA9D.1080708@imap.cc>
Date: Sun, 26 Aug 2007 01:26:21 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>,
       Thomas Renninger <trenn@suse.de>, Adam Belay <abelay@novell.com>
Subject: Re: 2.6.23-rc3-mm1
References: <20070822020648.5ea3a612.akpm@linux-foundation.org><46CF695D.1020008@imap.cc> <20070824170702.a2c51084.akpm@linux-foundation.org> <653FFBB4508B9042B5D43DC9E18836F5014D954E@scsmsx415.amr.corp.intel.com> <653FFBB4508B9042B5D43DC9E18836F5014D956A@scsmsx415.amr.corp.intel.com>
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F5014D956A@scsmsx415.amr.corp.intel.com>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFBDB9E1D74636CC399F10C41"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFBDB9E1D74636CC399F10C41
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 25.08.2007 02:38 schrieb Pallipadi, Venkatesh:
>>
>>>> FATAL: Error inserting processor (/lib/modules/2.6.23-rc3-mm1-testin=
g/kernel/drivers/acpi/processor.ko): Input/output error
>>>> WARNING: Error inserting processor (/lib/modules/2.6.23-rc3-mm1-test=
ing/kernel/drivers/acpi/processor.ko): Input/output error
>=20
> This is indeed related to CPUIDLE.
>=20
> Tilman: Can you configure CONFIG_CPU_IDLE in your config (under Power
> Management option) and double check that the frequency part works after=

> that.

Strangely enough, I do not see that option in "make xconfig".
The "Power Management" subtree ends with "CPU Frequency scaling".
In "make menuconfig" the option is there, though.
After activating it, these two errors are indeed gone, and the
"thermal: Unknown symbol acpi_processor_set_thermal_limit" one
as well.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigFBDB9E1D74636CC399F10C41
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG0LqdMdB4Whm86/kRAgBUAJ0Qq4P2qNdQcgwOupw3ITsQDTiA8ACeIcs8
sXsPB7xe6/sdOhfaEAR/lP4=
=ctr4
-----END PGP SIGNATURE-----

--------------enigFBDB9E1D74636CC399F10C41--
