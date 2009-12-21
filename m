Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZLUJez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZLUJez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 04:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbZLUJey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 04:34:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50582 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606AbZLUJex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 04:34:53 -0500
Date: Mon, 21 Dec 2009 10:34:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: different symbol address between System.map and
 /proc/kallsyms
Message-ID: <20091221093432.GA30720@elte.hu>
References: <4B2ECD47.7040202@cn.fujitsu.com>
 <4B2F1630.7090406@zytor.com>
 <4B2F3C40.6030601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2F3C40.6030601@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> 
> 
> H. Peter Anvin wrote:
> 
> > 
> > That is normal if you have a relocatable kernel which has been loaded at
> > the non-compile-time default address.
> > 
> 
> Yeah, i see, thank you very much.
> 
> But, anyway, perf should know this case, i'll fix it.

Yeah. It's even a bugfix so if you fix it we can put it into 2.6.33 as well if 
it tests out reasonably well.

Thanks,

	Ingo
