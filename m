Return-Path: <linux-kernel-owner+w=401wt.eu-S934234AbXGQSkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbXGQSkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbXGQSjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:39:53 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:44238 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753729AbXGQSjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:39:52 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
Date: Tue, 17 Jul 2007 21:39:05 +0300
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
References: <11846910642166-git-send-email-avi@qumranet.com>
In-Reply-To: <11846910642166-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart296178828.qKOvTYKK74";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707172139.09131.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart296178828.qKOvTYKK74
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

17 Tem 2007 Sal tarihinde, Avi Kivity =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> I fixed the issue with the previous patchset.  Please provide further
> feedback, or pull from:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus
>
> This contains kvm updates for the 2.6.23 merge window, including
>
>  - performance improvements
>  - suspend/resume fixes
>  - guest smp
>  - random fixes and cleanups

I have a tiny question triggered in my mind after seeing following, sorry i=
f=20
this was disccussed before;

config KVM
    tristate "Kernel-based Virtual Machine (KVM) support"
    depends on X86 && EXPERIMENTAL
    depends on X86_CMPXCHG64 || 64BIT

If i'm not wrong X86_CMPXCHG64 depends on CONFIG_X86_PAE which depends on=20
HIGHMEM64 and again if i'm not wrong this means distributions who wants to=
=20
provide KVM must enable CONFIG_X86_PAE and CONFIG_HIGHMEM64G from now on?

Is this intentional or this is here because of an assumption like "processo=
rs=20
supports virtualization already provides PAE", could you please enlighten m=
e?

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart296178828.qKOvTYKK74
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGnQzMy7E6i0LKo6YRAl1mAKCi5iaVsF81TuMhj2/QaeN85U3hOACfd10B
8+dP91p8Mq6KuE8N1mQ7Cac=
=MC50
-----END PGP SIGNATURE-----

--nextPart296178828.qKOvTYKK74--
