Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYAIJRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYAIJRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbYAIJRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:17:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35381 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbYAIJQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:16:58 -0500
Date: Wed, 9 Jan 2008 10:16:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] show_task: real_parent
Message-ID: <20080109091642.GA20457@elte.hu>
References: <20080109080323.8FCDC26F9A7@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109080323.8FCDC26F9A7@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> The show_task function invoked by sysrq-t et al displays the pid and 
> parent's pid of each task.  It seems more useful to show the actual 
> process hierarchy here than who is using ptrace on each process.

>  	printk(KERN_CONT "%5lu %5d %6d\n", free,
> -		task_pid_nr(p), task_pid_nr(p->parent));
> +		task_pid_nr(p), task_pid_nr(p->real_parent));

thanks, applied.

you must be hacking ptrace/gdb/strace code right now ;-)

	Ingo
