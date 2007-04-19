Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbXDSWso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbXDSWso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbXDSWso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:48:44 -0400
Received: from mail23.syd.optusnet.com.au ([211.29.133.164]:47859 "EHLO
	mail23.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754284AbXDSWsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:48:43 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Renice X for cpu schedulers
Date: Fri, 20 Apr 2007 08:47:29 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070417062621.GL2986@holomorphy.com> <200704192159.35546.kernel@kolivas.org> <200704191416.14374.gene.heskett@gmail.com>
In-Reply-To: <200704191416.14374.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704200847.30516.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007 04:16, Gene Heskett wrote:
> On Thursday 19 April 2007, Con Kolivas wrote:
>
> [and I snipped a good overview]
>
> >So yes go ahead and think up great ideas for other ways of metering out
> > cpu bandwidth for different purposes, but for X, given the absurd
> > simplicity of renicing, why keep fighting it? Again I reiterate that most
> > users of SD have not found the need to renice X anyway except if they
> > stick to old habits of make -j4 on uniprocessor and the like, and I
> > expect that those on CFS and Nicksched would also have similar
> > experiences.
>
> FWIW folks, I have never touched x's niceness, its running at the default
> -1 for all of my so-called 'tests', and I have another set to be rebooted
> to right now.  And yes, my kernel makeit script uses -j4 by default, and
> has used -j8 just for effects, which weren't all that different from what I
> expected in 'abusing' a UP system that way.  The system DID remain usable,
> not snappy, but usable.

Gene, you're agreeing with me. You've shown that you're very happy with a fair 
distribution of cpu and leaving X at nice 0.
>
> Having tried re-nicing X a while back, and having the rest of the system
> suffer in quite obvious ways for even 1 + or - from its default felt pretty
> bad from this users perspective.
>
> It is my considered opinion (yeah I know, I'm just a leaf in the hurricane
> of this list) that if X has to be re-niced from the 1 point advantage its
> had for ages, then something is basicly wrong with the overall scheduling,
> cpu or i/o, or both in combination.  FWIW I'm using cfq for i/o.

It's those who want X to have an unfair advantage that want it to do 
something "special". Your agreement that it works fine at nice 0 shows you 
don't want it to have an unfair advantage. Others who want it to have an 
unfair advantage _can_ renice it if they desire. But if the cpu scheduler 
gives X an unfair advantage within the kernel by default then you have _no_ 
choice. If you leave the choice up to userspace (renice or not) then both 
parties get their way. If you put it into the kernel only one party wins and 
there is no way for the Genes (and Cons) of this world to get it back.

Your opinion is as valuable as eveyone else's Gene. It is hard to get people 
to speak on as frightening a playground as the linux kernel mailing list so 
please do. 

-- 
-ck
