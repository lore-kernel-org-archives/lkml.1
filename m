Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZFSIRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZFSIRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 04:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZFSIQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 04:16:47 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:54038 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbZFSIQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 04:16:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19003.18793.605755.277949@cargo.ozlabs.ibm.com>
Date: Fri, 19 Jun 2009 18:16:41 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: benh@kernel.crashing.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/6] perf_counter: tools: Makefile tweaks for 64-bit
	powerpc
In-Reply-To: <20090618091334.GB21191@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
	<19000.55666.866148.559620@cargo.ozlabs.ibm.com>
	<20090618091334.GB21191@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Note, i left out this bit from the commit - we need to find a better 
> solution than to allow ugly warnings on PowerPC.
> 
> Could we use the kernel's u64 type directly perhaps? That would 
> allow us to change all __u64 to u64 in all of tools/perf/ which is a 
> nice clean-up in any case.

This is userspace, we can use "u64" however we like. :)  I'll cook up
a patch to add "typedef unsigned long long u64" and change __u64 to
u64.

Paul.
