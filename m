Return-Path: <linux-kernel-owner+w=401wt.eu-S932654AbXA1Oju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbXA1Oju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 09:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932658AbXA1Oju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 09:39:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32941 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654AbXA1Ojr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 09:39:47 -0500
Date: Sun, 28 Jan 2007 14:39:41 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070128143941.GA16552@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120509.719287000@programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128120509.719287000@programming.kicks-ass.net>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 12:51:21PM +0100, Peter Zijlstra wrote:
> This barrier thing is constructed so that it will not write in the sync()
> condition (the hot path) when there are no active lock sections; thus avoiding
> cacheline bouncing. -- I'm just not sure how this will work out in relation to
> PI. We might track those in the barrier scope and boost those by the max prio
> of the blockers.

Is this really needed?  We seem to grow new funky locking algorithms
exponentially, while people already have a hard time understanding
the existing ones.

