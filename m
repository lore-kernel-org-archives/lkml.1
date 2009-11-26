Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbZKZJBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbZKZJBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759658AbZKZJBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:01:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759453AbZKZJBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:01:39 -0500
Date: Thu, 26 Nov 2009 10:01:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [GIT PULL v6] hw-breakpoints: Rewrite on top of perf events v6
Message-ID: <20091126090110.GD1389@elte.hu>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
 <20091124094421.GA3468@in.ibm.com>
 <20091124101342.GB5570@elte.hu>
 <20091126054735.GA5649@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126054735.GA5649@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > Well we have PERF_TYPE_BREAKPOINT right now. I agree that it should 
> > be finalized in some sort of extensible ABI real soon - we dont want 
> > (and dont need to) add all features that might be possible in the 
> > future.
> 
> Concerning in-kernel users, it's not a worry. The in-kernel api is not 
> supposed to be stable and shouldn't, especially for such a very young 
> facility like generic breakpoints.

in-kernel we dont worry about indeed (we can change and iterate APIs 
freely there) - it is PERF_TYPE_BREAKPOINT that we need to make sure is 
extensible enough.

Thanks,

	Ingo
