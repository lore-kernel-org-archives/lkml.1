Return-Path: <linux-kernel-owner+w=401wt.eu-S933028AbXA2BJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028AbXA2BJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 20:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933030AbXA2BJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 20:09:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33395 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028AbXA2BJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 20:09:26 -0500
Subject: Re: lockmeter
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070128170407.GA1526@infradead.org>
References: <20070128115118.837777000@programming.kicks-ass.net>
	 <20070128144325.GB16552@infradead.org> <20070128152404.GB9196@elte.hu>
	 <45BCD4C9.2030302@mbligh.org>  <20070128170407.GA1526@infradead.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 29 Jan 2007 09:08:56 +0800
Message-Id: <1170032936.3054.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-01-28 at 17:04 +0000, Christoph Hellwig wrote:
> On Sun, Jan 28, 2007 at 08:52:25AM -0800, Martin J. Bligh wrote:
> > Mmm. not wholly convinced that's true. Whilst i don't have lockmeter
> > stats to hand, the heavy time in __d_lookup seems to indicate we may
> > still have a problem to me. I guess we could move the spinlocks out
> > of line again to test this fairly easily (or get lockmeter upstream).
> 
> We definitly should get lockmeter in.  Does anyone volunteer for doing
> the cleanup and merged?

specifically; implementing it on top of lockdep should be very lean and
simple...


