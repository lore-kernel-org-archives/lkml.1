Return-Path: <linux-kernel-owner+w=401wt.eu-S1751240AbXBMKLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbXBMKLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbXBMKLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:11:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60222 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXBMKLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:11:07 -0500
Date: Tue, 13 Feb 2007 21:11:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [patch] (2nd try)  add epoll compat code to kernel/compat.c ...
Message-Id: <20070213211121.639b9a0f.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0702122321570.30273@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0702111615340.24568@alien.or.mcafeemobile.com>
	<20070213153525.c1440cff.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0702122321570.30273@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Feb_2007_21_11_21_+1100_GPVIPQ/CExjrjTro"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Feb_2007_21_11_21_+1100_GPVIPQ/CExjrjTro
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Mon, 12 Feb 2007 23:26:42 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
>
> ARM-OABI also defines them, dunno why. Rmk?

I suspect that OABI stands for old ABI and the alignment of 64 bit
quantities changed at some point.  I am pretty sure that arm is only
32bit, but I assume that they need backward compatibility for the old
ABI's alignment.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Feb_2007_21_11_21_+1100_GPVIPQ/CExjrjTro
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF0Y7YFdBgD/zoJvwRArT5AJ0Uoztu8mpVzTTUQ+3eavycE35VCgCeIe65
ghFZj1jaI1f0+K/k0OaOFzE=
=CFjX
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Feb_2007_21_11_21_+1100_GPVIPQ/CExjrjTro--
