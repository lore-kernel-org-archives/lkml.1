Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbYLFTJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbYLFTJl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 14:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYLFTJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 14:09:32 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:44463 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751542AbYLFTJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 14:09:31 -0500
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Dec 2008 14:09:30 EST
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Is vm86old no more implemented?
Date: Sat, 6 Dec 2008 22:02:29 +0300
User-Agent: KMail/1.10.90 (Linux/2.6.28-rc7-1avb; KDE/4.1.81; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200812061043.51438.arvidjaar@mail.ru> <200812061252.51173.arvidjaar@mail.ru> <20081206102047.GG6703@one.firstfloor.org>
In-Reply-To: <20081206102047.GG6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8141827.tHInVu7m4H";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812062202.30476.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8141827.tHInVu7m4H
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On =D0=A1=D1=83=D0=B1=D0=B1=D0=BE=D1=82=D0=B0 06 =D0=B4=D0=B5=D0=BA=D0=B0=
=D0=B1=D1=80=D1=8F 2008 13:20:47 Andi Kleen wrote:
> On Sat, Dec 06, 2008 at 12:52:43PM +0300, Andrey Borzenkov wrote:
> > On =D0=A1=D1=83=D0=B1=D0=B1=D0=BE=D1=82=D0=B0 06 =D0=B4=D0=B5=D0=BA=D0=
=B0=D0=B1=D1=80=D1=8F 2008 11:56:03 Andi Kleen wrote:
> > > Andrey Borzenkov <arvidjaar@mail.ru> writes:
> > > > CONFIG_VM86 is defined; is there anything else that is needed?
> > > > This fails both in 2.6.27.7 and in 2.6.28-rc7. I attach config
> > > > from 2.6.28-rc7.
> > >
> > > It should still work. Can you double check you're running the
> > > correct kernel? Perhaps a 64bit kernel (which doesn't implement
> > > it).
> >
> > Linux cooker 2.6.28-rc7-1avb #23 Fri Dec 5 22:42:47 MSK 2008 i686
> > Pentium III (Coppermine) GNU/Linux
> >
> > Anything else I can check?
>
> Hmm perhaps place a printk into
> arch/x86/kernel/vm86_32.c:sys_vm86old() and see if it's reached.
>

It is:

[  156.094049] sys_vm86old called by monitor-get-edi
[  156.243660] sys_vm86old called by monitor-get-edi
[  285.698333] sys_vm86old called by X
[  285.699408] sys_vm86old called by X
[  285.699813] sys_vm86old called by X

any chance the specific function that is invoked is not implemented?=20
Because at least X apparently does not always fail video BIOS call - how=20
can I catch which calls were successful and which failed? I understand=20
return path sys_vm86old is rather non-standard.

--nextPart8141827.tHInVu7m4H
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk6zEYACgkQR6LMutpd94y2BwCgvaUWkuEVwruJLAlaxvXNf2LO
1mYAnAjiD0plRbeGKjmmO1jNCJcosvXZ
=MbbH
-----END PGP SIGNATURE-----

--nextPart8141827.tHInVu7m4H--
