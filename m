Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZCaFpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZCaFpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 01:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZCaFpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 01:45:31 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53193 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbZCaFpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 01:45:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18897.44438.320859.677262@cargo.ozlabs.ibm.com>
Date: Tue, 31 Mar 2009 16:43:50 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] pending perf_counter bits
In-Reply-To: <20090330170701.856843742@chello.nl>
References: <20090330170701.856843742@chello.nl>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Most of the previous set, except I kept the powerpc set_perf_counter_pending()
> bits.
> 
> This set also adds callchain support for x86 (no userspace yet -- am looking
> at porting sysprof). Furthermore, it has a first attempt at making
> perf_counters and oprofile and nmi_watchdog not stomp on each other.
> 
> New bits only compile tested on x86_64 and ppc64.

Seems to run ok on ppc64, except that the kerneltop output seems to
show fewer functions than before, for some reason.

Paul.
