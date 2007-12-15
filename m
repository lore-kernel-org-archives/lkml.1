Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbXLOIue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbXLOIue (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 03:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXLOIu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 03:50:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49315 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbXLOIu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 03:50:26 -0500
Date: Sat, 15 Dec 2007 09:50:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: FInal kprobes rollup patches
Message-ID: <20071215085015.GA9720@elte.hu>
References: <1197708350.898.87.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197708350.898.87.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Further unification work.  There is a possible behavior change on 
> X86_32 here.
> 
> is_IF_modifier(p->opcode)
> 
> to
> 
> is_IF_modifier(p->ainsn.insn)
> 
> Which should be equivalent, but is not purely cosmetic as the rest of 
> the unification so far.

hm, could you split this into two, the pure-equivalence and the 
possibly-modifying patch? (that way any potential breakage becomes 
bisectable) Same end result, just two commits instead of one.

also, did you manage to run/test kprobes (on 32-bit or 64-bit x86), and 
it worked fine?

	Ingo
