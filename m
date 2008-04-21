Return-Path: <linux-kernel-owner+w=401wt.eu-S1763536AbYDUQdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763536AbYDUQdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYDUQdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:33:24 -0400
Received: from outbound-mail-32.bluehost.com ([69.89.18.152]:55142 "HELO
	outbound-mail-32.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760192AbYDUQdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:33:23 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI MAINTAINER change
Date: Mon, 21 Apr 2008 09:28:28 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080421062139.GA4901@suse.de> <alpine.LFD.1.10.0804210914030.2779@woody.linux-foundation.org> <20080421162258.GA13319@elte.hu>
In-Reply-To: <20080421162258.GA13319@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804210928.28722.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2008 9:22 am Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Mon, 21 Apr 2008, Jesse Barnes wrote:
> > > And now I get to figure out just how much trouble I've gotten myself
> > > into...
> >
> > Mwhahahaaa! Sucker. You'll find out.
> >
> > The good news is that most of the time, the PCI code works fine. The
> > bad news is that when it doesn't work, it's usually due to something
> > *really* odd, like some magic motherboard device that has magic
> > resources that aren't part of the standard PCI resource set and that
> > clash with some of our resource allocation.
> >
> > And they don't show up in the PnP lists because Windows never put
> > anything that could clash with them, so there was no reason for the
> > BIOS engineers to bother.
> >
> > IOW, it's usually almost totally undebuggable crud like "driver X
> > doesn't work on my machine", and then it turns out that it only
> > happens on that particular motherboard that is totally identical to
> > all other motherboards _except_ for that BIOS table not having the
> > right reserved IO regions.
> >
> > .. and then there's the pluggable PCI stuff, of course. I'm not sure
> > whether you took that over too. That's a whole different set of
> > issues.
>
> that reminds me of the observations about differences between Linux's
> and Windows's PCI resource allocation stategies, see the bugzilla entry
> from today below.

Yeah, address space allocation seems to be a perennial problem.  Fortunately 
it looks like I'll be able to get ahold of some nifty PCI test equipment so 
that I can reproduce weird topologies.  I'll take a look at the bug you 
mentioned too (gotta triage the rest of the PCI bugs anyway).

Fortunately, Kristen will still be taking care of hotplug issues.  Picking her 
brain about the weirdness she's seen there is on my TODO list.

Thanks,
Jesse
