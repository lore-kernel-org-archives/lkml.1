Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0BHR0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 12:26:10 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37370 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0BHR0I (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:26:08 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Thomas Renninger <trenn@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc6 - BUG at drivers/cpufreq/cpufreq.c:88
In-Reply-To: Your message of "Fri, 05 Feb 2010 10:26:32 +0100."
             <201002051026.33057.trenn@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <6843.1265299202@localhost>
            <201002051026.33057.trenn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1265649927_5191P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Feb 2010 12:25:27 -0500
Message-ID: <8111.1265649927@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1265649927_5191P
Content-Type: text/plain; charset=us-ascii

On Fri, 05 Feb 2010 10:26:32 +0100, Thomas Renninger said:
> On Thursday 04 February 2010 17:00:02 Valdis.Kletnieks@vt.edu wrote:
> > Hit this one again while setting up to bisect another issue.  I've verified
> > that the fix *is* someplace in 2.6.33-rc6-mmotm0201 (as that one lives at least
> > all the way to single-user mode), so I'm basically asking that somebody find
> > the commit that fixes it and make sure it gets into 2.6.33-final.  I'd offer
> > the commit number for the fix, but I'm hoping somebody recognizes it and pushes
> > it so I don't have bisect to find the fixing commit.
> > 
> > Thomas?  Did you have a fix for this that hasn't been pulled by Linus yet?
> The fix is to remove the patch.
> 
> > Refresher:  The bad commit was:
> > 
> > commit 46aeb7430f79cb4d03e17fedd6399884ab3aa697
> > Author: Thomas Renninger <trenn@suse.de>
> > Date:   Mon Dec 14 11:44:11 2009 +0100
> > 
> >     [CPUFREQ] Fix race in cpufreq_update_policy()
> This one never hit Linus tree?
> It was in -mm, but got reverted.
> 
> Did you bisect on another tree?

Good catch, Thomas.

Looks like a miscue on my part - although the timestamp on the vmlinuz in /boot
matched the one in arch/x86/boot/bzImage, the file size matched  the one left
at the end of that bisect from last time.  Looks like I managed to cd into the
wrong /usr/src/linux-* when I copied the bzImage to /boot.

"D'Oh!" - H. Simpson.

Sorry for the inconvenience.


--==_Exmh_1265649927_5191P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLcEkHcC3lWbTT17ARAmOpAKDM6IMcu5tK94UAsv3xH6Gy7rytxgCggT1H
8/Ke+hlXOA2qWd7JUJojJC0=
=N1nX
-----END PGP SIGNATURE-----

--==_Exmh_1265649927_5191P--
