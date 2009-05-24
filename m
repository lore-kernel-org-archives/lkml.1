Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbZEXTm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbZEXTm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 15:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZEXTms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 15:42:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39468 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbZEXTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 15:42:47 -0400
Date: Sun, 24 May 2009 21:42:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, "Cihula, Joseph" <joseph.cihula@intel.com>,
       James Morris <jmorris@namei.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>,
       John Gilmore <gnu@toad.com>
Subject: Re: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090524194245.GC1337@ucw.cz>
References: <4A03B9C3.9090607@intel.com> <20090512210154.GC23773@mit.edu> <alpine.LRH.2.00.0905151006020.5527@tundra.namei.org> <4F65016F6CB04E49BFFA15D4F7B798D99B4752F3@orsmsx506.amr.corp.intel.com> <20090515120748.GF6816@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515120748.GF6816@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> With TXT, however, all of these problems go away.  What you end up
> booting is completely under "Circit City's DIVX's" control, and may
> include a miniature Windows environment running in the trusted
> environment; it could then take over a portion of the screen for the
> video output, and the hardware would have special features set up to
> prevent the host OS from having any access to the video output of the
> movie player running in the TXT environment.  (This was how Intel
> presented the LaGrande technology to the Kernel Summit several years
> ago, and I assume the capabilities of TXT hasn't change significantly
> since then.)

How does this interact with keyboard handling?

> Essentially, it's hard for me to think up situations where the TCPA
> chip would not be sufficient in terms of being a solution to a
> security problem that has the user's best interests at heart, rather
> than that of Hollywood, and where TXT would be a such a solution.
> Medical records are perhaps the best example I can come up with; and
> maybe some kind of bank security system where you're only allowed to
> engage in on-line banking if you run a bank-supplied application in
> the TXT environment.  However, it's hard for me to believe banks and
> hospitals will invest in solutions that implement these sorts of
> benign solutions, and it's all too easy for me to believe that
> Hollywood will invest in these sorts of solutions.

I suspect it does not 'protect' keyboard at all, meaning it is only
useful for drm.
> The bottom line is it this is a social problem, not a technical
> problem, and probably needs to be solved by social means (i.e., an
> FSF-led boycott).  But from a technical point of view, I would be
> shocked if the first major user of the TXT technology *wasn't* to
> provide DRM enforcement of one kind or another.

I see not merging / dropping changes only useful for drm from linux
kernelas a valid 'social means'...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
