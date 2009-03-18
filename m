Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZCRLwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZCRLwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbZCRLwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:52:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51721 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbZCRLwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:52:36 -0400
Date: Wed, 18 Mar 2009 12:51:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, bharata@linux.vnet.ibm.com
Subject: Re: [PATCH] Kprobes: Fix locking imbalance in kretprobes
Message-ID: <20090318115158.GF32233@elte.hu>
References: <20090318113621.GB4129@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318113621.GB4129@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> Fix locking imbalance in kretprobes:
> 
> =====================================
> [ BUG: bad unlock balance detected! ]
> -------------------------------------
> kthreadd/2 is trying to release lock (&rp->lock) at:
> [<c06b3080>] pre_handler_kretprobe+0xea/0xf4

Applied it to tip:tracing/kprobes, thanks Ananth!

The bug has been introduced in v2.6.27-rc1 so i've marked it for a 
-stable backport for .27.x, 28.x and 29.x.

	Ingo
