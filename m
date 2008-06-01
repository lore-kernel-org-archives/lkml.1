Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYFAVJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYFAVJD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYFAVIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:08:54 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49185 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbYFAVIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:08:53 -0400
Date: Mon, 2 Jun 2008 00:08:29 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: binfmt_elf{,_fdpic}.c: don't abuse GFP_ATOMIC
Message-ID: <20080601200829.GA154@tv-sign.ru>
References: <20080601165506.GA8880@tv-sign.ru> <1212351678.6269.0.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212351678.6269.0.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Peter Zijlstra wrote:
>
> On Sun, 2008-06-01 at 20:55 +0400, Oleg Nesterov wrote:
> > kmalloc(GFP_ATOMIC) was needed because it was called under tasklist_lock.
> > The code was changed to use rcu_read_lock(), we can use GFP_KERNEL.
> 
> Classic RCU - still frequently used - disables preemption and thus does
> not allow us to use __GFP_WAIT.

Ah, I'm stupid, thanks!

please ignore this patch.

Oleg.

