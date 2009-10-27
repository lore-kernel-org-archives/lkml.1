Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZJ0DWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZJ0DWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 23:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZJ0DWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 23:22:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:47060 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbZJ0DWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 23:22:05 -0400
Subject: Re: [PATCH 10/16] percpu: make percpu symbols in powerpc unique
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <1255500125-3210-11-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
	 <1255500125-3210-11-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 14:19:49 +1100
Message-ID: <1256613589.11607.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 15:01 +0900, Tejun Heo wrote:
> This patch updates percpu related symbols in powerpc such that percpu
> symbols are unique and don't clash with local symbols.  This serves
> two purposes of decreasing the possibility of global percpu symbol
> collision and allowing dropping per_cpu__ prefix from percpu symbols.
> 
> * arch/powerpc/kernel/perf_callchain.c: s/callchain/cpu_perf_callchain/
> 
> * arch/powerpc/kernel/setup-common.c: s/pvr/cpu_pvr/
> 
> * arch/powerpc/platforms/pseries/dtl.c: s/dtl/cpu_dtl/
> 
> * arch/powerpc/platforms/cell/interrupt.c: s/iic/cpu_iic/
> 
> Partly based on Rusty Russell's "alloc_percpu: rename percpu vars
> which cause name clashes" patch.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.


