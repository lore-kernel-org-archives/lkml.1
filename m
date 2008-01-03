Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbYACJdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbYACJdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 04:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYACJdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 04:33:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbYACJdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 04:33:41 -0500
Date: Thu, 3 Jan 2008 10:33:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, mathieu.desnoyers@polymtl.ca,
       hskinnemoen@atmel.com, mhiramat@redhat.com, sam@ravnborg.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 2/2] Kprobes: Move kprobes examples to samples/
Message-ID: <20080103093303.GB16803@elte.hu>
References: <20080103062425.GA22781@in.ibm.com> <20080103062825.GB22781@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103062825.GB22781@in.ibm.com>
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


* Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> Move kprobes examples from Documentation/kprobes.txt to under 
> samples/. Patch originally by Randy Dunlap.

nice!

> +config SAMPLE_KPROBES
> +	tristate "Build kprobes examples -- loadable modules only"
> +	depends on KPROBES && m
> +	help
> +	  This build several kprobes example modules.

feature request: please make this work in the !modular case as well - if 
built-in then it should just run sometime during bootup and run the 
tests and report success/failure. This way automated testing can pick up 
any regressions much easier.

	Ingo
