Return-Path: <linux-kernel-owner+w=401wt.eu-S1765422AbZAOOU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765422AbZAOOU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbZAOOUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:20:50 -0500
Received: from lug-owl.de ([195.71.106.12]:58406 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbZAOOUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:20:49 -0500
Date: Thu, 15 Jan 2009 15:20:47 +0100
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
       Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is 386 processor still supported?
Message-ID: <20090115142047.GV11087@lug-owl.de>
Mail-Followup-To: "Maciej W. Rozycki" <macro@linux-mips.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>,
	Jiri Kosina <jkosina@suse.cz>, Adam Osuchowski <adwol@zonk.pl>,
	linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <1231424025.11687.447.camel@twins> <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz> <1231424833.11687.452.camel@twins> <20090108150448.2393aeb0@lxorguk.ukuu.org.uk> <20090108151046.GK18120@elte.hu> <alpine.LFD.1.10.0901130047160.10547@ftp.linux-mips.org> <20090115123614.GR11087@lug-owl.de> <alpine.LFD.1.10.0901151309420.5737@ftp.linux-mips.org> <20090115133252.28c36adb@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0901151353530.5737@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KMT2bFHAEoOkugdu"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0901151353530.5737@ftp.linux-mips.org>
X-Operating-System: Linux mail 2.6.18-5-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-message-flag: Please send plain text messages only. Do not send HTML emails. Thank you. 
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KMT2bFHAEoOkugdu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 14:15:56 +0000, Maciej W. Rozycki <macro@linux-mips.org>=
 wrote:
> On Thu, 15 Jan 2009, Alan Cox wrote:
> > >  UP emulation of CMPXCHG and XADD for userland should be rather trivi=
al,=20
> > > so why not include it like with LL/SC for MIPS?
> >=20
> > Why not just ship an additional libc with the right options ?
>=20
>  Does not work for MIPS as glibc has no equivalent code for pre-LL/SC CPU=
s=20
> and LL/SC is always used.  For the i386 the situation seems worse yet as=
=20
> for pre-i486 CPUs a generic C implementation of compare-and-exchange is=
=20
> used guaranteeing silent thread unsafety. :(
>=20
>  IMO, a kernel emulation of CMPXCHG and XADD (both are used by=20
> sysdeps/i386/i486/bits/atomic.h in glibc) with an optional LOCK prefix,=
=20
> guaranteeing UP atomicity would be a cheap way to provide long-term i386=
=20
> userland support with little burden for both Linux and respective user=20
> software maintainers.  Certainly it adds some bloat to the kernel, but I=
=20
> think it is not an option that should be outright dismissed without=20
> consideration.

I just searched for the old patch, but couldn't find it ad hoc. (But
it must be somewhere, at least in the archives, I guess?)

The kernel emulator has the benefit of no overhead when not switched
on, and low-to-no overhead when not being used (i386 capable kernel on
i486 hardware).

Heck, I'd dig out my two test systems and give them a try with current
Debian unstable. Should be fun with four to eight megabytes of RAM.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of: 23:53 <@jbglaw> So, ich kletter' jetzt mal ins Bett.
the second  : 23:57 <@jever2> .oO( kletter ..., hat er noch Gitter vorm Bet=
t, wie fr=C3=BCher meine Kinder?)
              00:00 <@jbglaw> jever2: *patsch*
              00:01 <@jever2> *aua*, wof=C3=BCr, Gedanken sind frei!
              00:02 <@jbglaw> Nee, freie Gedanken, die sind seit 1984 doch =
aus!
              00:03 <@jever2> 1984? ich bin erst seit 1985 verheiratet!

--KMT2bFHAEoOkugdu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJb0Y/Hb1edYOZ4bsRAnEeAJ9JkaqmDFOGp1uPNzBe4qeSgl19dQCeI123
c4oTq/pPCaUPcdJp3a/GsbU=
=wHyn
-----END PGP SIGNATURE-----

--KMT2bFHAEoOkugdu--
