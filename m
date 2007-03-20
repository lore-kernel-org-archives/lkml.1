Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbXCTUvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbXCTUvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXCTUvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:51:00 -0400
Received: from ns2.suse.de ([195.135.220.15]:51235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbXCTUu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:50:59 -0400
Date: Tue, 20 Mar 2007 22:49:45 +0100
From: Andi Kleen <ak@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       jeremy@goop.org, xen-devel@lists.xensource.com, netdev@vger.kernel.org,
       mingo@elte.hu, jbeulich@novell.com,
       virtualization@lists.linux-foundation.org, chrisw@sous-sol.org,
       virtualization@lists.osdl.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, anthony@codemonkey.ws,
       akpm@linux-foundation.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops callsites to make them patchable
Message-ID: <20070320214945.GG4286@bingen.suse.de>
References: <200703201428.50564.ak@suse.de> <m1ircvswzz.fsf@ebiederm.dsl.xmission.com> <20070320174159.GA4286@bingen.suse.de> <Pine.LNX.4.64.0703200947501.6730@woody.linux-foundation.org> <20070320180359.GB4286@bingen.suse.de> <Pine.LNX.4.64.0703201022040.6730@woody.linux-foundation.org> <20070320192118.GD4286@bingen.suse.de> <Pine.LNX.4.64.0703201145570.6730@woody.linux-foundation.org> <20070320202352.GF4286@bingen.suse.de> <20070320213918.116862be@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320213918.116862be@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 09:39:18PM +0000, Alan Cox wrote:
> > > Because that's really the issue: do you want a "pretty" backtrace, or do 
> > > you want one that is rock solid but has some crud in it.
> > 
> > I just want an as exact backtrace as possible. I also think
> > that we can make the unwinder robust enough.
> 
> Any reason you can't put the exact back trace in "[xxx]" and the ones we
> see on the stack which dont look like call trace as ?xxx? It makes the
> code a bit trickier but we depend on the quality of traces

Linus is worried about the unwinder crashing -- that wouldn't help with that.

What the (now out of tree) unwinder does is to check if it finishes
the trace and if not fall back to the old unwinder.

-Andi
