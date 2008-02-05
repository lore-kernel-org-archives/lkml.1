Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbYBETtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbYBETtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYBETs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:48:56 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45711 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYBETsz (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:48:55 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1
In-Reply-To: Your message of "Tue, 05 Feb 2008 09:01:24 PST."
             <47A89664.8020407@linux.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <10779.1202230436@turing-police.cc.vt.edu>
            <47A89664.8020407@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1202240894_3253P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Feb 2008 14:48:14 -0500
Message-ID: <3289.1202240894@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1202240894_3253P
Content-Type: text/plain; charset=us-ascii

On Tue, 05 Feb 2008 09:01:24 PST, Arjan van de Ven said:
> Valdis.Kletnieks@vt.edu wrote:
> > On Sun, 03 Feb 2008 17:16:34 PST, Andrew Morton said:
> >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/
> > 
> > Builds, boots, mostly seems to run for limited testing.
> > 
> > One note - the following commit(s) (and related CPA reworking) broke the NVidia
> > binary driver (which is OK, I can fix *that* part).  But can somebody explain
> > if this should have seen a trip through the -mm tree before it hit mainstream?
> > I didn't see these in 24-rc8-mm1:
> 
> well that depends on which -mm you tried; I'm sure the mm kernel of the day had it for a while.

I looked around on www.kernel.org, and I found this directory:

http://www.kernel.org/pub/linux/kernel/people/akpm/mm/ but the most recent is:

broken-out-2007-11-20-01-45.tar.bz2      20-Nov-2007 09:45  3.4M

24-rc8-mm1 came out on Jan 17, only a week before 2.6.24 came out and the
merge window opened.  Since this stuff wasn't in there in rc8-mm1, but
did go into Linus's tree on Jan 30, it had at best 2 weeks for testing by
whoever pulled the git-x86 tree in that timespan...

> I don't think it's a realistic expectation to delay every bugfix and arch patch until Andrew
> gets around to releasing an -mm, not do I see the point of that, what would have been different?

A bugfix?

commit 9af993a92623e022c176459fa6607a564b9a7eaf
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jan 30 13:34:09 2008 +0100

    x86: make ioremap() UC by default

    Yes! A mere 120 c_p_a() fixing and rewriting patches later,
    we are now confident that we can enable UC by default for
    ioremap(), on x86 too.

That's one hell of a patch series for a "bugfix" that goes straight-to-mainline.

--==_Exmh_1202240894_3253P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHqL1+cC3lWbTT17ARApTnAJ9phHoCxrlFzKPM4WHshahz7hXa/ACgttvI
KTP/GX+wU4M0qV71Z8VJ66M=
=wwk6
-----END PGP SIGNATURE-----

--==_Exmh_1202240894_3253P--
