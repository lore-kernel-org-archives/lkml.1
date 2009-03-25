Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbZCYMFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbZCYMFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZCYMFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:05:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54818 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbZCYMFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:05:41 -0400
Date: Wed, 25 Mar 2009 13:05:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/6] perf_counter: new output ABI
Message-ID: <20090325120529.GB11571@elte.hu>
References: <20090325113021.781490788@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325113021.781490788@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> The following patch-set extends the perf_counter output ABI and 
> updates kerneltop accordingly.

thanks Peter - these are really nice extensions.

Type/size records solves one of my worries about the event ABI: it 
now becomes easily extensible in a backwards-compatible manner.

Applied them to tip:perfcounters/core with minor edits.

	Ingo
