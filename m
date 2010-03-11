Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0CKJLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:11:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:44521 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab0CKJLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:11:03 -0500
Subject: Re: [PATCH] perf: export perf_trace_regs and
 perf_arch_fetch_caller_regs
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100311090248.GA10904@infradead.org>
References: <4B989C1B.2090407@cn.fujitsu.com>
	 <20100311090248.GA10904@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Mar 2010 10:10:51 +0100
Message-ID: <1268298651.5279.986.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 04:02 -0500, Christoph Hellwig wrote:
> On Thu, Mar 11, 2010 at 03:30:35PM +0800, Xiao Guangrong wrote:
> > Export perf_trace_regs and perf_arch_fetch_caller_regs since module will
> > use these
> 
> What modules exactly?  Uusually you add the export together with the
> series adding the users.

Pretty much all modular tracepoint users I think, I just got this from a
pp64_defconfig build:

ERROR: "perf_trace_regs" [fs/xfs/xfs.ko] undefined!
ERROR: ".perf_arch_fetch_caller_regs" [fs/xfs/xfs.ko] undefined!
ERROR: "perf_trace_regs" [arch/powerpc/platforms/cell/spufs/spufs.ko] undefined!
ERROR: ".perf_arch_fetch_caller_regs" [arch/powerpc/platforms/cell/spufs/spufs.ko] undefined!

