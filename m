Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbZLOFgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbZLOFgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbZLOFf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:35:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48053
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbZLOFf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:35:58 -0500
Date: Mon, 14 Dec 2009 21:36:01 -0800 (PST)
Message-Id: <20091214.213601.77046339.davem@davemloft.net>
To: peterz@infradead.org
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: cpu_clock() in NMIs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1260819170.4165.346.camel@twins>
References: <1260781359.4165.42.camel@twins>
	<20091214.110905.207084342.davem@davemloft.net>
	<1260819170.4165.346.camel@twins>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 14 Dec 2009 20:32:50 +0100

> OK, you convinced me plenty ;-)
> 
> I guess we need some debug code to ensure we don't grow any
> local_irq_save/restore/disable code in NMI paths, and maybe document
> this some place.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ingo and others.  I'd like to get this kernel/sched_clock.c IRQ
disabling patch into Linus's tree and then into -stable because the
fix for sparc64 perf depends upon it.

Thanks.
