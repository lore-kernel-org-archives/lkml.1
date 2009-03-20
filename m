Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZCTWcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZCTWcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 18:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZCTWcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 18:32:08 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35318 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbZCTWcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 18:32:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18884.6492.381436.13866@cargo.ozlabs.ibm.com>
Date: Sat, 21 Mar 2009 09:31:56 +1100
From: Paul Mackerras <paulus@samba.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] perfcounters: record time running and time   enabled
 for each counter
In-Reply-To: <49C3F8FE.4050406@linux.vnet.ibm.com>
References: <18883.34555.748843.35920@cargo.ozlabs.ibm.com>
	<49C3F8FE.4050406@linux.vnet.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Ashford writes:

> I'm a little confused about the ABI, though.  I see that I can specify 
> which times I want to be able to read, but the order that they appear in 
> the stream seems to be unstated.  I tried to figure it out by looking at 
>   the kernel code, but there is no reference to PERF_FORMAT_TIME_ENABLED 
> or PERF_FORMAT_TIME_RUNNING in the patch (besides the definition).

Gah, I posted the wrong version of the patch.  Sorry.  I'll rebase and
repost.

Paul.
