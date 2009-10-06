Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZJFPVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZJFPVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbZJFPVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:21:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38768 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbZJFPVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:21:43 -0400
Date: Tue, 6 Oct 2009 11:21:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH 2/3] perf trace: Update eval_flag() flags array to
	match interrupt.h
Message-ID: <20091006152106.GA6490@infradead.org>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com> <1254808849-7829-3-git-send-email-tzanussi@gmail.com> <20091006132732.GA14978@infradead.org> <20091006151858.GB5152@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006151858.GB5152@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 05:19:00PM +0200, Frederic Weisbecker wrote:
> Yeah. We may want to do that by including trace/events/irq.h
> and then use the show_softirq_name() macro defined there.
> 
> The rest of the header can be wrapped through no-op macros and
> stub includes.

No, not at all.  Performance tracing tools really should not be
dependent on the kernel source.  This kind of creep is exactly what I
feared from putting the perf source in the kernel tree.

