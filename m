Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbYLEAiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbYLEAiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 19:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYLEAhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 19:37:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46812
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbYLEAhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 19:37:40 -0500
Date: Thu, 04 Dec 2008 16:37:41 -0800 (PST)
Message-Id: <20081204.163741.48585912.davem@davemloft.net>
To: paulus@samba.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       eranian@googlemail.com, dada1@cosmosbay.com, robert.richter@amd.com,
       arjan@infradead.org, hpa@zytor.com, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org
Subject: Re: [patch 2/3] performance counters: documentation
From: David Miller <davem@davemloft.net>
In-Reply-To: <18744.30427.440468.829807@cargo.ozlabs.ibm.com>
References: <20081204225345.654705757@linutronix.de>
	<20081204230228.557959174@linutronix.de>
	<18744.30427.440468.829807@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Fri, 5 Dec 2008 11:33:31 +1100

> This is going to be a huge problem, at least on powerpc, because it
> means that the kernel will have to know which events can be counted on
> which counters and what values need to be put in the control registers
> to select them.

Sparc64 is the same.

> The situation will be even worse with POWER5 and POWER6, where the
> event selection logic is very complex, with multiple layers of
> multiplexers.  I really really don't want the kernel to have to know
> about all that.

Niagara2 has deep multiplexing and sub-event masking too.

I really appreciated how perfmon kept all of those details
in userspace.
