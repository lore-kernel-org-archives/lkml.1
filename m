Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbYLLK76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbYLLK76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 05:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYLLK7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 05:59:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43799 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYLLK7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 05:59:48 -0500
Date: Fri, 12 Dec 2008 05:59:38 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
       Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
Message-ID: <20081212105938.GA2685@infradead.org>
References: <20081211155230.GA4230@elte.hu> <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy> <1229070345.12883.12.camel@twins> <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com> <1229073834.12883.41.camel@twins> <20081212102111.GE30490@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212102111.GE30490@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 11:21:11AM +0100, Robert Richter wrote:
> I agree with Stephane. There are already many different PMU
> descriptions depending on family, model and steppping and with *every*
> new cpu revision you will get one more update. Implementing this in
> the kernel would require kernel updates where otherwise no changes
> would be necessary.

Please stop the Bullshit.  You have to update _something_.  It makes a
lot of sense to update the thing you need to udpate anyway for new
hardware support, and not some piece of junk library like libperfmon.

> > Talking with my community hat on, that is an artificial problem created
> > by distributions, tell them to fix it.
> 
> It does not make sense to close the eyes to reality. There are systems
> where it is not possible to update the kernel frequently. Probably you
> have one running yourself.

Of course it is.  And on many of my systems it's much easier to update a
kernel than a library.  A kernel I can build myself, for libraries I'm
more or less reliant on the distro or hacking fugly rpm or debian
packagging bits.

Having HW support in the kernel is a lot easier than in weird libraries.
