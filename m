Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbZEKLfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbZEKLfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZEKLfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:35:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54785 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989AbZEKLfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:35:43 -0400
Date: Mon, 11 May 2009 13:33:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
       jmorris@namei.org, chrisw@sous-sol.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       eparis@redhat.com, sds@tycho.nsa.gov
Subject: Re: [PATCH 1/2] CRED: Rename cred_exec_mutex to reflect that it's
	a guard against ptrace
Message-ID: <20090511113356.GB4748@elte.hu>
References: <20090508125522.8488.13637.stgit@warthog.procyon.org.uk> <20090509185906.GB10396@redhat.com> <20090510232938.A62E1FC35D@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090510232938.A62E1FC35D@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> > Hmm. Ingo's "rename ptrace_may_access => ptrace_access_check" conflicts
> > with my patch too.
> 
> Andrew seemed to want a different name choice too, so that will have to be
> resolved before we worry about patch conflicts.
> 
> > Andrew, Roland, I guess I should re-send
> > 	
> > 	ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
> > 	ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
> > 	ptrace-do-not-use-task_lock-for-attach.patch
> > 
> > patches?
> 
> I guess so too.  Your series of changes is more substantial and 
> potentially controversial or problematic than the various 
> renamings, so I think it makes sense to settle and merge the 
> renamings first.

yeah, cleanups first is generally the better strategy. Not only does 
it make reverts easier, it also makes it easier to review (and 
potentially fix) later patches.

	Ingo
