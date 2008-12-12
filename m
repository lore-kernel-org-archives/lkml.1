Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYLLF5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYLLF5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYLLF53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:57:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55406 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYLLF52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:57:28 -0500
Date: Fri, 12 Dec 2008 06:57:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/9] oprofile: port to the new ring buffer
Message-ID: <20081212055717.GB12451@elte.hu>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> This patch set ports cpu buffers in oprofile to the new ring buffer 
> provided by the tracing framework. The motivation here is to leave the 
> pain of implementing ring buffers to others. Oh, no, there are more 
> advantages. Main reason is the support of different sample sizes that 
> could be stored in the buffer. Use cases for this are IBS and Cell spu 
> profiling. Using the new ring buffer ensures valid and complete samples 
> and allows copying the cpu buffer stateless without knowing its 
> content. Second it will use generic kernel API and also reduce code 
> size. And hopefully, there are less bugs.
> 
> The patch set is also available here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git ring_buffer

Pulled into tip/oprofile, thanks Robert - very nice stuff!

I've changed the exports to _GPL because these are really internal APIs 
with a high flux, so the practical requirement for code relying on it to 
be in-tree (or at least be source-available) is evident.

	Ingo
