Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbYJCM6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbYJCM6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 08:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYJCM6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 08:58:00 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:50978 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYJCM57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 08:57:59 -0400
Date: Fri, 3 Oct 2008 15:58:48 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: Implement personality ADDR_LIMIT_32BIT
Message-ID: <20081003125847.GA9809@localhost.localdomain>
References: <1223017469-5158-1-git-send-email-kirill@shutemov.name> <20081003080244.GC25408@elte.hu> <20081003092550.GA8669@localhost.localdomain> <20081003054431.33e19339@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20081003054431.33e19339@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 03, 2008 at 05:44:31AM -0700, Arjan van de Ven wrote:
> On Fri, 3 Oct 2008 12:25:52 +0300
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
>=20
> > On Fri, Oct 03, 2008 at 10:02:44AM +0200, Ingo Molnar wrote:
> > >=20
> > > * Kirill A. Shutemov <kirill@shutemov.name> wrote:
> > >=20
> > > > -	/* for MAP_32BIT mappings we force the legact mmap base
> > > > */
> > > > -	if (!test_thread_flag(TIF_IA32) && (flags & MAP_32BIT))
> > > > +	/* for MAP_32BIT mappings and ADDR_LIMIT_32BIT
> > > > personality we force the
> > > > +	 * legact mmap base
> > > > +	 */
> > >=20
> > > please use the customary multi-line comment style:
> > >=20
> > >   /*
> > >    * Comment .....
> > >    * ...... goes here:
> > >    */
> > >=20
> > > and you might use the opportunity to fix the s/legact/legacy typo
> > > as well.
> >=20
> > Ok, I'll fix it.
> >=20
> > >=20
> > > but more generally, we already have ADDR_LIMIT_3GB support on x86.
> >=20
> > Does ADDR_LIMIT_3GB really work?
>=20
> if it's broken we should fix it.... not invent a new one.
> Also, traditionally often personalities only start at exec() time iirc.
> (but I could be wrong on that)

What is difference beetween ADDR_LIMIT_3GB and ADDR_LIMIT_32BIT? Probably,
I implement ADDR_LIMIT_3GB, not ADDR_LIMIT_32BIT...

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjmFwcACgkQbWYnhzC5v6r6bgCglPzVDYS7Gd39Fi8PObMbKTFp
bxAAnj3qsoDFpFteMNdni8jjWpqohHmq
=2ZxL
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
