Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbZEXRkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbZEXRkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 13:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbZEXRkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 13:40:10 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:36022 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbZEXRkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 13:40:10 -0400
Date: Mon, 25 May 2009 01:31:11 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090524173111.GD4586@prithivi.gnumonks.org>
References: <200905221139.26941.lkml@morethan.org> <4A188A48.5000208@zytor.com> <20090524064905.GH20452@prithivi.gnumonks.org> <200905240738.47090.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905240738.47090.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Sun, May 24, 2009 at 07:38:44AM -0500, Michael S. Zick wrote:
> > As far as I know, there really is no such documentation.. all documentation
> > that I've ever seen internally is electrical data sheets and high-level feature
> > set descriptiosn, CPUID, MSR and padlock.  There are no  actual x86 instruction
> > set documents... Centaur is < 100 people, they don't have the resources to work
> > on documents along the lines of what Intel has...
> 
> My background is in the electronic hardware end of things - -
> Is there someone I can contact for the existing documents -
> Even under NDA would be fine.

I have inquired right now.  The regular NDA process I would assume is probably
quite slow.  The CPU documentation is already on its track for becoming public
at some point (but very slooooow track), so I'll see what I can do and contact
you in private mail.

> For instance, the layout of the CPUID results - they don't
> currently seem to match what the marketing people claim is
> inside of the chips.  There are some "VIA specific" fields.

There's two versions of the C7-M, an 'A' model (90nm SOI) and a much more
recent 'D' model (90nm conventional process).   They CPUID values are 6-a and
6-d, respectively.  The cpu ID string of the former ones contains Esther,
the latter one contains C7-M  - but in fact any BIOS could override the cpu
ID string (not cpuid!) with whatever they want using a backdoor in some MSR.

> Could you also dig around for a tech manual on CN896 similar to
> the one (of two) CX700 manuals that are publicly posted?

I've asked about that.  The programming guides for chipsets are generally on
the 'open track', whereas the electrical data sheets with pinouts and timing
values are under NDA.

The CN896 was just already an "old" component when that new open-track policy
was introduced, and typically VIA is trying to focus on docs and drivers for 
new products, rather than old ones.  But I have asked if we can release the
CN896 programming manual public.

> Even under NDA is fine.

Well, I prefer to make sure that we have the neccessary information open.
NDA's are fine and well for the limited number of customers you have, but
makign NDA's with various individual programmers really is too painful,
there should be other ways...

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison
