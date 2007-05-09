Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbXEIQcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbXEIQcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbXEIQcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:32:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60921 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbXEIQcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:32:22 -0400
Date: Thu, 10 May 2007 02:32:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Declare {compat_}sys_utimensat
Message-Id: <20070510023221.92cefc44.sfr@canb.auug.org.au>
In-Reply-To: <200705091821.59412.arnd@arndb.de>
References: <20070509162357.65ab8868.sfr@canb.auug.org.au>
	<200705091821.59412.arnd@arndb.de>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_May_2007_02_32_21_+1000_r2daT+IAQC2kIIF8"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_May_2007_02_32_21_+1000_r2daT+IAQC2kIIF8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Wed, 9 May 2007 18:21:58 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> It seems bogus to declare compat_sys_futimesat in syscalls.h and
> compat_sys_utimensat in compat.h. Your patch is fine, since there
> are precedents for both, but maybe we should agree on one place and
> then move all of the compat_sys_ declarations there.

My preference is to split them like this so that the architectures that
don't need the compat infrastructure are not cluttered with it (if we
declare the compat routines in syscalls.h, then it should include
compat.h).

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_May_2007_02_32_21_+1000_r2daT+IAQC2kIIF8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGQfebFdBgD/zoJvwRAvWgAJ45hx0WnJX4UVNLjwayDfsw/OYJtwCeId95
T9bIdwQlcO7cONtY73QikE8=
=yBfc
-----END PGP SIGNATURE-----

--Signature=_Thu__10_May_2007_02_32_21_+1000_r2daT+IAQC2kIIF8--
