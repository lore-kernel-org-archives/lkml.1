Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZE1DT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZE1DT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbZE1DTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:19:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbZE1DTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:19:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 May 2009 04:54:07 +0200 <20090528025407.GA22182@redhat.com>
References: <20090525000016.GA2239@redhat.com>
	<20090525215903.GA9113@redhat.com>
	<20090527021131.4778BFC36B@magilla.sf.frob.com>
	<20090527224140.GC6770@redhat.com>
	<20090527230700.11F2DFC2BD@magilla.sf.frob.com>
	<20090527235936.GB12216@redhat.com>
	<20090528003256.86E4EFC2BD@magilla.sf.frob.com>
	<20090528025407.GA22182@redhat.com>
X-Zippy-Says: Where do your SOCKS go when you lose them in th' WASHER?
Message-Id: <20090528031907.E179FFC2BD@magilla.sf.frob.com>
Date: Wed, 27 May 2009 20:19:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you're going to zero out fields in a corner case, I think you should
zero si_code too so it's consistent with what collect_signal() produces
when a signal is posted with OOM for the sigq allocation.  Modulo that nit,
this is fine by me.  (It is likely nobody will ever see this path anyway,
since we'll probably merge the clean-up that replaces it before any release
that uses this series at all.)


Thanks,
Roland
