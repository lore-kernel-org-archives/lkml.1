Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZKVJGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZKVJGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 04:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZKVJGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 04:06:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbZKVJGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 04:06:43 -0500
Date: Sun, 22 Nov 2009 10:05:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>, Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>, jakub@redhat.com,
       gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC
 messing with mcount prologue
Message-ID: <20091122090531.GA21833@elte.hu>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
 <20091119072040.GA23579@elte.hu>
 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
 <1258694593.22249.1012.camel@gandalf.stny.rr.com>
 <1258736456.22249.1032.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258736456.22249.1032.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo, Thomas and Linus,
> 
> I know Thomas did a patch to force the -mtune=generic, but just in 
> case gcc decides to do something crazy again, this patch will catch 
> it.
> 
> Should we try to get this in now?

Very nice example of defensive coding - i like this. I've queued it up 
for .33 (unless anyone objects) as i think it's too late for .32.

	Ingo
