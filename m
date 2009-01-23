Return-Path: <linux-kernel-owner+w=401wt.eu-S1759725AbZAWAMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725AbZAWAMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZAWAME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:12:04 -0500
Received: from virgo.iok.hu ([212.40.97.103]:40827 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbZAWAMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:12:01 -0500
Date: Fri, 23 Jan 2009 01:12:00 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?iso-8859-1?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
Message-ID: <20090123001200.GC21473@genesis.frugalware.org>
References: <20090121171423.GI21473@genesis.frugalware.org> <1f1b08da0901211200l88fa89s78a51c4e90878d85@mail.gmail.com> <20090121210726.GK21473@genesis.frugalware.org> <1232573646.6997.21.camel@localhost.localdomain> <20090122195132.GZ21473@genesis.frugalware.org> <20090122195558.GA21118@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bGopQmzlzQgFk3Fg"
Content-Disposition: inline
In-Reply-To: <20090122195558.GA21118@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bGopQmzlzQgFk3Fg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2009 at 08:55:58PM +0100, Ingo Molnar <mingo@elte.hu> wrote:
> these look suspect in the good->bad diff:
>=20
>  # CONFIG_X86_VOYAGER is not set
>  # CONFIG_X86_GENERICARCH is not set
>  # CONFIG_X86_VSMP is not set
> -# CONFIG_X86_VISWS is not set
> -# CONFIG_X86_RDC321X is not set
> +CONFIG_X86_VISWS=3Dy
> +CONFIG_X86_RDC321X=3Dy
>  CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=3Dy
> -# CONFIG_PARAVIRT_GUEST is not set
> +CONFIG_PARAVIRT_GUEST=3Dy
> +# CONFIG_VMI is not set
> +CONFIG_KVM_CLOCK=3Dy
> +CONFIG_KVM_GUEST=3Dy
> +CONFIG_LGUEST_GUEST=3Dy
> +CONFIG_PARAVIRT=3Dy
> +CONFIG_PARAVIRT_CLOCK=3Dy
> +# CONFIG_PARAVIRT_DEBUG is not set
>  CONFIG_MEMTEST=3Dy

Hmm it seems my reply to this mail was lost, so:

First I build with CONFIG_X86_VISWS, CONFIG_X86_RDC321X and
CONFIG_PARAVIRT_GUEST disabled, then the clock became normal again.

Then later I tried just disabling CONFIG_X86_VISWS and
CONFIG_X86_RDC321X, and that was enough as well.

Thank you!

--bGopQmzlzQgFk3Fg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl5C1AACgkQe81tAgORUJbnUwCgiAENMse7wnVCCVfyFLZI9Vew
ZNUAn18QjWTZEZZ0vRNBe+XLmMkdpCZ/
=jFpU
-----END PGP SIGNATURE-----

--bGopQmzlzQgFk3Fg--
