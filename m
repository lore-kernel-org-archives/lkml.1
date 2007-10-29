Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbXJ2Wry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbXJ2Wry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbXJ2Wrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:47:46 -0400
Received: from xenotime.net ([66.160.160.81]:56157 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752689AbXJ2Wrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:47:45 -0400
Date: Mon, 29 Oct 2007 15:47:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hch@infradead.org,
       jgarzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>
Subject: Re: [RFC] Create instrumentation directory (git repository)
Message-Id: <20071029154741.cb093f55.rdunlap@xenotime.net>
In-Reply-To: <20071029215138.GA4233@Krystal>
References: <20071029215138.GA4233@Krystal>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 17:51:38 -0400 Mathieu Desnoyers wrote:

> Hi,
> 
> Since we already have the Instrumentation menu in
> kernel/Kconfig.instrumentation and instrumentation code all over the
> kernel tree:
> 
> arch/*/oprofile/*.c
> kernel/kprobes.c
> arch/*/kernel/kprobes.c
> kernel/marker.c
> kernel/profile.c
> kernel/lockdep.c
> vm/vmstat.c
> block/blktrace.c
> drivers/base/power/trace.c
> 
> We could move them to
> 
> instrumentation/
> arch/*/instrumentation/
> 
> Therefore, we could also move the kprobes and marker samples under
> 
> instrumentation/samples/
> 
> Here is a link to a git repository containing the changes, based on
> 2.6.24-rc1:
> 
> git://ltt.polymtl.ca/linux-2.6-instrumentation.git instrumentation-for-linus
> (the interesting range is : v2.6.24-rc1..instrumentation-for-linus)
> 
> Through the gitweb interface:
> http://ltt.polymtl.ca/cgi-bin/gitweb.cgi?p=linux-2.6-instrumentation.git
> 
> Feedback is appreciated. Sorry for the huge CC list, but the change
> involves many maintainers.

Two more added.  Jeff Garzik and Christoph H. sometimes have some comments
about this.

It would be helpful if we could get comments on this in the next day
or two [instead of in 1-2 weeks].

Thanks,
---
~Randy
