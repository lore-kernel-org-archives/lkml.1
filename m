Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbXCRHf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbXCRHf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 03:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbXCRHf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 03:35:26 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:58369
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbXCRHfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 03:35:25 -0400
Date: Sun, 18 Mar 2007 00:35:00 -0700
To: Mike Galbraith <efault@gmx.de>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>, Avi Kivity <avi@argo.co.il>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: is RSDL an "unfair" scheduler too?
Message-ID: <20070318073500.GA14330@gnuppy.monkey.org>
References: <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru> <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu> <45FC525D.5000708@argo.co.il> <20070318012533.GB2986@holomorphy.com> <Pine.LNX.4.64.0703171830130.4964@woody.linux-foundation.org> <20070318052439.GT943@1wt.eu> <20070318060949.GA13583@gnuppy.monkey.org> <1174199822.8543.5.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174199822.8543.5.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 07:37:02AM +0100, Mike Galbraith wrote:
> On Sat, 2007-03-17 at 23:09 -0700, Bill Huey wrote:
> 
> > Like I've said in a previous email, SGI schedulers have an interactive
> > term in addition to the normal "nice" values. If RSDL ends up being too
> > rigid for desktop use, then this might be a good idea to explore in
> > addition to priority manipulation.
> 
> I've done that already (ain't perfect yet, maybe never be).  The hard
> part is making it automatic, and not ruining the good side of RSDL in
> the process.

I can't fully qualify what aspects of the X server that's creating this
problem. More experimentation is needed (various display drivers, etc...)
should be played with to see what kind of problematic situations arise.
It's a bit too new with too few users to know what are the specific
problems just yet. Your case is too sparse for it to be an completely
exhaustive exploration of what's failing with this scheduler.

There's a policy decision that needs to be made of whether adding another
term to the scheduler calcuation is blessed or not. My opinion is that
is should be. Meanwhile, we should experiment more with different
configurations.

bill

