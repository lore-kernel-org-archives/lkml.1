Return-Path: <linux-kernel-owner+w=401wt.eu-S1762478AbXGKLGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762478AbXGKLGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757811AbXGKLGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:06:32 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:49850 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbXGKLGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:06:31 -0400
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 07:06:31 EDT
Date: Wed, 11 Jul 2007 06:55:52 -0400
From: Stephen Frost <sfrost@snowman.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefano Rivoir <s.rivoir@gts.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
Message-ID: <20070711105552.GG4887@tamriel.snowman.net>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Stefano Rivoir <s.rivoir@gts.it>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org> <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org> <46947ADF.4080605@gts.it> <alpine.LFD.0.999.0707110002460.3412@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/aHqdxxe3Vo3WJ36"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707110002460.3412@woody.linux-foundation.org>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.21-2-amd64 (x86_64)
X-Uptime: 06:43:03 up 9 days, 20:08, 20 users,  load average: 0.02, 0.17,
	0.25
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/aHqdxxe3Vo3WJ36
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> I'm hoping your Debian/sid gcc version is some very experimental=20
> known-buggy one, and not something that people _expect_ to be solid and=
=20
> work well?

No such luck. :(  Debian's close to moving to gcc-4.2 as the default
compiler in sid.  We've rebuilt the archive a number of times (both
since the 4.2 release and during its development) using gcc-4.2 and
thought we'd identified most of the issues with it.

It clearly sounds like we need to open a high-severity bug on this issue
and track it down before we move to it as the default compiler.  I'll
start harassing the appropriate folks also.

Stefano, can you file that bug, including the config, dmesg, and
backtrace from gcc if you can get it?

	Thanks,

		Stephen

--/aHqdxxe3Vo3WJ36
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGlLc4rzgMPqB3kigRAgsPAJ9TdhUmEw5qJ+epEiV/YU2Zu9yDfACfV8ji
GH6PjNnpUyPeic54gQuaamM=
=Y43K
-----END PGP SIGNATURE-----

--/aHqdxxe3Vo3WJ36--
