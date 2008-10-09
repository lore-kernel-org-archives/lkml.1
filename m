Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbYJIQwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbYJIQwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbYJIQwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:52:37 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52508 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752861AbYJIQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:52:36 -0400
Date: Thu, 9 Oct 2008 12:52:33 -0400
From: Theodore Tso <tytso@mit.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mingming Cao <cmm@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/42] percpu counter: clean up
	percpu_counter_sum_and_set()
Message-ID: <20081009165233.GH17512@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu> <1223525160-9887-2-git-send-email-tytso@mit.edu> <1223542372.7382.30.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223542372.7382.30.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 10:52:52AM +0200, Peter Zijlstra wrote:
> On Thu, 2008-10-09 at 00:05 -0400, Theodore Ts'o wrote:
> > From: Mingming Cao <cmm@us.ibm.com>
> > 
> > percpu_counter_sum_and_set() and percpu_counter_sum() is the same except
> > the former updates the global counter after accounting.  Since we are
> > taking the fbc->lock to calculate the precise value of the counter in
> > percpu_counter_sum() anyway, it should simply set fbc->count too, as the
> > percpu_counter_sum_and_set() does.
> > 
> > This patch merge these two interfaces into one.
> 
> I totally missed the patch introducing this _and_set() horror, but this
> does look like a good cleanup.

Note: this patch was in the -mm tree (Andrew signed off on it), but
given that a number of ext4 patches depend on it, we have a copy of it
in the ext4 tree.

						- Ted
