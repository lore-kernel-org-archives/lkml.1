Return-Path: <linux-kernel-owner+w=401wt.eu-S1759762AbZFNXHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762AbZFNXHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 19:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZFNXHC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 19:07:02 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44076 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbZFNXHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 19:07:00 -0400
Date: Mon, 15 Jun 2009 09:06:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: kbuild tree build warning
Message-Id: <20090615090655.9157bcc1.sfr@canb.auug.org.au>
In-Reply-To: <20090610064723.GA25493@uranus.ravnborg.org>
References: <20090610115255.035da856.sfr@canb.auug.org.au>
	<20090610064723.GA25493@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Jun_2009_09_06_55_+1000_I/vIBg=6KNm1DGpa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Jun_2009_09_06_55_+1000_I/vIBg=6KNm1DGpa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Wed, 10 Jun 2009 08:47:23 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> On Wed, Jun 10, 2009 at 11:52:55AM +1000, Stephen Rothwell wrote:
> >=20
> > Today's linux-next build (x86_64 allmodconfig) produced this warning:
> >=20
> > In file included from arch/x86/kernel/vmlinux.lds.S:23:
> > include/asm-generic/vmlinux.lds.h:726:47: warning: backslash-newline at=
 end of file
> >=20
> > Caused by commit ef53dae8658cf0e93d380983824a661067948d87 ("Improve
> > vmlinux.lds.h support for arch specific linker scripts").
>=20
> I already fixed this locally but I forgot to do a "git commit --amend" :-)
> Will be fixed in next push of kbuild-next.

Then why didn't it make it into the version that just got into Linus'
tree?  Also the other I mentioned:

include/asm-generic/vmlinux.lds.h:695:1: warning: "/*" within comment

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Jun_2009_09_06_55_+1000_I/vIBg=6KNm1DGpa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko1go8ACgkQjjKRsyhoI8zx/ACff/Up/fMpWmSUyJLu3Ppii7ct
/e8AoMBtTW5tmizXHeCkWenxuBvZUq6e
=rB1m
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Jun_2009_09_06_55_+1000_I/vIBg=6KNm1DGpa--
