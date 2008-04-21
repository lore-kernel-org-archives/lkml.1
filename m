Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYDUFyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYDUFyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 01:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYDUFy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 01:54:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59494 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbYDUFy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 01:54:28 -0400
Date: Sun, 20 Apr 2008 22:53:54 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420225354.08b1d096@laptopd505.fenrus.org>
In-Reply-To: <87prsk86d5.fsf@basil.nowhere.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080420104444.GI1595@cs181133002.pp.htv.fi>
	<87y778aezh.fsf@basil.nowhere.org>
	<200804201144.33308.dhazelton@enter.net>
	<480B7CB2.3080002@firstfloor.org>
	<20080420114845.77bf3fed@laptopd505.fenrus.org>
	<480BA12A.4000307@firstfloor.org>
	<20080420153318.553e5d2d@laptopd505.fenrus.org>
	<87prsk86d5.fsf@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 01:16:22 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> >
> > it is you who keeps putting up the 50k argument.
> 
> See the links I posted and quote in an earlier message up the thread
> if you don't remember what you wrote yourself.
> 
> I originally only hold up the fragmentation argument (or rather only
> argued against it), until I was corrected by both Ingo and you in the
> earlier thread and you both insisted that 50k threads were the real
> reason'd'etre for 4k stacks.  
> 
> You're saying that was wrong and the fragmentation issue was really
> the real reason for 4k stacks? If both you and Ingo can agree on that
> I would be happy to forget the 50k threads :)

I already corrected you misquoting/misunderstanding me; should I do this again?

> 
> > What I'm talking about is in the 10k to 20k range; and that is
> > actual workloads by real customers.
> 
> On a 32bit kernel? 
> 
> My estimate is that you need around 32k for a functional blocked
> thread in a network server (8k + 2*4k for poll with large fd table
> and wait queues + some pinned dentries and inodes + misc other
> stuff). With 20k you're 625MB into your lowmem which leaves about
> 200MB left on a 3:1 system with 16GB (and ~128MB mem_map).  That
> might work for some time, but I expect it will fall over at some
> point because there is just too much pinned lowmem and not enough
> left for other stuff (like networking buffers etc.) 
> 
> 10k sounds more doable. But again do 4k more or less make 
> a big difference with the other thread overhead? I don't think so.

no but the other ones are order 0..

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
