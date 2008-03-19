Return-Path: <linux-kernel-owner+w=401wt.eu-S940590AbYCTA0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940590AbYCTA0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765266AbYCSXgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:36:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933697AbYCSXgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:36:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86_64 ia32 ptrace vs -ENOSYS
In-Reply-To: Andrew Morton's message of  Wednesday, 19 March 2008 15:17:58 -0700 <20080319151758.29e02848.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080317045741.2F6A526F995@magilla.localdomain>
	<20080319151758.29e02848.akpm@linux-foundation.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080319233601.958B426F995@magilla.localdomain>
Date: Wed, 19 Mar 2008 16:36:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is unclear (to me) what are the consequences of this problem?  What
> are the user-visible effects of the fix?

I don't know off hand of something that cares.  (I have a test case, but
it's just contrived for the purpose.)  Something like UML could use this to
approximate PTRACE_SYSEMU when it's not there.  But we would have heard
before now if UML cared about this particular behavior on x86_64.

> IOW: is it a 2.6.25 thing and if so, why?

No hurry.  It's been broken forever (regression vs native 32-bit).
(OTOH, the fixes are quite safe.)


Thanks,
Roland
