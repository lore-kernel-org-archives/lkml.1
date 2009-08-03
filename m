Return-Path: <linux-kernel-owner+w=401wt.eu-S932323AbZHCPPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbZHCPPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223AbZHCPPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:15:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbZHCPPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:15:15 -0400
Date: Mon, 3 Aug 2009 11:14:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Dave Anderson <anderson@redhat.com>, crash-utility@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <clark.williams@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, srostedt@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][RFC][PATCH] Crash-utility, tracing: enable crash to
	analyze tracing from core-file (make tracing can act as a flight
	recorder)
Message-ID: <20090803151420.GA8712@infradead.org>
References: <4A76F8A1.30503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A76F8A1.30503@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 10:48:01PM +0800, Lai Jiangshan wrote:
> 
> We use tracing subsystem very well when kernel is alive.
> But we also want to get help from tracing when kernel is core-dump.
> This patch is for this purpose. It makes tracing can act as a
> flight recorder, we can find what have happen from the events.

Nice!  Now the only thing missing is gettind kdb in mainline and a trace
reader in kdb ;-)

Any idea how easy it is to reuse the crash/gdb code for looking at crash
dumps through kgdb?

Btw, the Cc list here seems to be a very strong indicator that we
should have a linux-trace@vger list, I already noticed this for tons
of other tracing patches.

