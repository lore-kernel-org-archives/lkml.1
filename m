Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbZFEBDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbZFEBDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 21:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZFEBDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 21:03:43 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:57802 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbZFEBDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:03:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18984.28387.116533.597438@cargo.ozlabs.ibm.com>
Date: Fri, 5 Jun 2009 11:03:31 +1000
From: Paul Mackerras <paulus@samba.org>
To: mingo@redhat.com
Cc: hpa@zytor.com, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Subject: Re: [tip:perfcounters/core] perf_counter tools: Build with native optimization
In-Reply-To: <tip-af794b94ae8a16fb4a9da6ce640c122efb44e2a0@git.kernel.org>
References: <new-submission>
	<tip-af794b94ae8a16fb4a9da6ce640c122efb44e2a0@git.kernel.org>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Ingo Molnar writes:

> perf_counter tools: Build with native optimization
> 
> Build the tools with -march=native by default.

On powerpc (RHEL5.2 on POWER5+, gcc 4.1.2), I get:

    CC perf.o
cc1: error: unrecognized command line option "-march=native"
make: *** [perf.o] Error 1

Is there a way to make the default CFLAGS depend on the architecture?
We need -m64 on powerpc as well.

Paul.
