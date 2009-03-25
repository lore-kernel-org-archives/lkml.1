Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbZCYMSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbZCYMSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbZCYMSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:18:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42497 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbZCYMSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:18:32 -0400
Date: Wed, 25 Mar 2009 13:18:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 5/6] perf_counter: kerneltop: mmap_pages argument
Message-ID: <20090325121811.GC11571@elte.hu>
References: <20090325113021.781490788@chello.nl> <20090325113317.104545398@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325113317.104545398@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> provide a knob to set the number of mmap data pages.

> +	" -m pages  --mmap_pages=<pages> # number of mmap data pages\n"

Btw., we really want this to be auto-tuning to a large degree. If 
the kernel observes missed events, it should create a 
PERF_EVENT_OVERFLOW==0x3 record, with the number of missed events - 
or something like that.

	Ingo
