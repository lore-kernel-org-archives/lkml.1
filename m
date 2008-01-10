Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbYAJEAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbYAJEAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 23:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbYAJEAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 23:00:00 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:29000 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbYAJD77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 22:59:59 -0500
Subject: Re: [RFC PATCH 22/22 -v2] Trace irq disabled critical timings
From: Daniel Walker <dwalker@mvista.com>
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
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080109233045.768464295@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
	 <20080109233045.768464295@goodmis.org>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 19:58:22 -0800
Message-Id: <1199937502.18203.22.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 18:29 -0500, Steven Rostedt wrote:
> +                       /* Don't trace irqs off for idle */
> +                       stop_critical_timings();
>                         idle();
> +                       start_critical_timings();


Is there another way to hook into the idle routine? Right above these
lines there is a call to "enter_idle()" which I'm wondering about ..
Would be nice to have some sort of generic hook or method for this ..

Daniel

