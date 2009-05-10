Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZEJXcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZEJXcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 19:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZEJXbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 19:31:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbZEJXbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 19:31:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: David Howells <dhowells@redhat.com>, jmorris@namei.org,
       chrisw@sous-sol.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       eparis@redhat.com, sds@tycho.nsa.gov, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] CRED: Rename cred_exec_mutex to reflect that it's
	a guard against ptrace
In-Reply-To: Oleg Nesterov's message of  Saturday, 9 May 2009 20:59:06 +0200 <20090509185906.GB10396@redhat.com>
References: <20090508125522.8488.13637.stgit@warthog.procyon.org.uk>
	<20090509185906.GB10396@redhat.com>
X-Shopping-List: (1) Didactic pincushions
   (2) Remote aggressors
   (3) Antic retarders
   (4) Abstinent beef wigs
Message-Id: <20090510232938.A62E1FC35D@magilla.sf.frob.com>
Date: Sun, 10 May 2009 16:29:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm. Ingo's "rename ptrace_may_access => ptrace_access_check" conflicts
> with my patch too.

Andrew seemed to want a different name choice too, so that will have to be
resolved before we worry about patch conflicts.

> Andrew, Roland, I guess I should re-send
> 	
> 	ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
> 	ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
> 	ptrace-do-not-use-task_lock-for-attach.patch
> 
> patches?

I guess so too.  Your series of changes is more substantial and potentially
controversial or problematic than the various renamings, so I think it
makes sense to settle and merge the renamings first.


Thanks,
Roland
