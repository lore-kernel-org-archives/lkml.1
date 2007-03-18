Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbXCRE4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbXCRE4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 00:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXCRE4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 00:56:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43187 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbXCRE4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 00:56:15 -0400
Date: Sun, 18 Mar 2007 15:56:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 2/13] signal/timer/event fds v6 - signalfd core ...
Message-Id: <20070318155615.e2504034.sfr@canb.auug.org.au>
In-Reply-To: <200703172235.09227.arnd@arndb.de>
References: <send-serie.davidel@xmailserver.org.9367.1174004536.2>
	<200703172235.09227.arnd@arndb.de>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__18_Mar_2007_15_56_15_+1100_DRtzn=Up1fR4EoQc"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__18_Mar_2007_15_56_15_+1100_DRtzn=Up1fR4EoQc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Sat, 17 Mar 2007 22:35:08 +0100 Arnd Bergmann <arnd@arndb.de> wrote:
>
> sizeof(sigset_t) may be different for native and 32-bit compat code.
> It would be good if you could handle sizemask==4 && sizeof(sigset_t)==8
> in this code, so that there is no need for an extra compat_sys_signalfd
> function.

We still need a compat function to get the bit layout and the wordlayout
correct in the sigset.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__18_Mar_2007_15_56_15_+1100_DRtzn=Up1fR4EoQc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF/MZ1FdBgD/zoJvwRAlXgAKCHEqwh/qQCiOmSymaFjvhLePW8wwCfegFe
WTQ68x9bWv2GJb/Sa63IIQc=
=kPTj
-----END PGP SIGNATURE-----

--Signature=_Sun__18_Mar_2007_15_56_15_+1100_DRtzn=Up1fR4EoQc--
