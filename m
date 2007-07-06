Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbXGFMwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbXGFMwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761989AbXGFMwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:52:21 -0400
Received: from mail.screens.ru ([213.234.233.54]:53577 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761858AbXGFMwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:52:20 -0400
Date: Fri, 6 Jul 2007 16:53:24 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2] workqueue: debug work related deadlocks with lockdep
Message-ID: <20070706125324.GA74@tv-sign.ru>
References: <20070705110744.564273000@sipsolutions.net> <20070705110820.622888000@sipsolutions.net> <20070705153648.GA236@tv-sign.ru> <1183718633.3818.96.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183718633.3818.96.camel@johannes.berg>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06, Johannes Berg wrote:
>
> On Thu, 2007-07-05 at 19:36 +0400, Oleg Nesterov wrote:
> 
> > So, __WORK_INITIALIZER() uses work_struct itself as a "struct lock_class_key" ?
> > How so?
> 
> Well, this is for work_structs that are static (not dynamically
> allocated.) struct lock_class_key is just a single byte because its
> whole purpose is to be a unique pointer, there's nothing actually in it.
> Hence, taking the address of the work struct (when it's statically
> allocated) is a unique pointer just as well.

Yes, got it, but forgot to reply to myself. But thanks for your confirmation
of my understanding.

I believe both patches are nice.

Oleg.

