Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYLEHBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYLEHBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYLEHA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:00:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:45524 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbYLEHA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:00:58 -0500
Date: Thu, 4 Dec 2008 23:02:06 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081204230206.6e083d51@infradead.org>
In-Reply-To: <20081205063131.GB12785@elte.hu>
References: <20081204225345.654705757@linutronix.de>
	<18744.29747.728320.652642@cargo.ozlabs.ibm.com>
	<20081205063131.GB12785@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008 07:31:31 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> Btw., i'm curious, why would we want to do that? It skews the results
> if the task continues executing and counters stop. To get the highest 
> quality profiling output the counters should follow the true state of
> the task that is profiled - and events should be passed to the
> monitoring task asynchronously. The _events_ can contain precise
> coupled information 
> - but the counters should continue.

btw stopping the task on counter overflow is an issue for things that
want to self profile, like JITs


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
