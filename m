Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbZHCPWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbZHCPWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbZHCPWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:22:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:44207 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbZHCPWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:22:31 -0400
Subject: Re: [ANNOUNCE][RFC][PATCH] Crash-utility, tracing: enable crash to
 analyze tracing from core-file (make tracing can act as a flight recorder)
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Dave Anderson <anderson@redhat.com>,
       crash-utility@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
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
In-Reply-To: <20090803151420.GA8712@infradead.org>
References: <4A76F8A1.30503@cn.fujitsu.com>
	 <20090803151420.GA8712@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Aug 2009 17:21:15 +0200
Message-Id: <1249312875.7924.106.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 11:14 -0400, Christoph Hellwig wrote:
> Nice!  Now the only thing missing is gettind kdb in mainline and a trace
> reader in kdb ;-)
> 
> Any idea how easy it is to reuse the crash/gdb code for looking at crash
> dumps through kgdb?

It was suggested a while ago to implement kdb as an in-kernel consumer
of kgdb or something. No idea what happened there..
