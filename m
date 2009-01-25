Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbZAYLu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbZAYLu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 06:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZAYLud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 06:50:33 -0500
Received: from smtp4.int-evry.fr ([157.159.10.71]:57366 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZAYLuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 06:50:32 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
Date: Sun, 25 Jan 2009 12:17:25 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Miklos Vajna <vmiklos@frugalware.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?iso-8859-1?q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>,
       r.schwebel@pengutronix.de, sven@geggus.net
References: <20090121171423.GI21473@genesis.frugalware.org> <20090123110439.GK15188@elte.hu> <1f1b08da0901231736u46d8981ckc4b89ac66d7d8a5e@mail.gmail.com>
In-Reply-To: <1f1b08da0901231736u46d8981ckc4b89ac66d7d8a5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart22431502.DhsJ6V7job";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901251217.27995.florian.fainelli@telecomint.eu>
X-INT-MailScanner-Information: Please contact the ISP for more information
X-INT-MailScanner-ID: 18751404FA4.8EAB3
X-INT-MailScanner: Found to be clean
X-INT-MailScanner-SpamCheck: 
X-INT-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart22431502.DhsJ6V7job
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le Saturday 24 January 2009 02:36:30 john stultz, vous avez =E9crit=A0:
> On Fri, Jan 23, 2009 at 3:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > * john stultz <johnstul@us.ibm.com> wrote:
> >> I'd think this would ideally be more of a subarch in the config
> >> selection like the AMD Elan is, so folks know it really is not just a
> >> extra-support feature and in fact limits what hardware you can use the
> >> resulting kernel on.
> >
> > a better solution is that if RDC is set [it is unset by default] we
> > should turn PIT_TICK_RATE into a variable, defaulting it to 1193182. If=
 a
> > real RDC or ELAN system is running, that variable is changed during ear=
ly
> > bootup, in the init functions for those platforms.
>
> Took a quick look at this, and I don't see any detection code for
> either RDC. The X86_ELAN config also has no conditionals, but maybe
> the elan cpufreq code can help here.
>
> Florian: Is there any way we can check very early (ie: in setup_arch)
> for an RDC box?

Sorry for answering so late.

We cannot rely on the cpuid since there is not one, nor the bios, since mos=
t=20
(if not all) boards use RedBoot as a bootloader. If we have PCI initiliazed=
,=20
we could check the presence of a R6040 Ethernet MAC.
=2D-=20
Cordialement, Florian Fainelli
=2D-----------------------------

--nextPart22431502.DhsJ6V7job
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl8SkYACgkQmx9n1G/316tz3gCg1LaSzx4LiRlP05AckNhEmTlc
Iv8AoKiDYosq8lXE+mi+SPcEkEk1A1Al
=HqTp
-----END PGP SIGNATURE-----

--nextPart22431502.DhsJ6V7job--
