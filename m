Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbZKRVS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbZKRVS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbZKRVS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:18:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbZKRVS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:18:56 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/3] tracepoint: Add signal events
In-Reply-To: Masami Hiramatsu's message of  Wednesday, 18 November 2009 11:32:34 -0500 <4B0421A2.1080400@redhat.com>
References: <20091117234117.30589.61311.stgit@dhcp-100-2-132.bos.redhat.com>
	<20091118030706.EB93EA8C@magilla.sf.frob.com>
	<4B0421A2.1080400@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20091118211829.4A2471A8F@magilla.sf.frob.com>
Date: Wed, 18 Nov 2009 13:18:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Roland McGrath wrote:
> > I would add the siginfo_t * argument to each of these tracepoints.
> 
> I see. Is it OK to record only si_errno and si_code? because si_signo
> might be as same as sig.

Yes, si_signo will match sig.  Which siginfo_t fields are interesting to
record can vary by signal (i.e. by si_code).  si_code and si_errno are
certainly the first things that come to mind as most useful.  For SI_TIMER,
si_tid, si_overrun, and si_sigval are interesting.  For others, si_pid and
si_uid are interesting.


Thanks,
Roland
