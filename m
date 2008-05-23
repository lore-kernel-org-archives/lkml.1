Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYEWJMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYEWJMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYEWJMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:12:07 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36147 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbYEWJMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:12:06 -0400
Date: Fri, 23 May 2008 12:09:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Natalie Protasevich <protasnb@gmail.com>,
       Bosko Radivojevic <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Number of bugs - statistics
Message-ID: <20080523090940.GG2727@cs181133002.pp.htv.fi>
References: <d6c8ef150805220528w6c4911bfq2be92eaa487a0f3@mail.gmail.com> <20080522144114.GC27301@cs181133002.pp.htv.fi> <20080522075135.4933161c@infradead.org> <20080522155425.GA2727@cs181133002.pp.htv.fi> <32209efe0805220920h1a2a0089t82b0173bbe239137@mail.gmail.com> <20080522165008.GB2727@cs181133002.pp.htv.fi> <20080522151834.03f2790f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080522151834.03f2790f@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 03:18:34PM -0700, Arjan van de Ven wrote:
> On Thu, 22 May 2008 19:50:08 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > > by various criteria: ALSA bugs
> > > are numerous, which is not important for most enterprise server
> > > users who would completely disregard this category, whereas desktop
> > > users will probably concentrate on those more than any other.
> > 
> > The majority of machines running Linux most likely runs with ARM CPUs.
> 
> and on a 2.4 kernel,
>...

Do you have any serious numbers for that?

All the embedded stuff I've recently worked with had 2.6.2x kernels, 
and if you have good statistics how many percent of all ARM users and
in which areas still use kernel 2.4 I'd be very interested in them.

> > Show me any public source you want to use for getting serious data
> > for this area.
> 
> You know, and I hate to say this, I'm getting a bit tired of your
> attitude of just throwing up your arms at the problem and at the same
> time trying to discredit anything and anybody who tries to improve the
> situation. Really, it's not helping nor does it improve ANYTHING. 
> 
> I gave you real data before based on first hand experience from
> maintainers. We now have crash data, and we have data from every place
> in the kernel that dumps a backtrace. We track regressions and we can
> show that we attack the majority of those very agressively, and Linus
> has delayed releases for serious regressions. Just throwing your hands
> in the air and saying "it's hard don't even try and I don't want you to
> try" doesn't cut it.
> 
> Are we perfect? No. Can we do better? Absolutely. Should we try to do
> better? YES PLEASE. Lets get constructive and try to make things better.
> 
> In the past, a few simple things improved the situation, such as
> printk'ing the kernel version in the oops, as well as (longer back)
> kksymoops. Or think of things like lockdep, or the pagealloc-debug
> stuff. Going forward there are things we can do to improve things in the
> kernel, even if you don't have hardware. We need to make the kernel
> more selfdiagnosing. Detecting the problem, and if it's likely a
> driver/hw interaction bug, sticking in a WARN_ON(). That's the sort of
> thing even starting kernel developers can do to help improve the
> quality even wihtout hardware access, because it helps us improve the
> quality of bugreports, and it improves our ability to find patterns and
> group duplicates into a top 10. 
> 
> Adrian, how about working on that sort of thing rather than keep saying
> "impossible, we're doomed"... pretty please?

No disagreement that we can and should do much better on diagnosing and
fixing bugs (and I do appreciate your work in this area). And this is
neither impossible nor are we not doomed here.

But getting _statistics_ that would allow to reasonably express stuff 
like "stability of the kernel" in one number is nearly impossible: 
Including distribution bugs we are talking about a five digit number of 
open bug reports, and getting meaningful data from them is *ahem* hard.

And in case anyone says "not forwarded distribution bugs aren't our 
problem":
That's a nice example, since in this case a distribuion suddenly 
starting to agressively forwarding their bugs might contribute to
making the kernel better, but might also totally ruin the numbers in
any statistics.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

