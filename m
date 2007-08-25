Return-Path: <linux-kernel-owner+w=401wt.eu-S934547AbXHYWjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547AbXHYWjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 18:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760860AbXHYWjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 18:39:33 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45210 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755883AbXHYWjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 18:39:32 -0400
X-Sasl-enc: QFdcoKQITVSOERx3TBcwwmIC0NvMVgnfg4fs8LtjTllS 1188081571
Message-ID: <46D0AFB3.5080701@imap.cc>
Date: Sun, 26 Aug 2007 00:39:47 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>, Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.23-rc3-mm1
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	 <46CF695D.1020008@imap.cc>	 <20070824170702.a2c51084.akpm@linux-foundation.org> <1188001291.6163.36.camel@localhost.localdomain>
In-Reply-To: <1188001291.6163.36.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig594C2F3C21C0AC8070CBEAEE"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig594C2F3C21C0AC8070CBEAEE
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 25.08.2007 02:21 schrieb john stultz:

>> Tilman Schmidt <tilman@imap.cc> wrote:

>>> - on console early during boot, also in SuSE's /var/log/boot.msg:
>>>
>>> your system time is not correct:
>>> Wed Jul 13 13:15:31 UTC 1910
>>> setting system time to:
>>> Tue Jul 24 00:00:00 UTC 2007
>=20
> Hrmm. I'm not super familiar w/ SuSE's init scripts, but I'm guessing
> that's the ntpdate call.

Nope. The ntpdate call comes much later, and finally sets the system cloc=
k
correctly so that there are no lasting effects of all this.

> And "Tuesday Jul 24th"? Sounds about a month
> off, is this just stale info?

I have no idea where that might come from.

>>> /dev/system/root: Superblock last mount time is in the future.  FIXED=
=2E
>>> /dev/system/root: Superblock last write time is in the future.  FIXED=
=2E
>=20
> Does this show up before or after the above date stuff?

After the "your system time is not correct" messages, and before the
regular "Try to get initial date and time via NTP" message accompanying
the ntpdate call.

> Does the issue go away using an older kernel (I want to eliminate easy
> stuff like CMOS batteries giving up)?

It does. Booting 2.6.23-rc3 after that, the system comes up with none
of these messages.

> Also you're not using Linus' CMOS corrupting suspend/resume debugging
> trick, right (I'm forgetting the CONFIG name).

PM_TRACE? No. The entire PM_DEBUG branch is turned off.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig594C2F3C21C0AC8070CBEAEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG0K+7MdB4Whm86/kRAlyEAJ0TCgveTVgHwanWQ7+W97SRYoJIrgCeIZiU
TzqEU74RnDb9n/Oq0SVN+1o=
=HDhc
-----END PGP SIGNATURE-----

--------------enig594C2F3C21C0AC8070CBEAEE--
