Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbXKETPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbXKETPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbXKETPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:15:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:34888 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753680AbXKETPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:15:22 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/cThxPkn/c7gEJ4y7ryFLmZ3gljSuUiZO7bB0b4+
	socXtxKMgArw0s
Date: Mon, 5 Nov 2007 20:15:16 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: Re: oops in enqueue_entity with 2.6.24-rc1-g54866f03
Message-ID: <20071105191516.GC20465@alice>
References: <20071102123603.GA4988@alice> <1194266231.27652.437.camel@twins> <20071105124427.GA8765@alice> <1194266832.27652.439.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1194266832.27652.439.camel@twins>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.24-rc1 (x86_64)
X-Uptime: 20:14:46 up  8:15,  7 users,  load average: 0.07, 0.34, 0.46
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Mon, 2007-11-05 at 13:44 +0100, Eric Sesterhenn wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Fri, 2007-11-02 at 13:36 +0100, Eric Sesterhenn wrote:
> > > > hi,
> > > > 
> > > > I get the following crash with 2.6.24-rc1-g54866f03, the last version I
> > > > tested which booted fine was 2.6.24-rc1-gb1d08ac0
> > > > 
> > > 
> > > How reproducable is this?
> > 
> > happens every boot
> > 
> > > If its very much reproducable, could you git bisect it, as in between
> > > those commits you tested nothing much has changed, that is, nothing that
> > > stands out to me.
> > 
> > i did already bisect this but landed at a commit which wasnt the cause
> > (also failed when i reverted it), I am currently bisecting a second time with
> > -rc1 as the other starting point, because I am not sure how to make git
> > give me revision gb1d08ac0 again to test it another time (the binary i
> > have here boots fine)

hmm did another git bisect, which also gave a bogus commit, made a fresh
checkout into an empty dir and the current kernel boots fine, seems like
there was something wrong with my local sources.

Greetings, Eric
