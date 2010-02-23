Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0BWWyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:54:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51178 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab0BWWyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:54:50 -0500
Date: Wed, 24 Feb 2010 09:54:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       linux-tip-commits@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: linux-next requirements (Was: Re: [tip:x86/ptrace] ptrace: Add
 support for generic PTRACE_GETREGSET/PTRACE_SETREGSET)
Message-Id: <20100224095443.cb398c27.sfr@canb.auug.org.au>
In-Reply-To: <4B843F66.6030000@zytor.com>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
	<tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
	<20100222090710.GA31357@elte.hu>
	<20100222203319.8bd497a2.sfr@canb.auug.org.au>
	<20100222102745.GJ20844@elte.hu>
	<20100222224752.0cbd5807.sfr@canb.auug.org.au>
	<4B830BD8.3090600@zytor.com>
	<20100223105959.a50dbe11.sfr@canb.auug.org.au>
	<20100223202030.44DED64C@magilla.sf.frob.com>
	<4B843F66.6030000@zytor.com>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Feb_2010_09_54_43_+1100_TlpEJHGffexr1Ph1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Feb_2010_09_54_43_+1100_TlpEJHGffexr1Ph1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Feb 2010 12:49:42 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 02/23/2010 12:20 PM, Roland McGrath wrote:
> >> Are there any downsides to Roland's patch as far as PARISC is concerned
> >> (apart from the loss of some functionality, of course)?
> >=20
> > Kyle ACK'd my parisc patch, and my impression is he wants it to go in
> > and does not plan to work on the necessary arch support imminently.
> >=20
> > I think the only visible effect of turning off HAVE_ARCH_TRACEHOOK
> > on parisc will be that /proc/pid/syscall is not available.
>=20
> Added to tip:x86/ptrace.

And Linus actually put it in his tree yesterday ... commit
15cbf627abcd93c3c668d5a92d58d9fec8f953dd "Revert "parisc:
HAVE_ARCH_TRACEHOOK""

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Feb_2010_09_54_43_+1100_TlpEJHGffexr1Ph1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuEXLMACgkQjjKRsyhoI8wb3ACgohZdrhbZ+u+VHt7udSSZx15e
Nv8Anjm1uBoN+5bclL7q/FI6EJ/d9S+u
=3rcX
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Feb_2010_09_54_43_+1100_TlpEJHGffexr1Ph1--
