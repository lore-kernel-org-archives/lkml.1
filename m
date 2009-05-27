Return-Path: <linux-kernel-owner+w=401wt.eu-S1762957AbZE0Xwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762957AbZE0Xwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762709AbZE0Xw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:52:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762882AbZE0XwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:52:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 May 2009 01:43:30 +0200 <20090527234330.GA12216@redhat.com>
References: <20090525185502.GA20781@redhat.com>
	<20090526210514.C1C91FC2BD@magilla.sf.frob.com>
	<20090527213222.GA6770@redhat.com>
	<20090527222337.0507EFC36B@magilla.sf.frob.com>
	<20090527231248.GB10032@redhat.com>
	<20090527232617.2FE48FC2BD@magilla.sf.frob.com>
	<20090527234330.GA12216@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090527235136.A44A4FC2BD@magilla.sf.frob.com>
Date: Wed, 27 May 2009 16:51:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, but the (minor and low priority) problem is that .si_pid recorded
> in ->last_siginfo does not match the tracee's pid from the tracer pov
> (if they run in different namespaces).

That is not a problem, it's how it's supposed to be.  That's what I was
just saying.  This is information about the values seen by the debugged
process.  Any translation to things meaningful in different contexts it
outside the scope of ptrace.


Thanks,
Roland
