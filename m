Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbXLaQDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbXLaQDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXLaQDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:03:11 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56794 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbXLaQDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:03:10 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: asm-x86/msr.h for sanitized headers: clean it or punt it
Date: Mon, 31 Dec 2007 10:33:33 -0500
User-Agent: KMail/1.9.7
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       LKML <linux-kernel@vger.kernel.org>
References: <200712310045.24069.vapier@gentoo.org> <p73sl1jyrqx.fsf@bingen.suse.de>
In-Reply-To: <p73sl1jyrqx.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1972407.S1AKZbAnmr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200712311033.34489.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1972407.S1AKZbAnmr
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 31 December 2007, Andi Kleen wrote:
> Mike Frysinger <vapier@gentoo.org> writes:
> > The current asm-x86/msr.h does not actually define anything for
> > (!__KERNEL__ && __i386__).  For x86_64, it fails to build due to u32/u64
> > types being used. Simply not installing the header seems easiest to me.=
=20
> > Otherwise, x86_64 will need sanitizing and i386 should have things added
> > back, otherwise it's just a pointless empty header.
>
> Please don't -- asm/msr.h is very useful in user space for rdtscll et.al.
> I use it all the time in test programs.

can you enumerate which functions need to actually go to userspace then ?  =
the=20
__KERNEL__ markings are a crapshoot at the moment.  you must also be jumpin=
g=20
through hoops in order to use the header in the first place since the vanil=
la=20
one wont compile out of the box.
=2Dmike

--nextPart1972407.S1AKZbAnmr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.8 (GNU/Linux)

iQIcBAABAgAGBQJHeQvOAAoJEEFjO5/oN/WBbW8P/2P6JerX50SWio7NLNoaB7WM
KAkG+kMDKUi00biZrdoI32TWD3sH66vtHU7TgQvixu4+Ni8irJa+rMffbHAWRc3W
4yWswNpDYMzi27JxoFf37NueZzAPCLJUUpSd0A89SI87Eq73u0IhIN1RvcfOTUwU
Koa3WuKmlPht1sEV5uAc4kAuL4I0rBL5GU8fv9EBjiPpIsr9KH3h2VyAC/5TxWe/
4mQb2pdqnKc+JP6wJG+uZxKibbv0j9oVNtoP/hxrPg1l3m8jygqdkYZur+nL4WAk
29sEOtPXdxtyU2DcwbP512IJ/M4tMErBUo3UXlX4MTo3z0kM2S+9j1wL1s4rESb2
odE1n9ozxUcy+g3gonB7IRnoA3Mlj3y9yboohj043vuYqdoNg/NVcxiI8U62UP0E
xobwWhwMLCF7gyz37i0NjVyn/1HzuC+yKdJ8Kio1QGzWdWeZcOKGjIb5rSKbMLwl
yGQwbXlFrof6uNEu/Esk9NVJx9Yhb6PehoMoIWiw5x1mh4Ncq8T0TODVMMVwTQ8c
nEAAmUpJkHxKD8mcB31E3D2sOE81ER2j92d6DYbDGFi+ZFOIFoDJefETwDKO7E6o
nh6Fj4RQUnTKG1mNoW0H+X6g3WbQdZ65pXUVzZNSjNCBH0VgnGsGoSj+HYNs3mnO
7ETgGX6TWPBrPN4MSqag
=alQK
-----END PGP SIGNATURE-----

--nextPart1972407.S1AKZbAnmr--
