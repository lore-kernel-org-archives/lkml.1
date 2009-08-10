Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZHJNqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZHJNqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZHJNqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:46:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60019 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbZHJNqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:46:17 -0400
Date: Mon, 10 Aug 2009 15:46:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Message-ID: <20090810134608.GA8295@elte.hu>
References: <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com> <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com> <20090807112421.GB30014@elte.hu> <20090807113349.GA31673@elte.hu> <1249667341.17467.5.camel@twins> <20090808120315.GA14086@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> I've been using some old version of perf. When I try to build the 
> version for the latest -tip, I get the following build error:
> 
> builtin-annotate.o: In function `print_summary':
> /home/markus/linux/git-tip/tools/perf/builtin-annotate.c:1211: undefined reference to `rb_first'
> /home/markus/linux/git-tip/tools/perf/builtin-annotate.c:1223: undefined reference to `rb_next'
> builtin-annotate.o: In function `insert_source_line':

Weird. How do you build perf? Do you do:

  cd tools/perf/
  make

? does your build directory have the ../../lib/rbtree.c file?

	Ingo

