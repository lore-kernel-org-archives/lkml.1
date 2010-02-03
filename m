Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab0BCQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:56:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59667
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757407Ab0BCQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:56:19 -0500
Date: Wed, 03 Feb 2010 08:56:33 -0800 (PST)
Message-Id: <20100203.085633.172547702.davem@davemloft.net>
To: peterz@infradead.org
Cc: ypolyans@princeton.edu, herbert@gondor.apana.org.au, yjwei@cn.fujitsu.com,
       netdev@vger.kernel.org, polyanskiy@gmail.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimer, softirq: Fix hrtimer->softirq trampoline
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265120401.24455.306.camel@laptop>
References: <20100202074914.GD11081@gondor.apana.org.au>
	<20100202085117.7a5c3530@penta.localdomain>
	<1265120401.24455.306.camel@laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 02 Feb 2010 15:20:01 +0100

> Subject: hrtimer, softirq: Fix hrtimer->softirq trampoline
> 
> hrtimers callbacks are always done from hardirq context, either the
> jiffy tick interrupt or the hrtimer device interrupt.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: David S. Miller <davem@davemloft.net>

It would be nice to give mention of the bug reporter et al.
in the final commit message.

Thanks.
