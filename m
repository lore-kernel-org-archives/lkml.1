Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYAWRew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYAWRew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757255AbYAWRcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:32:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757684AbYAWRcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:32:21 -0500
Date: Wed, 23 Jan 2008 12:27:12 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 19/20 -v5] Trace irq disabled critical timings
Message-ID: <20080123172712.GE18698@redhat.com>
References: <20080123160236.969334052@goodmis.org> <20080123160444.197366580@goodmis.org> <20080123165353.GA12598@goodmis.org> <20080123171107.GB12598@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123171107.GB12598@goodmis.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Wed, Jan 23, 2008 at 12:11:07PM -0500, Steven Rostedt wrote:
> This patch adds latency tracing for critical timings
> (how long interrupts are disabled for).
> [...]

Is there an opportunity here to share effort with latencytop, and
ideally to use markers as much as possible for these event hooks?

- FChE
