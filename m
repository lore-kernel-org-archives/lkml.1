Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYK1I7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYK1I7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 03:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYK1I7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 03:59:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:30809 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbYK1I67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 03:58:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=o/sZ3TpAHpwyW4sDhOG3piVbX3G2xXLPUXQXCBit045oro0x7zkRHUdWlDe1xzgHpk
         08l1uKD/ek9XpFc9vICdRKaKjGZVk45YUP/wBb8MlRuUJWdSuzQEh505kyeAZWiEzAQJ
         9H2YZgfrUg/wgttZYjv0HftlSE2cg00RZ3bYM=
Date: Fri, 28 Nov 2008 12:02:58 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       edwintorok@gmail.com, linux-kernel@vger.kernel.org
Subject: next-2008-11-27: tracing on alpha (again)
Message-ID: <20081128090258.GA27346@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On alpha-smp-n-debug-y:

  CC      kernel/trace/trace.o
kernel/trace/trace.c: In function 'ftrace_trace_userstack':
kernel/trace/trace.c:968: error: storage size of 'trace' isn't known
kernel/trace/trace.c:968: warning: unused variable 'trace'
make[3]: *** [kernel/trace/trace.o] Error 1
  CC      kernel/trace/trace_branch.o
kernel/trace/trace_branch.c: In function 'probe_likely_condition':
kernel/trace/trace_branch.c:44: error: implicit declaration of function 'raw_local_irq_save'
kernel/trace/trace_branch.c:76: error: implicit declaration of function 'raw_local_irq_restore'
