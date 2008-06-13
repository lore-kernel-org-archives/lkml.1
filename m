Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbYFMG62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbYFMG62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 02:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYFMG6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 02:58:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41272 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbYFMG6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 02:58:20 -0400
Date: Fri, 13 Jun 2008 08:58:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX] lockdep: output lock_class key instead of address for
	forward dependency output
Message-ID: <20080613065809.GA28810@elte.hu>
References: <1213339217.17201.6.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213339217.17201.6.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang, Ying <ying.huang@intel.com> wrote:

> The key instead of address of lock_class should be output in
> /proc/lockdep when forward dependency is output, because key is
> output for lock_class itself as identifier too.
> 
> This patch is based on x86/auto-latest branch of git-x86 tree, and has
> been tested on x86_64 platform.

applied to tip/core/locking - thanks Ying.

i'm wondering, can entry->class never be NULL here?

	Ingo
