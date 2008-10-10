Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYJJIyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYJJIyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYJJIyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:54:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYJJIyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:54:40 -0400
Date: Fri, 10 Oct 2008 10:54:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anders Kaseorg <andersk@MIT.EDU>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] ftrace: Make ftrace_test_p6nop disassembler-friendly
Message-ID: <20081010085429.GB319@elte.hu>
References: <alpine.DEB.2.00.0810092209460.21569@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0810092209460.21569@vinegar-pot.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0743]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anders Kaseorg <andersk@MIT.EDU> wrote:

> Commit 4c3dc21b136f8cb4b72afee16c3ba7e961656c0b in tip introduced the
> 5-byte NOP ftrace_test_p6nop:
>   jmp . + 5
>   .byte 0x00, 0x00, 0x00
> This is not friendly to disassemblers because an odd number of 0x00s
> ends in the middle of an instruction boundary.  This changes the 0x00s
> to 1-byte NOPs (0x90).
> 
> Signed-off-by: Anders Kaseorg <andersk@mit.edu>

applied to tip/tracing/ftrace, good spotting Anders!

Steve, any objections?

	Ingo
