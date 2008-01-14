Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYANIjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYANIjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYANIj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:39:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48752 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYANIj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:39:26 -0500
Date: Mon, 14 Jan 2008 08:39:01 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, David Dillow <dillowda@ornl.gov>,
       Guillaume Chazarain <guichaz@yahoo.fr>, linux-kernel@vger.kernel.org,
       linux-btrace@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] block: fix blktrace timestamps
Message-ID: <20080114083901.GA17897@infradead.org>
References: <20080111090723.GI6258@kernel.dk> <20080111092334.GA8143@elte.hu> <20080111092513.GO6258@kernel.dk> <20080111094205.GE8143@elte.hu> <20080111095654.GR6258@kernel.dk> <20080111102953.GA27223@elte.hu> <20080111122802.GT6258@kernel.dk> <20080111132106.GA16496@elte.hu> <20080111171855.GX6258@kernel.dk> <20080114075114.GA13195@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114075114.GA13195@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Folks, this is getting a little silly.

Even if CONFIG_NO_HZ is new this is a an important regression, and
yes we should avoid regressions wherever we can, and for such a quite
important feature we should fix it.  On the other hand blktrace is using
the wrong interface, and it has been told multiple times on lkml that
sched_clock() should never ever be used outside the scheduler.  So the
burden to fix this regression lies on the shoulders of the blktrace
maintainer.

No need for silly name calling here.

