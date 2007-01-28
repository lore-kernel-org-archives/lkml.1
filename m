Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbXA1On2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbXA1On2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 09:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932737AbXA1On2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 09:43:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33699 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbXA1On1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 09:43:27 -0500
Date: Sun, 28 Jan 2007 14:43:25 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/7] breaking the global file_list_lock
Message-ID: <20070128144325.GB16552@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128115118.837777000@programming.kicks-ass.net>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 12:51:18PM +0100, Peter Zijlstra wrote:
> This patch-set breaks up the global file_list_lock which was found to be a
> severe contention point under basically any filesystem intensive workload.

Benchmarks, please.  Where exactly do you see contention for this?


filesystem intensive workload apparently means namespace operation heavy
workload, right?  The biggest bottleneck I've seen with those is dcache lock.

Even if this is becoming a real problem there must be simpler ways to fix
this than introducing various new locking primitives and all kinds of
complexity.

