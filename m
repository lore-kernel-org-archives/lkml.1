Return-Path: <linux-kernel-owner+w=401wt.eu-S1762860AbZD3Ndn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762860AbZD3Ndn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760939AbZD3Ndd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:33:33 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:50896 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357AbZD3Ndd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:33:33 -0400
Date: Thu, 30 Apr 2009 09:22:22 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090430024303.GB19875@Krystal>
Message-ID: <alpine.DEB.1.10.0904300921290.22262@qirst.com>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Mathieu Desnoyers wrote:

> to have a good look at the memory accounting code. We could probably
> benefit of Christoph Lameter's cpu ops (using segment registers to
> address per-cpu variables with atomic inc/dec) in there. Or at least
> removing interrupt disabling by using preempt disable and local_t
> variables for the per-cpu counters could bring some benefit.

Guess we are ready for atomic per cpu ops now that the new per cpu
allocator is in? Segment register issues with the PDA are also solved
right?

