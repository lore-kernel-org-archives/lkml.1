Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbXLSJ2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbXLSJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 04:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbXLSJ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 04:28:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49423 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbXLSJ2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 04:28:15 -0500
Date: Wed, 19 Dec 2007 10:27:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: __kprobes annotations
Message-ID: <20071219092720.GA3521@elte.hu>
References: <1197930464.23402.112.camel@brick> <20071218112936.GE9002@elte.hu> <1197978160.7734.31.camel@brick> <4767D02C.6030704@redhat.com> <1198042025.10357.4.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198042025.10357.4.camel@brick>
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

> __always_inline on some static functions was to ensure they ended up 
> in the .kprobes.text section. Mark this explicitly.

thanks, applied. I rolled this back into your cleanup patch to make sure 
we have a correct, bisectable kernel at every commit point.

	Ingo 
