Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZEXTmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZEXTmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 15:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZEXTmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 15:42:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39438 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZEXTmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 15:42:38 -0400
Date: Sun, 24 May 2009 21:42:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: James Morris <jmorris@namei.org>, Theodore Tso <tytso@mit.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>,
       John Gilmore <gnu@toad.com>, pavel@ucw.cz
Subject: Re: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090524194231.GB1337@ucw.cz>
References: <4A03B9C3.9090607@intel.com> <20090512210154.GC23773@mit.edu> <alpine.LRH.2.00.0905151006020.5527@tundra.namei.org> <4F65016F6CB04E49BFFA15D4F7B798D99B4752F3@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D99B4752F3@orsmsx506.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >   I'd prefer discussion to be public, so I don't mind leaving more
> >   detailed discussion to that.
> >
> >   There has been considerable discussion on the issue, following Linus'
> >   statement (which I'm sure you're aware of):
> >
> >   http://marc.info/?l=linux-kernel&m=105115686114064&w=2
> >
> >   My position is similar -- people can decide for themselves whether they
> >   want to use DRM technology.  I'm also confident that technical measures
> >   taken to prevent real freedom will always be broken (when have they ever
> >   not been?)

Linus says he hates drm but does not want to stop it through legal
means, because its impossible. Does that mean we should merge any
random drm crap? I hope not.

> >   I also feel there may be genuinely useful applications of some of the
> >   technology (e.g. sealing disk encryption keys in the TPM a la
> >   BitLocker).
> >
> > I'm fairly neutral on the technology itself and feel that "market
> > pressure" from users as well as local regulatory policy (e.g. anti-trust
> > laws) should determine how the technology is used, rather than the views
> > of a few kernel hackers.

So some of the technology is useful -> we merge all of it?

> For a balanced view on Trusted Computing, people should also read
> David Safford's (IBM) rebuttal whitepaper at:
> http://www.research.ibm.com/gsal/tcpa/tcpa_rebuttal.pdf.

Sorry, but that article is full of hype, nothing balanced on it. Plus
it speaks about different technology. Plus it is intentionally
misleading.

>Technology (Intel(R) TXT).  Any technology can be used for good or
>bad, but Intel has tried to ensure that users have control of TXT.

I don't see where you got that nonsense.

Try using atomic bomb for something good. Then try to use tv remote
control for something bad.

TXT was specifically designed to enable atomic bombs^W^W drm, and I
see no other reasonable use.
 
> I would also encourage those who are concerned about these patches
> to look at the Linux code and tboot code to satisfy themselves that
> it is providing exactly what we have claimed.

I certainly hope booting secure sandbox is root-only operation... is
it?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
