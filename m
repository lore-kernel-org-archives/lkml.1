Return-Path: <linux-kernel-owner+w=401wt.eu-S1765363AbYEAA1C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765363AbYEAA1C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:27:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbYEAA0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:26:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54486 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823AbYEAA0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:26:50 -0400
Date: Thu, 1 May 2008 10:26:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: postmaster@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.26-rc0
Message-Id: <20080501102641.b7970395.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.1.10.0804301153100.2980@woody.linux-foundation.org>
References: <200804301420.11696.lenb@kernel.org>
	<alpine.LFD.1.10.0804301153100.2980@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_May_2008_10_26_41_+1000_cousAr.6IDldLgrM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_May_2008_10_26_41_+1000_cousAr.6IDldLgrM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Apr 2008 11:55:57 -0700 (PDT) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> There were some (smaller) rejects in drivers/misc/intel_menlow.c due to=20
> two different versions of the same patch from Julia Lawall (again, the=20
> other came through Andrew), and I picked the one from Andrew because it=20
> had the later date. But again, you should double-check.

I reported these to Len yesterday at 14:13 (+1000) but hera and zeus1
rejected this email with "451 4.3.2 Please try again later" until 4:41
(+1000) this morning ... Does anyone know why?

In fact, even then the logs said:

May  1 04:41:17 chilli postfix/qmgr[25076]: BFB2F36800C: from=3D<sfr@canb.a=
uug.org
.au>, size=3D1742, nrcpt=3D2 (queue active)
May  1 04:41:19 chilli postfix/smtp[29167]: BFB2F36800C: host zeus1.kernel.=
org[2
04.152.191.4] said: 451 4.3.2 Please try again later (in reply to MAIL FROM=
 comm
and)
May  1 04:41:21 chilli postfix/smtp[29167]: BFB2F36800C: to=3D<lenb@kernel.=
org>, r
elay=3Dzeus2.kernel.org[204.152.191.36]:25, delay=3D52057, delays=3D52053/0=
.03/3.2/0.6
8, dsn=3D2.0.0, status=3Dsent (250 2.0.0 m3UIfK9Z027193 Message accepted fo=
r deliver
y)

And, as you can see, it was eventually delivered via zeus2.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_May_2008_10_26_41_+1000_cousAr.6IDldLgrM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIGQ5FTgG2atn1QN8RAt7zAKCFhhz/J3BagUT8CeK9WEIueXPoDACdFr1Y
nXSAv+PA3DIfBr5lBerSv1E=
=jKhE
-----END PGP SIGNATURE-----

--Signature=_Thu__1_May_2008_10_26_41_+1000_cousAr.6IDldLgrM--
