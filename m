Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0BWAAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 19:00:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42948 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab0BWAAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 19:00:07 -0500
Date: Tue, 23 Feb 2010 10:59:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: linux-next requirements (Was: Re: [tip:x86/ptrace] ptrace: Add
 support for generic PTRACE_GETREGSET/PTRACE_SETREGSET)
Message-Id: <20100223105959.a50dbe11.sfr@canb.auug.org.au>
In-Reply-To: <4B830BD8.3090600@zytor.com>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
	<tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
	<20100222090710.GA31357@elte.hu>
	<20100222203319.8bd497a2.sfr@canb.auug.org.au>
	<20100222102745.GJ20844@elte.hu>
	<20100222224752.0cbd5807.sfr@canb.auug.org.au>
	<4B830BD8.3090600@zytor.com>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Feb_2010_10_59_59_+1100_in=mjG8vcvChsI/x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Feb_2010_10_59_59_+1100_in=mjG8vcvChsI/x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Mon, 22 Feb 2010 14:57:28 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> Either which way, Roland has a mitigation patch -- which basically
> disables the broken bits of PARISC until the PARISC maintainers fix it.
>  What is the best way to handle that kind of stuff?

Well, now that Roland has made at least one of the PARISC maintainers
aware of the problem, we could wait a little while to see if a solution
is forthcoming from them.  If not, then maybe Roland's patch could be
applied to the appropriate tip tree or we could just leave PARISC broken
in linux-next until they decide to fix it.  Note that some of the PARISC
builds are already broken in linux-next for other reasons.

Are there any downsides to Roland's patch as far as PARISC is concerned
(apart from the loss of some functionality, of course)?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Feb_2010_10_59_59_+1100_in=mjG8vcvChsI/x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuDGn8ACgkQjjKRsyhoI8zWVQCgmuvNJybCs0PlZoLi/vIu1Pvu
5CwAoLy5FUF9WMzqnLazftm1RBlCL0tS
=zz+Y
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Feb_2010_10_59_59_+1100_in=mjG8vcvChsI/x--
