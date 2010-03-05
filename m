Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0CEHx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:53:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab0CEHxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:53:25 -0500
Date: Fri, 5 Mar 2010 08:53:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "\"C. Bergstr?m\"" <cbergstrom@pathscale.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ben Skeggs <skeggsb@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.sf.net,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] drm request 3
Message-ID: <20100305075311.GD19703@elte.hu>
References: <20100304105624.70fe845e@jbarnes-piketon>
 <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
 <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
 <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
 <1267748927.3496.6.camel@nisroch>
 <20100305064955.GA6453@elte.hu>
 <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com>
 <4B90AFF3.3030100@pathscale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B90AFF3.3030100@pathscale.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* "C. Bergstr?m" <cbergstrom@pathscale.com> wrote:

> Pekka Enberg wrote:
> >On Fri, Mar 5, 2010 at 8:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >>The conclusion is crystal clear, breaking an ABI via a "flag day"
> >>cleanup/feature/etc is:
> >>
> >> - wrong
> >>
> >> - harmful
> >>
> >> - limits the developer base
> >>
> >> - limits the tester base
> >>
> >> - wastes time and effort. (fewer developers/testers means that while _this_
> >>  feature was easier to add, all your _future_ features will be a bit harder
> >>  to do. It compounds up.)
> >>
> >> - so it hurts even the very developer who is most convinced that this was the
> >>  right thing to do
> >>
> >>It's a bad technical decision throughout. It's masochistic and often suicidal
> >>to just about any project in essence. I've seen projects that did it once and
> >>died just due to that single act of stupidity. I've seen projects that have
> >>done it a few times and took the usage hit, limped along with the wounds and
> >>never grew to the size they could have achieved. I've seen projects that did
> >>it once, took the hit, learned from it and never did it again.
> >
> >Agreed. What bothers me in this discussion is that people keep
> >bringing up the fact that nouveau is mostly developed by volunteers
> >and thus it doesn't make sense to make sure it's backwards (or
> >forwards) compatible. But the way I see it, it's the complete
> >opposite. It's _more_ important to support ABIs for community-driven
> >efforts because you're relying on people who by definition don't have
> >time to waste. While the nouveau people might have good intentions,
> >I'm afraid they might be severely limiting their developer and tester
> >base because they're not focused on real world problems (like the ones
> >Linus is seeing).
> staging != stable
> 
> Nobody guaranteed a stable API for staging and in fact it was stated 
> previously it needed to be changed.  Please lets just get back to work and 
> stop declaring the sky is falling.

I dont think you understood the argument.

The (very simple) argument was: no matter how a project is developed, whether 
it's been freshly announced (not even in staging), in staging or been upstream 
for years, breaking ABIs is _technically wrong_.

No ifs and when. A released ABI that is in use cannot be so messy to make it 
worth breaking. You've got users. You've got developers. You've got yourself.

You can still phase it out gradually (and even do that quickly), one or two 
stable releases down the road you can even print out the final ABI removal 
patch on paper, make a bonfire out of it and jump on its ashes in joy, but if 
you are interested in running a successful OSS project then the current ABI is 
sacrosanct.

	Ingo
