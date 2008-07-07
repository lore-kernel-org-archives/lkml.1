Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbYGGAjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbYGGAjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 20:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbYGGAjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 20:39:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757354AbYGGAjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 20:39:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] coredump: introduce struct core_state.
In-Reply-To: Oleg Nesterov's message of  Monday, 16 June 2008 20:31:39 +0400 <20080616163139.GA21040@tv-sign.ru>
References: <20080616163139.GA21040@tv-sign.ru>
X-Zippy-Says: I am deeply CONCERNED and I want something GOOD for BREAKFAST!
Message-Id: <20080707003915.B8275154246@magilla.localdomain>
Date: Sun,  6 Jul 2008 17:39:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the slow reply.  These coredump patches all look fine to me.
But the prerequisite ptrace-related I'd like to kibitz about more first.
I think it might be easier to just put the coredump series first with
the simple s/core_waiters/core_state/ change in may_ptrace_stop().  Then
let the ptrace-related changes go on top of that after we finish hashing
them out.


Thanks,
Roland
