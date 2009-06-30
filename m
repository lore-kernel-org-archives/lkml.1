Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbZF3Lvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbZF3Lvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZF3Lvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:51:43 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55745 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbZF3Lvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:51:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19017.63611.674927.683004@cargo.ozlabs.ibm.com>
Date: Tue, 30 Jun 2009 21:35:23 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf_counter: tools: Make :u and :k exclude
	hypervisor
In-Reply-To: <20090629203443.GH31577@elte.hu>
References: <19016.41130.429944.316897@cargo.ozlabs.ibm.com>
	<20090629203443.GH31577@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Hm, mind fixing the full range of problems with these flags please?

Sure, looking at it now.

One thing I'd like to do is add complete lists of hardware events for
each processor so that perf can tell you the full set of things you
can measure, and can let you ask for them without having to know raw
event codes.  I know how to work out which processor we're running on
for powerpc; for x86 I assume cpuid or something similar is usable
from userspace, is it?

Paul.
