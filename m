Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXA1Pqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXA1Pqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXA1Pqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:46:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXA1Pqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:46:47 -0500
Date: Sun, 28 Jan 2007 16:44:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] fs: break the file_list_lock for sb->s_files
Message-ID: <20070128154447.GA12811@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120510.090289000@programming.kicks-ass.net> <20070128144358.GC16552@infradead.org> <20070128152106.GA9196@elte.hu> <20070128153006.GB23410@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128153006.GB23410@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4643]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> > > NACK.  Please don't start using lockdep internals in core code.
> > 
> > what do you mean by that?
> 
> struct lock_list is an lockdep implementation detail and should not 
> leak out and be used anywhere else.  [...]

no, it is not. It is a new data type.

	Ingo
