Return-Path: <linux-kernel-owner+w=401wt.eu-S1760462AbYHEIgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462AbYHEIgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 04:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbYHEIfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 04:35:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49434
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757310AbYHEIfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 04:35:24 -0400
Date: Tue, 05 Aug 2008 01:35:25 -0700 (PDT)
Message-Id: <20080805.013525.80656249.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: torvalds@linux-foundation.org, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 2/7] lockdep: lock_set_subclass - reset a held
 locks subclass
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080804131011.831874853@chello.nl>
References: <20080804130317.994042639@chello.nl>
	<20080804131011.831874853@chello.nl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 04 Aug 2008 15:03:19 +0200

> this can be used to reset a held lock's subclass, for arbitrary-depth
> iterated data structures such as trees or lists which have per-node
> locks.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: David S. Miller <davem@davemloft.net>
