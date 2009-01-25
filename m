Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbZAYLum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbZAYLum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 06:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZAYLuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 06:50:32 -0500
Received: from smtp4.int-evry.fr ([157.159.10.71]:43355 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbZAYLub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 06:50:31 -0500
X-Greylist: delayed 1953 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jan 2009 06:50:31 EST
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
Date: Sun, 25 Jan 2009 12:18:31 +0100
User-Agent: KMail/1.9.9
Cc: john stultz <johnstul@us.ibm.com>, Miklos Vajna <vmiklos@frugalware.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?iso-8859-1?q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>,
       r.schwebel@pengutronix.de, sven@geggus.net
References: <20090121171423.GI21473@genesis.frugalware.org> <1f1b08da0901231736u46d8981ckc4b89ac66d7d8a5e@mail.gmail.com> <20090124091404.GA32032@elte.hu>
In-Reply-To: <20090124091404.GA32032@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2070265.z56BkuONSY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901251218.33255.florian.fainelli@telecomint.eu>
X-INT-MailScanner-Information: Please contact the ISP for more information
X-INT-MailScanner-ID: F1AE1404FA4.C4A9E
X-INT-MailScanner: Found to be clean
X-INT-MailScanner-SpamCheck: 
X-INT-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2070265.z56BkuONSY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le Saturday 24 January 2009 10:14:04 Ingo Molnar, vous avez =E9crit=A0:
> * john stultz <johnstul@us.ibm.com> wrote:
> > On Fri, Jan 23, 2009 at 3:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > > * john stultz <johnstul@us.ibm.com> wrote:
> > >> I'd think this would ideally be more of a subarch in the config
> > >> selection like the AMD Elan is, so folks know it really is not just a
> > >> extra-support feature and in fact limits what hardware you can use t=
he
> > >> resulting kernel on.
> > >
> > > a better solution is that if RDC is set [it is unset by default] we
> > > should turn PIT_TICK_RATE into a variable, defaulting it to 1193182. =
If
> > > a real RDC or ELAN system is running, that variable is changed during
> > > early bootup, in the init functions for those platforms.
> >
> > Took a quick look at this, and I don't see any detection code for either
> > RDC. The X86_ELAN config also has no conditionals, but maybe the elan
> > cpufreq code can help here.
>
> i'd suggest to just remove the #ifdef for now (it's causing problems) and
> add the variable - we can add the quirks for those two platforms later on,
> separately from your patch(es).

=46ine with me. Ingo, is there any infrastructure yet to get an early quirk=
 set=20
the PIT tick rate accordingly ?
=2D-=20
Cordialement, Florian Fainelli
=2D-----------------------------

--nextPart2070265.z56BkuONSY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl8SogACgkQmx9n1G/316titACaAwG1nn6ri5gD/YNRzgzwhdXk
YxAAn2kvOZnqUi0yuPgHHjsScVx86k6I
=Qces
-----END PGP SIGNATURE-----

--nextPart2070265.z56BkuONSY--
