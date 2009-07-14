Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbZGNQBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbZGNQBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbZGNQBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:01:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54460
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755114AbZGNQBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:01:20 -0400
Date: Tue, 14 Jul 2009 09:01:24 -0700 (PDT)
Message-Id: <20090714.090124.216664038.davem@davemloft.net>
To: kaber@trash.net
Cc: tglx@linutronix.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       peterz@infradead.org
Subject: Re: [patch 1/3] net: serialize hrtimer callback in sched_cbq
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A5C402A.7090906@trash.net>
References: <20090709215606.526259917@linutronix.de>
	<20090712.135555.207096388.davem@davemloft.net>
	<4A5C402A.7090906@trash.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 14 Jul 2009 10:22:02 +0200

> That's my understanding what HRTIMER_SOFTIRQ is used for. I think
> simply grabbing the root lock in cbq_undelay() should be fine.
> 
> Compile-tested only.

Unfortunately, as Peter and Thomas explained, this is not the case.
