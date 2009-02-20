Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZBTDtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZBTDtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZBTDtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:49:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbZBTDtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:49:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/2] ptrace_untrace: fix the SIGNAL_STOP_STOPPED check
In-Reply-To: Oleg Nesterov's message of  Friday, 13 February 2009 11:54:42 +0100 <20090213105442.GA24328@redhat.com>
References: <20090213105442.GA24328@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090220034928.741F6FC2F7@magilla.sf.frob.com>
Date: Thu, 19 Feb 2009 19:49:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This bug is ancient too. ptrace_untrace() must not resume the task
> if the group stop in progress, we should set TASK_STOPPED instead.

Right, the change looks correct.

> Unfortunately, we still have problems here:
> 
> 	- if the process/thread was traced, SIGNAL_STOP_STOPPED
> 	  does not necessary means this thread group is stopped.
> 
> 	- ptrace breaks the bookkeeping of ->group_stop_count.

Neither of these should be true today as I understand the code.  So if you
have reason to think these, I must be missing something that is likely to
be relevant to reviewing this change.


Thanks,
Roland
