Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbXGCFUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbXGCFUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXGCFUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:20:33 -0400
Received: from mx10.go2.pl ([193.17.41.74]:39754 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751650AbXGCFUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:20:32 -0400
Date: Tue, 3 Jul 2007 07:28:56 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] rename cancel_rearming_delayed_work() to cancel_delayed_work_sync()
Message-ID: <20070703052856.GA1657@ff.dom.local>
References: <20070701153629.GA105@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701153629.GA105@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 07:36:29PM +0400, Oleg Nesterov wrote:
> Imho, the current naming of cancel_xxx workqueue functions is very confusing.
> 
> 	cancel_delayed_work()
> 	cancel_rearming_delayed_work()
> 	cancel_rearming_delayed_workqueue()	// obsolete
> 
> 	cancel_work_sync()
> 
> This looks as if the first 2 functions differ in "type" of their argument which
> is not true any longer, nowadays the difference is the behaviour.
> 
> The semantics of cancel_rearming_delayed_work(dwork) was changed significantly,
> it doesn't require that dwork rearms itself, and cancels dwork synchronously.
> 
> Rename it to cancel_delayed_work_sync(). This matches cancel_delayed_work() and
> cancel_work_sync(). Re-create cancel_rearming_delayed_work() as a simple inline
> obsolete wrapper, like cancel_rearming_delayed_workqueue().
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Jarek Poplawski <jarkao2@o2.pl>
