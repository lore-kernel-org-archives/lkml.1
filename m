Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab0CAJeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:34:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:36473 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0CAJeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:34:06 -0500
Subject: Re: linux-next: manual merge of the oprofile tree with Linus' tree
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Robert Richter <robert.richter@amd.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100301182001.f67b21ac.sfr@canb.auug.org.au>
References: <20100301182001.f67b21ac.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 10:34:01 +0100
Message-ID: <1267436041.1579.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-01 at 18:20 +1100, Stephen Rothwell wrote:
> Hi Robert,
> 
> Today's linux-next merge of the oprofile tree got a conflict in
> arch/x86/kernel/cpu/perf_event.c between commit
> 8c48e444191de0ff84e85d41180d7bc3e74f14ef ("perf_events, x86: Implement
> intel core solo/duo support") from Linus' tree and commit
> 27d4a358bf5ef730aacf50696b9b5dfc5e2a87a5 ("perf, x86: rename macro in
> ARCH_PERFMON_EVENTSEL_ENABLE") from the oprofile tree.
> 
> I fixed it up (by using the version from Linus' tree and substituting
> ARCH_PERFMON_EVENTSEL_ENABLE for ARCH_PERFMON_EVENTSEL0_ENABLE) and can
> carry the fix for a while.  I also did the same substitution in
> arch/x86/kernel/cpu/perf_event_p6.c .

The oprofile tree should _not_ carry perf patches.

