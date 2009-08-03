Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZHCVyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZHCVyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932242AbZHCVyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:54:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41637 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbZHCVyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:54:17 -0400
Date: Mon, 3 Aug 2009 17:53:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Dave Anderson <anderson@redhat.com>, crash-utility@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <clark.williams@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, srostedt@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][RFC][PATCH] Crash-utility, tracing: enable crash to
	analyze tracing from core-file (make tracing can act as a flight
	recorder)
Message-ID: <20090803215326.GA8403@infradead.org>
References: <4A76F8A1.30503@cn.fujitsu.com> <20090803151420.GA8712@infradead.org> <1249312875.7924.106.camel@twins> <4A773EBD.3050707@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A773EBD.3050707@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 02:47:09PM -0500, Jason Wessel wrote:
> If there is a nice API to call for the trace piece, it is pretty trivial
> to add additional kdb commands which would allow you to print your trace
> buffers as needed.  The unified kdb/kgdb prototype also supports calling
> kdb commands through gdb's "monitor" command.  It is not clear if that
> satisfies the need that Christoph asked about, or if he had some other
> data analysis in mind.

That sounds perfect.  

