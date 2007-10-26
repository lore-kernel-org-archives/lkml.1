Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbXJZKEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbXJZKEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbXJZKEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:04:23 -0400
Received: from [202.201.0.146] ([202.201.0.146]:60356 "HELO eyou.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753393AbXJZKEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:04:22 -0400
X-EYOU-SPAMVALUE: 0
X-EYOU-DEALDRC: 
Message-ID: <393455391.26095@eyou.net>
X-EYOUMAIL-SMTPAUTH: wangbj@lzu.edu.cn
From: "Wang, Baojun" <wangbj@lzu.edu.cn>
Organization: dslab
To: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: kernel 2.6.23 CFS problem?
Date: Fri, 26 Oct 2007 18:04:26 +0800
User-Agent: KMail/1.9.7
References: <200710261057.48179.wangbj@lzu.edu.cn> <200710261532.22265.wangbj@lzu.edu.cn> <393390073.22773@lzu.edu.cn>
In-Reply-To: <393390073.22773@lzu.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1424560.IQlMfqgZxL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710261804.29136.wangbj@lzu.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1424560.IQlMfqgZxL
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 26 October 2007 17:05:42, you wrote=EF=BC=9A
> On Fri, 2007-10-26 at 15:32 +0800, Wang, Baojun wrote:
> > > Perhaps he has any tasks stuck in 'D' state?  If so, SysRq-t output f=
or
> > > these would be a good thing to collect.  What leads him to suspect the
> > > process scheduler, etc.  More details are needed.
> >
> > The task is S+ state, please see in the attachment tarball, SysRq-t
> > output has also been attached, I wish it would help. I doubt it's the C=
=46S
> > problem because it's first introduced into the 2.6.23 kernel.
>
> (yeah, but there were a truckload of other changes as well)
>
> Looking at your data, _my_ first suspect would be the 2.6.22->2.6.23
> futex changes.  I'd revert all of the changes to kernel/futex.c and
> kernel/futex_compat.c, and see if the problem went away.  If it didn't,
> I'd then do a full git bisect to nail it down.
>
> 	-Mike

Thanks very much, also my glibc (2.6.1) is built under 2.6.23 (but not=20
linux-headers, which is 2.6.22). but I've tried right now (install ELDK4.1)=
=20
on another x86_64 machine, without any problem (x86_64, Core2Duo E6600, 4G=
=20
RAM)

Wang
=2D-=20
Wang, Baojun =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0Lanzhou University
Distributed & Embedded System Lab =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0http://dslab.lzu.edu.cn
School of Information Science and Engeneering =C2=A0 =C2=A0 =C2=A0 =C2=A0wa=
ngbj@lzu.edu.cn
Tianshui South Road 222. Lanzhou 730000 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .P.R.China
Tel:+86-931-8912025 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Fax:+86-931-8912022

--nextPart1424560.IQlMfqgZxL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHIbuqIuIOr7tpgg0RAkuiAJ9P7TBTkXdyC+dmO3w+EEfigK/sBACfXePk
NtuzzKP52yscLp9gFfVWtrI=
=wIdN
-----END PGP SIGNATURE-----

--nextPart1424560.IQlMfqgZxL--
