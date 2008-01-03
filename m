Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbYACLGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbYACLGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYACLGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:06:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51947 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbYACLGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:06:39 -0500
Date: Thu, 3 Jan 2008 12:04:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, mathieu.desnoyers@polymtl.ca,
       hskinnemoen@atmel.com, mhiramat@redhat.com, sam@ravnborg.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 2/2] Kprobes: Move kprobes examples to samples/
Message-ID: <20080103110459.GI29194@elte.hu>
References: <20080103062425.GA22781@in.ibm.com> <20080103062825.GB22781@in.ibm.com> <20080103093303.GB16803@elte.hu> <20080103102233.GB28934@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103102233.GB28934@in.ibm.com>
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

> > feature request: please make this work in the !modular case as well 
> > - if built-in then it should just run sometime during bootup and run 
> > the tests and report success/failure. This way automated testing can 
> > pick up any regressions much easier.
> 
> Will try cook up something along those lines. It'll be easy to verify 
> if the probes inserted and removed properly, but verifying handlers 
> run correctly will need some work.
> 
> We have a sort of regression test bucket that uses expect to parse the 
> dmesg to verify handlers did run correctly; that isn't a totally 
> in-kernel solution anyway. I have a couple of ideas in mind to make it 
> easier.

Great. Would be really nice to have something along the lines of 
CONFIG_DEBUG_LOCKING_API_SELFTESTS. Those unit tests took time to 
develop, but they caught more than 90% (!) of the internal lockdep 
engine bugs before they ever hit mainline.

	Ingo
