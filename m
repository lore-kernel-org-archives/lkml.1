Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbXEOK44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbXEOK44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 06:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXEOK4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 06:56:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47879 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbXEOK4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 06:56:49 -0400
Date: Tue, 15 May 2007 20:56:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Li Yang-r58472" <LeoLi@freescale.com>, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Linus <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] kbuild: Add "Section mismatch" warning whitelist
 for powerpc
Message-Id: <20070515205641.babf2ce9.sfr@canb.auug.org.au>
In-Reply-To: <a781481a0705150303y587ea18dt435f2fc45a671226@mail.gmail.com>
References: <a781481a0705141717v2669805aoa590bfd54da7856b@mail.gmail.com>
	<989B956029373F45A0B8AF0297081890B76040@zch01exm26.fsl.freescale.net>
	<a781481a0705150303y587ea18dt435f2fc45a671226@mail.gmail.com>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_May_2007_20_56_41_+1000_KCCcNGEX+NT1qPDQ"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_May_2007_20_56_41_+1000_KCCcNGEX+NT1qPDQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Tue, 15 May 2007 15:33:50 +0530 "Satyam Sharma" <satyam.sharma@gmail.com> wrote:
>
> But I have slightly different (reversed) semantics for __init_refok
> in mind. Basically, we use __init_refok to annotate _callees_
> and not _callers_. In short, __init_refok is a _type_ of __init
> section that other sections can freely reference to, without
> modpost complaining about this. [ had suggested this in some
> previous thread earlier ]

But lots of __init routines cannot be called from just anywhere, it is
the special circumstances of some of the callers that makes the call from
non-init to init ok.  So you need to mark the callers specially.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_May_2007_20_56_41_+1000_KCCcNGEX+NT1qPDQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGSZHuFdBgD/zoJvwRAm9ZAKCPs5nTNQB3wo4HpG1Xisex3MC5CQCfY06J
GyEQQOxNlO+iFBprPj0mwAM=
=qOd2
-----END PGP SIGNATURE-----

--Signature=_Tue__15_May_2007_20_56_41_+1000_KCCcNGEX+NT1qPDQ--
