Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYJFQ5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYJFQ5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 12:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYJFQ5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 12:57:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:52970 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbYJFQ5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:57:24 -0400
Date: Mon, 6 Oct 2008 09:57:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: Add a C-state tracer to help power
 optimization
Message-ID: <20081006095707.0c1b5a23@infradead.org>
In-Reply-To: <1223311960.12409.28.camel@lappy.programming.kicks-ass.net>
References: <20081004105447.0e48d6d4@infradead.org>
	<alpine.DEB.1.10.0810041410390.6571@gandalf.stny.rr.com>
	<20081004112915.7c2b45ea@infradead.org>
	<1223311960.12409.28.camel@lappy.programming.kicks-ass.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Oct 2008 18:52:39 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> >  
> > 
> >  #endif /* _LINUX_FTRACE_H */
> 
> Why have the cstate_trace structure? If you just log start, stop you
> could compute the time delta from the trace time stamps, no?

there's 2 other fields I need than just the timestamp.
> 
> If you decide to keep the structure, perhaps declare it empty for !
> CONFIG_CSTATE_TRACER so as to not bloat stack usage when its not
> configured.

ok good point

> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
