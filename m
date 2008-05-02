Return-Path: <linux-kernel-owner+w=401wt.eu-S934710AbYEBM23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934710AbYEBM23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbYEBM2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:28:22 -0400
Received: from renko.ucs.ed.ac.uk ([129.215.13.3]:57137 "EHLO
	renko.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbYEBM2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:28:21 -0400
X-Greylist: delayed 2240 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 08:28:21 EDT
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Date: Fri, 2 May 2008 12:48:55 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Chris Knadle <Chris.Knadle@coredump.us>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, venkatesh.pallipadi@intel.com,
       davem@davemloft.net, trini@kernel.crashing.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080501235558.GA20637@orac.ofobscurity.com> <200805021055.10602.alistair@devzero.co.uk> <20080502104348.GC20741@uranus.ravnborg.org>
In-Reply-To: <20080502104348.GC20741@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021248.56797.alistair@devzero.co.uk>
X-Edinburgh-Scanned: at renko.ucs.ed.ac.uk
    with MIMEDefang 2.52, Sophie, Sophos Anti-Virus, Clam AntiVirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008 11:43:48 Sam Ravnborg wrote:
[snip]
> > > > It's __GNUC_PATCHLEVEL__, I believe.
> > > >
> > > > So yes, we can distinguish 4.1.2 (good, and very common) from
> > > > 4.1.{0,1} (bad, and rather uncommon).
> > > > And yes, considering that 4.1.1 (and even more so 4.1.0) should be
> > > > rare to begin with, I think it's better to just not support it.
> > > >
> > > >			Linus
> > >
> > >    Unfortunately Debian Stable (i.e. Etch), which is relatively popular
> > > for server use, is still using 4.1.1  :-(  (The current gcc package is
> > > gcc-4.1.1-21)
> > >
> > >    I have not looked to see if Debian Stable's gcc-4.1.1-21 has been
> > > patched for the currently discussed __weak bug.
> >
> > I checked and it has been patched in 4.1.1-21. This would make checking
> > for 4.1.1 via __GNUC_PATCHLEVEL__ potentially invalid, as patched distro
> > compilers may (and in this case do) have this fixed.
>
> Is it possible to cook up a small sample file we could build as part
> of the kernel build. If it fails => error out.
> If someone comes up with the code I shall try to integrate it
> in the build system.

The GCC PR has a test case for this regression which might be usable.

http://gcc.gnu.org/viewcvs/branches/gcc-4_1-branch/gcc/testsuite/gcc.dg/tree-ssa/pr27781.c?view=markup&pathrev=114852

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
