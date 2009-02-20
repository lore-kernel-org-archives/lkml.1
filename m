Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbZBTR0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbZBTR0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbZBTRZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:25:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51113 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbZBTRZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:25:55 -0500
Date: Fri, 20 Feb 2009 18:25:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] ftrace: allow archs to preform pre and post
	process for code modification
Message-ID: <20090220172525.GH24538@elte.hu>
References: <20090220163846.709775139@goodmis.org> <20090220164045.641080168@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220164045.641080168@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> +int ftrace_arch_modify_prepare(void);
> +int ftrace_arch_modify_post_process(void);

i think it would be clearer to name it:

extern int ftrace_arch_code_modify_prepare(void);
extern int ftrace_arch_code_modify_finish(void);

?

	Ingo
