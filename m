Return-Path: <linux-kernel-owner+w=401wt.eu-S941670AbXHJT4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941670AbXHJT4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965222AbXHJTzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:55:21 -0400
Received: from 1wt.eu ([62.212.114.60]:1286 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965221AbXHJTzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:55:18 -0400
Date: Fri, 10 Aug 2007 21:47:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Michael Chang <thenewme91@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070810194705.GH6002@1wt.eu>
References: <p73ps27npu0.fsf@bingen.suse.de> <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org> <20070801175004.GA17936@elte.hu> <Pine.LNX.4.64.0708011955430.1817@scrub.home> <20070801190556.GA1199@elte.hu> <Pine.LNX.4.64.0708100037460.1817@scrub.home> <20070810054948.GA5908@elte.hu> <Pine.LNX.4.64.0708101459530.1817@scrub.home> <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com> <Pine.LNX.4.64.0708101919270.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708101919270.1817@scrub.home>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 07:25:57PM +0200, Roman Zippel wrote:
> Hi,
> 
> On Fri, 10 Aug 2007, Michael Chang wrote:
> 
> > On 8/10/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> > > Is there any reason to believe my analysis is wrong?
> > 
> > Not yet, but if you give Ingo what he wants (as opposed to what you're
> > giving him) it'll be easier for him to answer what's going wrong, and
> > perhaps "fix" the problem to boot.
> > 
> > (The scripts gives info about CPU characteristics, interrupts,
> > modules, etc. -- you know, all those "unknown" variables.)
> 
> He already has most of this information and the trace shows _exactly_ 
> what's going on. All this information should be more than enough to allow 
> an initial judgement whether my analysis is correct.
> Also none of this information is needed to explain the CFS logic a little 
> more, which I'm still waiting for...

Roman,

fortunately all bug reporters are not like you. It's amazing how long
you can resist sending a simple bug report to a developer! Maybe you
consider that you need to fix the bug by yourself after you understand
the code, but if you systematically refuse to return the small information
Ingo asks you, we will have to wait for some more cooperative users to be
hit by the same bug when 2.6.23 is released, which is stupid.

I thought you could at least understand that one developer who is used
to read traces from the same tool every day will be far faster at decoding
a trace from the same tool than trying to figure out what your self-maid
dump means.

It's the exact same reason I ask for pcap files when people send me
outputs of tcpdumps without the information I *need*.

I you definitely do not want to cooperate, stop asking for a personal
explanation, and go figure by yourself how the code works. BTW, in the
trace you "kindly offered" in exchange for the cfs-debug-info dump,
you show several useful variables, but nothing says where they are
captured. And as you can see, they're changing. That's a fantastic
trace for a developer, really...

Please try to be a little bit more transparent if you really want the
bugs fixed, and don't behave as if you wanted this bug to survive
till -final.

Thanks,
Willy

