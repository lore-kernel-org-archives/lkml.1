Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbXA1PeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbXA1PeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXA1PeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:34:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51444 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbXA1PeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:34:18 -0500
Date: Sun, 28 Jan 2007 15:34:14 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070128153414.GD23410@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120509.719287000@programming.kicks-ass.net> <20070128143941.GA16552@infradead.org> <20070128152435.GC9196@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128152435.GC9196@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 04:24:35PM +0100, Ingo Molnar wrote:
> > > This barrier thing is constructed so that it will not write in the 
> > > sync() condition (the hot path) when there are no active lock 
> > > sections; thus avoiding cacheline bouncing. -- I'm just not sure how 
> > > this will work out in relation to PI. We might track those in the 
> > > barrier scope and boost those by the max prio of the blockers.
> > 
> > Is this really needed?  We seem to grow new funky locking algorithms 
> > exponentially, while people already have a hard time understanding the 
> > existing ones.
> 
> yes, it's needed.

Thanks for the wonderful and indepth explanation </sarcasm>
