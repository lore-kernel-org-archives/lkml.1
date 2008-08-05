Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbYHEIe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbYHEIe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 04:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbYHEIet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 04:34:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49427
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756260AbYHEIes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 04:34:48 -0400
Date: Tue, 05 Aug 2008 01:34:45 -0700 (PDT)
Message-Id: <20080805.013445.30774221.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: torvalds@linux-foundation.org, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 1/7] lockdep: Fix combinatorial explosion in lock
 subgraph traversal.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080804131011.749503624@chello.nl>
References: <20080804130317.994042639@chello.nl>
	<20080804131011.749503624@chello.nl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 04 Aug 2008 15:03:18 +0200

> When we traverse the graph, either forwards or backwards, we
> are interested in whether a certain property exists somewhere
> in a node reachable in the graph.
 ...
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Peter, when Ingo added this to his tree he needed to add a build
fix of some sort.  Did you include that here?

I think the problem was that if CONFIG_PROVE_LOCKING is not
set, we need to add nop inline versions of lockdep_count_*_deps()
in kernel/lockdep_internals.h

See:

http://marc.info/?l=linux-kernel&m=121758260130275&w=2





