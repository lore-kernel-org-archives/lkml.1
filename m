Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbXA1PWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbXA1PWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932666AbXA1PWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:22:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33601 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbXA1PWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:22:39 -0500
Date: Sun, 28 Jan 2007 16:21:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] fs: break the file_list_lock for sb->s_files
Message-ID: <20070128152106.GA9196@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120510.090289000@programming.kicks-ass.net> <20070128144358.GC16552@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128144358.GC16552@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4861]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Jan 28, 2007 at 12:51:22PM +0100, Peter Zijlstra wrote:
> > Break the protection of sb->s_files out from under the global file_list_lock.
> > 
> > sb->s_files is converted to a lock_list. furthermore to prevent the 
> > lock_list_head of getting too contended with concurrent add 
> > operations the add is buffered in per cpu filevecs.
> 
> NACK.  Please don't start using lockdep internals in core code.

what do you mean by that?

	Ingo
