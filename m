Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbYHHDNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbYHHDNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 23:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYHHDNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 23:13:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53138 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbYHHDNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 23:13:42 -0400
Date: Fri, 8 Aug 2008 13:13:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Junio C Hamano <gitster@pobox.com>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Petr Baudis <pasky@suse.cz>, "Shawn O. Pearce" <spearce@spearce.org>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>
Subject: Re: [PATCH] powerpc: Do not ignore arch/powerpc/include
Message-Id: <20080808131326.e5eddc47.sfr@canb.auug.org.au>
In-Reply-To: <7vzlnogtzv.fsf_-_@gitster.siamese.dyndns.org>
References: <20080721002354.GK10151@machine.or.cz>
	<20080721002508.26773.92277.stgit@localhost>
	<7v8wvpm9cl.fsf@gitster.siamese.dyndns.org>
	<7vej5543v5.fsf_-_@gitster.siamese.dyndns.org>
	<alpine.LFD.1.10.0808041719380.3299@nehalem.linux-foundation.org>
	<7vk5etjozt.fsf@gitster.siamese.dyndns.org>
	<7vzlnogtzv.fsf_-_@gitster.siamese.dyndns.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Aug_2008_13_13_26_+1000_YKkjcnieXWoyGkk6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Aug_2008_13_13_26_+1000_YKkjcnieXWoyGkk6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Junio,

On Thu, 07 Aug 2008 18:45:08 -0700 Junio C Hamano <gitster@pobox.com> wrote:
>
> Back when .gitignore file was added to arch/powerpc/ in 06f2138 ([POWERPC]
> Add files build to .gitignore, 2006-11-26), there indeed was nothing
> tracked in the ignored hierarchy and ignoring everything made sense.  But
> we have very many tracked files there these days, and having a higher
> level .gitignore that ignores everything is asking for future troubles..

We used to create a symlink called "include" in arch/powerpc (during the
build) as part of sharing our include files with arch/ppc.

> This should have been part of b8b572e (powerpc: Move include files to
> arch/powerpc/include/asm, 2008-08-01).

Yeah, sorry about that.

> Signed-off-by: Junio C Hamano <gitster@pobox.com>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Aug_2008_13_13_26_+1000_YKkjcnieXWoyGkk6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkibudYACgkQjjKRsyhoI8xjcQCeK3JRJnX4IlyfhpC1ifCfGUdG
1DEAoIqvW56kym4NmEhGTpiLRkq8IW2v
=SWzl
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Aug_2008_13_13_26_+1000_YKkjcnieXWoyGkk6--
