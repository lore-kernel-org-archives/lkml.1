Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZCXGH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZCXGH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 02:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbZCXGHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 02:07:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32973 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbZCXGHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 02:07:10 -0400
Date: Tue, 24 Mar 2009 17:07:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/4] Add support for compiling with -ffunction-sections
 -fdata-sections
Message-Id: <20090324170700.6029f6ce.sfr@canb.auug.org.au>
In-Reply-To: <1237872525-31014-1-git-send-email-tabbott@mit.edu>
References: <1237872525-31014-1-git-send-email-tabbott@mit.edu>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Mar_2009_17_07_00_+1100_iG.AUBB3e3ev1n.c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Mar_2009_17_07_00_+1100_iG.AUBB3e3ev1n.c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tim,

On Tue, 24 Mar 2009 01:28:41 -0400 Tim Abbott <tabbott@MIT.EDU> wrote:
>
> I'd like to see this patch series merged for 2.6.30.  It applies on
> top of your current master (aka v2.6.29).  Patch 1/4 would benefit
> from special treatment during the merge window, since it makes many
> small changes in lots of files, and thus is likely to conflict with
> other changes; the other patches are fairly small.

Indeed.  I just did a merge of your changes with next-20090323 and it
conflicted with changes in 10 files across 4 architectures.  There has
been work on several areas that you are changing here (some of which will
make your life easier - like the percpu changes).  I suspect that at
least some of patch 1/4 could have bee split out and sent to the
appropriate maintainers.

As it is, It looks like this will need to be rebased on top of (say)
2.6.30-rc1 (at least) in order not to inflict too much pain on others.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Mar_2009_17_07_00_+1100_iG.AUBB3e3ev1n.c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknIeIQACgkQjjKRsyhoI8z56QCgv9pdzXREe8/9vuJh2BnKWuv/
ZEMAni/uHitdQZfKxqCXACCW+EEvbzE0
=uEaT
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Mar_2009_17_07_00_+1100_iG.AUBB3e3ev1n.c--
