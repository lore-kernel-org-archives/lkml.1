Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbZFATqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbZFATqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZFATqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:46:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44463 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbZFATqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:46:36 -0400
Date: Mon, 1 Jun 2009 21:46:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>
Subject: Re: linux-next: manual merge of the kmemcheck tree with the
	tracing tree
Message-ID: <20090601194624.GA29610@elte.hu>
References: <20090601175539.67317265.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601175539.67317265.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next merge of the kmemcheck tree got a conflict in
> kernel/trace/ring_buffer.c between commit
> aa20ae8444fc6c318272c643f856d8d8ad3e198d ("ring-buffer: move big if
> statement down") from the tracing tree and commits
> 9b7ff384ee76ced9638ab236db588a6f13916336 ("trace: annotate bitfields in
> struct ring_buffer_event") and 3467e18b1cf34c7d316af5717e7053ce845d014e
> ("kmemcheck: make bitfield annotations be valid C") from the kmemcheck
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Would be nice if you indicated whether you cross-checked it against 
tip:master, which had most of these conflicts resolved already (for 
weeks).

( this has relevance for the x86 and tracing tree conflicts - 
  kmemleak is not in -tip)

	Ingo
