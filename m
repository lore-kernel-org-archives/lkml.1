Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbZBMO1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbZBMO1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZBMO1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:27:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZBMO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:27:09 -0500
Subject: Re: irq-disabled vs vmap vs text_poke
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Nick Piggin <npiggin@suse.de>, akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       ananth@in.ibm.com, davem@davemloft.net
In-Reply-To: <20090213141839.GA31922@Krystal>
References: <1234529407.6519.28.camel@twins>
	 <20090213141839.GA31922@Krystal>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Feb 2009 15:28:57 +0100
Message-Id: <1234535337.6519.111.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, lets CC kprobes folk

On Fri, 2009-02-13 at 09:18 -0500, Mathieu Desnoyers wrote:
> 
> text_poke should actually use local_irq_disable/enable rather than
> local_irq_save/restore because it _must_ be called with interrupts on.
> 
> > Anybody got an idea on how to fix this?
> 
> There is probably something wrong with the caller, kprobes, which calls
> text_poke with interrupts off.


