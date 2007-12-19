Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbXLSKVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbXLSKVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 05:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbXLSKV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 05:21:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42432 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbXLSKV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 05:21:28 -0500
Date: Wed, 19 Dec 2007 11:20:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, Harvey Harrison <harvey.harrison@gmail.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/2] x86: fix kprobe_handler reenable preemption
Message-ID: <20071219102007.GE3521@elte.hu>
References: <4768555A.3000604@redhat.com> <476890CC.1020100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476890CC.1020100@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> > -			return 1;
> > +			ret = 1;
> 
> Here, "return 1;" is correct. After single step is done, preemption is 
> enabled in post_kprobe_handler().

could you resend the fixed patch? (instead of me fixing it up by hand - 
which is error-prone)

also, this seems like .24 material as well - could you send the fix 
against -rc5 too?

	Ingo
