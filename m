Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZCRCkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZCRCkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 22:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZCRCj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 22:39:57 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:48556 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZCRCj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 22:39:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18880.24188.569247.425760@drongo.ozlabs.ibm.com>
Date: Wed, 18 Mar 2009 13:37:48 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 11/11] perf_counter: unify irq output code
In-Reply-To: <20090317220422.026219494@chello.nl>
References: <20090317215606.037073805@chello.nl>
	<20090317220422.026219494@chello.nl>
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Having 3 slightly different copies of the same code around does nobody any
> good. First step in revamping the output format.

Nice cleanup, and thanks for updating powerpc too.  With this, I think
we'll need to update the powerpc perf_counter_interrupt a bit: we
might as well use get_perf_counter_pending() instead of the wakeup
variable now.  I'll send an extra patch once I have done some testing.

Paul.
