Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbZEXVlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbZEXVlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 17:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZEXVl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 17:41:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZEXVl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 17:41:27 -0400
Date: Sun, 24 May 2009 17:41:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] ftrace: Add task_comm support for trace_event
Message-ID: <20090524214125.GA10195@infradead.org>
References: <20090521141813.123165156@goodmis.org> <20090521141914.208848802@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090521141914.208848802@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 10:18:14AM -0400, Steven Rostedt wrote:
> From: Zhaolei <zhaolei@cn.fujitsu.com>
> 
> If we use trace_event alone(without function trace, .etc),
> it can't output enough task command information.

For some reason I still only see the process name sometimes but not
always.  It is more likely to appear for later entries than earlier
ones (and no, this is not an IRQ context problem as this is with
my work in progress XFS trace events, and XFS runs no major piece of
code in IRQ context)
