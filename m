Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbYKWMug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbYKWMug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 07:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbYKWMu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 07:50:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60226 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbYKWMu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 07:50:26 -0500
Date: Sun, 23 Nov 2008 13:49:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/1] powerpc: make mcount a stub for dynamic ftrace
Message-ID: <20081123124958.GM29663@elte.hu>
References: <20081120215541.489725873@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120215541.489725873@goodmis.org>
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

> Paul,
> 
> I have one more patch. I added it to the end of the ppc/ftrace 
> branch. The new way of handling the finding of mcounts means we do 
> not need to do anything in the mcount call itself. It should just be 
> a stub and when ftrace is enabled, it will change the caller sites 
> to call something other than mcount.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: ppc/ftrace

i've also pulled the ppc/ftrace branch into tip/tracing/powerpc, and 
added it to ftrace-next's linux-next integration rules.

So if Paul gives the green light that the commits have the right 
structure, we can freeze down the branch and the SHA1's and integrate 
it into ftrace-next. (which is integrated in linux-next after the 
powerpc tree so should be all fine in terms of merge ordering)

	Ingo
