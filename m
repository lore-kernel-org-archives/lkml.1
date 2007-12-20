Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbXLTJRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbXLTJRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 04:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbXLTJQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 04:16:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59998 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018AbXLTJQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 04:16:32 -0500
Date: Thu, 20 Dec 2007 10:15:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, Harvey Harrison <harvey.harrison@gmail.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3] x86: fix kprobe_handler reenable preemption
Message-ID: <20071220091509.GC4478@elte.hu>
References: <47699194.3060809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47699194.3060809@redhat.com>
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

> Fix a preemption bug in kprobe_handler(). It has to call 
> preempt_enable() before returning.

thanks - i've applied all 3 kprobes patches from you. (for v2.6.25)

	Ingo
