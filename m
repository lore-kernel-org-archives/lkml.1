Return-Path: <linux-kernel-owner+w=401wt.eu-S1760309AbYAJXfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309AbYAJXfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759811AbYAJXf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:35:29 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:32963 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759262AbYAJXf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:35:27 -0500
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of
	32bit applications(binaries) on 64bit system (Gentoo)
From: Zan Lynx <zlynx@acm.org>
To: Matthew <jackdachef@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <e85b9d30801100443s50ab2b69wbf1a7b4dbd09f002@mail.gmail.com>
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>
	 <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com>
	 <200712300128.35476.mboton@gmail.com> <20080102084002.GA13636@elte.hu>
	 <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com>
	 <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com>
	 <47841C41.4060401@zytor.com>
	 <e85b9d30801100105s60ad675ey1ba939491d01a649@mail.gmail.com>
	 <20080110094219.GC17808@elte.hu>
	 <e85b9d30801100443s50ab2b69wbf1a7b4dbd09f002@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Tj6UwCiZx8KvkHKIUBCu"
Date: Thu, 10 Jan 2008 16:35:14 -0700
Message-Id: <1200008114.16470.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080110/1JD6vc-0006dP-Nj-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Tj6UwCiZx8KvkHKIUBCu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-01-10 at 13:43 +0100, Matthew wrote:

> it's a little tricky to reproduce it:
> I tried it with root-account: firefox-bin, thunderbird-bin wouldn't trigg=
er
> user-account (with used account-directory of both apps):
> thunderbird-bin triggers it more reliably
> probably it has to do with the x86 compatibility apps of gentoo ?
> gentoo amd64-users with 32bit firefox & thunderbird - anyone able to
> reproduce it ?

I believe that I *have* seen this happen to me.  I'm using a Compaq
R3000 laptop with AMD-64 CPU and Gentoo with kernel 2.6.24-rc6-mm1.

A few days ago I crashed it twice in a row by trying to load my Comics
bookmarks as tabs (87 entries) in 32-bit Firefox.

I only got 1 and 3/4ths lines output by netconsole and it mentioned a
function with 32-something in the name.

Later tonight I can try loading the tabs in Firefox again to see if it
will reproduce for a 3rd time.

I also have to say that the NMI watchdog, supposedly Non-Maskable,
hardly *ever* works for me.  I don't believe that whatever events reset
the dog actually matter to the end user.  Perhaps its still processing
interrupts and running a timer loop but if nothing can read or write
disk, net, netlink or other device IO, I don't believe the system can
actually claim to be working.
--=20
Zan Lynx <zlynx@acm.org>

--=-Tj6UwCiZx8KvkHKIUBCu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.8 (GNU/Linux)

iEYEABECAAYFAkeGq7IACgkQG8fHaOLTWwh0hwCfYoXlzQ410jT03L4YcCLUZ5N3
6ugAn2u/kywBwtNifJmb0Ywlr/9P4A39
=FUuf
-----END PGP SIGNATURE-----

--=-Tj6UwCiZx8KvkHKIUBCu--

