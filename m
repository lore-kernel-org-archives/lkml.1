Return-Path: <linux-kernel-owner+w=401wt.eu-S933165AbZFOSwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbZFOSwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932908AbZFOSwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:52:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:56724 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbZFOSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:52:30 -0400
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
 support to use NMI-safe methods
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, efault@gmx.de, jeremy@goop.org,
       npiggin@suse.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20090615184858.GD6520@Krystal>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org>
	 <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain>
	 <20090615171845.GA7664@elte.hu>
	 <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain>
	 <4A369508.2090707@zytor.com>  <20090615184858.GD6520@Krystal>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 20:51:57 +0200
Message-Id: <1245091917.6741.185.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 14:48 -0400, Mathieu Desnoyers wrote:
> we should not care that much about the performance hit of
> saving/restoring the cr2 register at each nmi entry/exit.

But we do, perf counters very much cares about nmi performance.

