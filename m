Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbXH0Nh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbXH0Nh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 09:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXH0NhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 09:37:14 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:1736 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbXH0NhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 09:37:13 -0400
Message-ID: <46D2D327.6040307@imap.cc>
Date: Mon, 27 Aug 2007 15:35:35 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>,
       Thomas Renninger <trenn@suse.de>, Adam Belay <abelay@novell.com>
Subject: Re: 2.6.23-rc3-mm1
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	<46CF695D.1020008@imap.cc>	<20070824170702.a2c51084.akpm@linux-foundation.org>	<653FFBB4508B9042B5D43DC9E18836F5014D954E@scsmsx415.amr.corp.intel.com>	<653FFBB4508B9042B5D43DC9E18836F5014D956A@scsmsx415.amr.corp.intel.com>	<46D0BA9D.1080708@imap.cc> <20070825165701.8423f5e6.randy.dunlap@oracle.com>
In-Reply-To: <20070825165701.8423f5e6.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig66CAB4E014047B70F6E776D0"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig66CAB4E014047B70F6E776D0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 26.08.2007 01:57 schrieb Randy Dunlap:
> On Sun, 26 Aug 2007 01:26:21 +0200 Tilman Schmidt wrote:
>=20
>> Am 25.08.2007 02:38 schrieb Pallipadi, Venkatesh:
>> >=20
>> > Tilman: Can you configure CONFIG_CPU_IDLE in your config (under Powe=
r
>> > Management option) and double check that the frequency part works af=
ter
>> > that.
>>=20
>> Strangely enough, I do not see that option in "make xconfig".
>> The "Power Management" subtree ends with "CPU Frequency scaling".
>> In "make menuconfig" the option is there, though.
>=20
> That sounds strange.  Please share your .config file.

I'm sorry but I cannot reproduce the phenomenon anymore. After setting
CONFIG_CPU_IDLE with "make menuconfig", when I ran "make xconfig" again
it showed the option too. Moving .config.old back to .config doesn't
make it disappear again. So it seems "make menuconfig" has elliminated
whatever caused this.

If you still want to have a look, both .config and .config.old are
available at http://gollum.phnxsoft.com/~ts/2.6.23-rc3-mm1/ .

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig66CAB4E014047B70F6E776D0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG0tMnQ3+did9BuFsRAuDKAJ49weU/Xc4BsFtPNeibgRLJTiLSxwCfUkn6
FzmvYw7iDGLl7kDiiuHjTJ0=
=TXB+
-----END PGP SIGNATURE-----

--------------enig66CAB4E014047B70F6E776D0--
