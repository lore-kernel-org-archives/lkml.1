Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYDTNju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYDTNju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 09:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYDTNjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 09:39:42 -0400
Received: from 1wt.eu ([62.212.114.60]:3236 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYDTNjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 09:39:42 -0400
Date: Sun, 20 Apr 2008 15:38:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: Mark Lord <lkml@rtr.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420133857.GB26536@1wt.eu>
References: <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B44C4.4060104@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480B44C4.4060104@rtr.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 09:27:32AM -0400, Mark Lord wrote:
> Willy Tarreau wrote:
> >
> >What would really help would be to have 8k stacks with the lower page
> >causing a fault and print a stack trace upon first access. That way,
> >the safe setting would still report us useful information without
> >putting users into trouble.
> ..
> 
> That's the best suggestion from this thread, by far!
> Can you produce a patch for 2.6.26 for this?

Unfortunately, I can't. I wouldn't know where to start from.

> Or perhaps someone else here, with the right code familiarity, could?

I hope so.

> Some sort of CONFIG option would likely be wanted to
> either enable/disable this feature, of course.

If we want to migrate to 4k sooner or later, this behaviour would not
need a config option, maybe just a /proc or /sys tunable to disable
the warning. Config would be either (4k + risk of crash) or (8k + warning).

The *real* issue is to decide whether we need/want 4k or not, because
I think we're still discussing the subject for no reason, as usual...

Willy

