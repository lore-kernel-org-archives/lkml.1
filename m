Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbYGQOWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbYGQOWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYGQOWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:22:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbYGQOWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:22:33 -0400
Date: Thu, 17 Jul 2008 10:21:48 -0400
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Eric Rannaud <eric.rannaud@gmail.com>, Chris Snook <csnook@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: madvise(2) MADV_SEQUENTIAL behavior
Message-ID: <20080717102148.6bc52e94@cuia.bos.redhat.com>
In-Reply-To: <200807171614.29594.nickpiggin@yahoo.com.au>
References: <1216163022.3443.156.camel@zenigma>
	<487E628A.3050207@redhat.com>
	<1216252910.3443.247.camel@zenigma>
	<200807171614.29594.nickpiggin@yahoo.com.au>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 16:14:29 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > It might encourage user space applications to start using
> > FADV_SEQUENTIAL or FADV_NOREUSE more often (as it would become
> > worthwhile to do so), and if they do (especially cron jobs), the problem
> > of the slow desktop in the morning would progressively solve itself.
> 
> The slow desktop in the morning should not happen even without such a
> call, because the kernel should not throw out frequently used data (even
> if it is not quite so recent) in favour of streaming data.
> 
> OK, I figure it doesn't do such a good job now, which is sad, 

Do you have any tests in mind that we could use to decide
whether the patch I posted Tuesday would do a decent job
at protecting frequently used data from streaming data?

http://lkml.org/lkml/2008/7/15/465

-- 
All Rights Reversed
