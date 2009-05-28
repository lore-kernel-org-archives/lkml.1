Return-Path: <linux-kernel-owner+w=401wt.eu-S1763647AbZE1T2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763647AbZE1T2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 15:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbZE1T2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 15:28:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792AbZE1T2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 15:28:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 May 2009 05:35:00 +0200 <20090528033500.GA24347@redhat.com>
References: <20090525000016.GA2239@redhat.com>
	<20090525215903.GA9113@redhat.com>
	<20090527021131.4778BFC36B@magilla.sf.frob.com>
	<20090527224140.GC6770@redhat.com>
	<20090527230700.11F2DFC2BD@magilla.sf.frob.com>
	<20090527235936.GB12216@redhat.com>
	<20090528003256.86E4EFC2BD@magilla.sf.frob.com>
	<20090528025407.GA22182@redhat.com>
	<20090528031907.E179FFC2BD@magilla.sf.frob.com>
	<20090528033500.GA24347@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090528192807.32845FC2BD@magilla.sf.frob.com>
Date: Thu, 28 May 2009 12:28:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, SI_USER == 0, so si_code is zero. And SI_USER looks more
> consistent to me, because

Ah so.

> > so it's consistent with what collect_signal() produces
> > when a signal is posted with OOM for the sigq allocation.
> 
> perhaps it is better to change collect_signal() to set SI_USER ?
> Note that __send_signal() user SI_USER, not zero in is_si_special()
> case.

Sure, though as you point out it's purely cosmetic.


Thanks,
Roland
