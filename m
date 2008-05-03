Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbYECFxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbYECFxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 01:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYECFw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 01:52:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45333 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbYECFw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 01:52:58 -0400
Date: Sat, 3 May 2008 15:52:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@suse.cz>, linux-next@vger.kernel.org
Subject: Re: Strange linux-next build error
Message-Id: <20080503155252.0dc9c4d7.sfr@canb.auug.org.au>
In-Reply-To: <200805030121.39831.dhazelton@enter.net>
References: <200805030121.39831.dhazelton@enter.net>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__3_May_2008_15_52_52_+1000_vvJ184G7y4IrqUig"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__3_May_2008_15_52_52_+1000_vvJ184G7y4IrqUig
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Just adding some cc's ... it is worth cc'ing linux-next for bugs in
linux-next (instead, or as well, as me personally) since people who are
interested are probably subscribed there.

On Sat, 3 May 2008 01:21:38 -0400 Daniel Hazelton <dhazelton@enter.net> wro=
te:
>
> After updating my local tree to the latest linux-next and starting a clea=
n=20
> build I see this error *ONLY* the first time I start a "make bzImage"
>=20
>   CC      arch/x86/kernel/acpi/sleep.o
>   LDS     arch/x86/kernel/acpi/realmode/wakeup.lds
> cc1: fatal error: opening output file=20
> arch/x86/kernel/acpi/realmode/wakeup.lds: Permission denied
> compilation terminated.
> make[4]: *** [arch/x86/kernel/acpi/realmode/wakeup.lds] Error 1
> make[3]: *** [arch/x86/kernel/acpi/realmode/wakeup.bin] Error 2
> make[2]: *** [arch/x86/kernel/acpi] Error 2
> make[1]: *** [arch/x86/kernel] Error 2
> make: *** [bzImage] Error 2
>=20
> Restarting the build brings it through to completion. I've checked and th=
ere=20
> is no reason that this error should occur.
>=20
> madman@strider:~/linux/linux-git/Documentation$ gcc --version
> gcc (GCC) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)
> Copyright (C) 2006 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOS=
E.
>=20
> (I'll be booting this kernel tomorrow to test it - previous -next kernels=
 have=20
> all faulted during boot)
>=20
> DRH

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__3_May_2008_15_52_52_+1000_vvJ184G7y4IrqUig
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIG/25TgG2atn1QN8RAsOuAJ9D18jaAYBTMXQlCBpIcmGxl/5RYQCcDpN6
NJQ/nWS2Gm1Zvl9c0usBvuY=
=7ToH
-----END PGP SIGNATURE-----

--Signature=_Sat__3_May_2008_15_52_52_+1000_vvJ184G7y4IrqUig--
