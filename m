Return-Path: <linux-kernel-owner+w=401wt.eu-S1751592AbZHSMpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbZHSMpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZHSMpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:45:21 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:47952 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZHSMpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:45:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19083.62220.884894.505301@cargo.ozlabs.ibm.com>
Date: Wed, 19 Aug 2009 22:41:48 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       stephane eranian <eranian@googlemail.com>
Subject: Re: [PATCH 4/4][RFC] perf_counter: Allow sharing of output channels
In-Reply-To: <20090819105818.GB21150@elte.hu>
References: <20090819091823.916851355@chello.nl>
	<20090819092023.980284148@chello.nl>
	<20090819105818.GB21150@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Time to add a new sys_perf_counter_chattr() syscall and deprecate 
> the ioctls?

Hmmm... if 2.6.31 goes out with the ioctls, I think we should leave
them in for a long time.  I've never seen what the problem with ioctl
is anyway.  At least, I don't see how a new multi-function syscall
would be any better.

Paul.
