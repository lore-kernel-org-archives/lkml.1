Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbYLNBC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbYLNBC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 20:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYLNBCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 20:02:49 -0500
Received: from ozlabs.org ([203.10.76.45]:54079 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbYLNBCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 20:02:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18756.23327.478759.5970@cargo.ozlabs.ibm.com>
Date: Sun, 14 Dec 2008 12:02:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@gmail.com, Vince Weaver <vince@deater.net>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
In-Reply-To: <1229167048.13566.119.camel@twins>
References: <20081211155230.GA4230@elte.hu>
	<Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	<1229070345.12883.12.camel@twins>
	<7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
	<1229073834.12883.41.camel@twins>
	<7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>
	<1229167048.13566.119.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> On Fri, 2008-12-12 at 18:42 +0100, stephane eranian wrote:
> > In fact, I know tools which do not even need a library. 
> 
> By your own saying, the problem solved by libperfmon is a hard problem
> (and I fully understand that).
> 
> Now you say there is software out there that doesn't use libperfmon,
> that means they'll have to duplicate that functionality.
> 
> And only commercial software has a clear gain by wastefully duplicating
> that effort. This means there is an active commercial interest to not
> make perfmon the best technical solution there is, which is contrary to
> the very thing Linux is about.
> 
> What is worse, you defend that:
> 
> > Go ask end-users what they think of that?
> > 
> > You don't even need a library. All of this could be integrated into the tool.
> > New processor, just go download the updated version of the tool.
> 
> No! what people want is their problem fixed - no matter how. That is one
> of the powers of FOSS, you can fix your problems in any way suitable.
> 
> Would it not be much better if those folks duped into using a binary
> only product only had to upgrade their FOSS kernel, instead of possibly
> forking over more $$$ for an upgrade?
> 
> You have just irrevocably proven to me this needs to go into the kernel,
> as the design of perfmon is little more than a GPL circumvention device
> - independent of whether you are aware of that or not.

I'm sorry, but that is a pretty silly argument.

By that logic, the kernel module loader should include an in-kernel
copy of gcc and binutils, and the fact that it doesn't proves that the
module loader is little more than a GPL circumvention device -
independent of whether you are aware of that or not.  8-)

Paul.
