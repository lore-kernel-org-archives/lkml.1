Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbYA3Jlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbYA3Jlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758454AbYA3JlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:41:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54645 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099AbYA3JlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:41:22 -0500
Subject: Re: [PATCH 19/22 -v7] trace preempt off critical timings
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080130031843.112965593@goodmis.org>
References: <20080130031521.258552785@goodmis.org>
	 <20080130031843.112965593@goodmis.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 10:40:37 +0100
Message-Id: <1201686038.28547.176.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 22:15 -0500, Steven Rostedt wrote:

> +static DEFINE_PER_CPU(int, tracing_cpu);

Is the per-cpu tracing not also needed for irq off tracing?

Also, its not mentioned in the changelog.

