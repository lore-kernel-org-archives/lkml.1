Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbXGCF3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbXGCF3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbXGCF3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:29:21 -0400
Received: from mx12.go2.pl ([193.17.41.142]:39910 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752030AbXGCF3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:29:20 -0400
Date: Tue, 3 Jul 2007 07:37:44 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] make cancel_xxx_work_sync() return a boolean
Message-ID: <20070703053744.GB1657@ff.dom.local>
References: <20070701153710.GA108@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701153710.GA108@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 07:37:10PM +0400, Oleg Nesterov wrote:
> Change cancel_work_sync() and cancel_delayed_work_sync() to return a boolean
> indicating whether the work was actually cancelled. A zero return value means
> that the work was not pending/queued.
> 
> Without that kind of change it is not possible to avoid flush_workqueue()
> sometimes, see the next patch as an example.
> 
> Also, this patch unifies both functions and kills the (unlikely) busy-wait loop.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Jarek Poplawski <jarkao2@o2.pl>

