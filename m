Return-Path: <linux-kernel-owner+w=401wt.eu-S1765308AbXLQQfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765308AbXLQQfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758360AbXLQQey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:34:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53617 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242AbXLQQex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:34:53 -0500
Date: Mon, 17 Dec 2007 17:33:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Harvey Harrison <harvey.harrison@gmail.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [-mm][PATCH 0/6] (yet another) kprobes x86 code unification
	and boosters
Message-ID: <20071217163342.GA10495@elte.hu>
References: <47669E87.1010506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47669E87.1010506@redhat.com>
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

> Hello all,
> 
> I developed a series of patches which unifies kprobes code on x86 and 
> introduces boosters on x86-64. These patches can be applied to 
> 2.6.24-rc4-mm1.
> 
> The purpose of this patchset is unifying kprobes_[32|64].[c|h] to 
> kprobes.[c|h] for simplifying code maintenance.
> 
> I know these patches are conflicting with Harvey's patch. We need to 
> solve that.

your series fixes the 64-bit crash that i was seeing, so i've picked it 
up. Please work it out with Harvey which cleanups of him are not 
included yet.

	Ingo
