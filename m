Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbZEYAN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbZEYAN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 20:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbZEYANl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 20:13:41 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:59907 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262AbZEYANk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 20:13:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18969.56962.588194.319564@cargo.ozlabs.ibm.com>
Date: Mon, 25 May 2009 09:55:46 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
	identical inherited contexts
In-Reply-To: <20090523123828.GA13878@elte.hu>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	<18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	<1242980169.26820.617.camel@twins>
	<18966.30400.611789.434936@cargo.ozlabs.ibm.com>
	<1242986897.26820.638.camel@twins>
	<20090523123828.GA13878@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> OTOH, enabling/disabling counters in specific functions of a library 
> might be a valid use-case.

If that's the use case, wouldn't we wouldn't the "enable" to restore
the previous state, rather than enabling all counters?

Paul.
