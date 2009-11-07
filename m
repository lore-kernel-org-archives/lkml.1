Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbZKGGQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbZKGGQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 01:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZKGGQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 01:16:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51898
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbZKGGQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 01:16:18 -0500
Date: Fri, 06 Nov 2009 22:16:43 -0800 (PST)
Message-Id: <20091106.221643.03023079.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       sparclinux@vger.kernel.org
Subject: Re: [patch 08/16] sparc: Make atomic locks raw
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091106223806.721945005@linutronix.de>
References: <20091106223547.784916750@linutronix.de>
	<20091106223806.721945005@linutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 06 Nov 2009 22:41:39 -0000

> SPIN_LOCK_UNLOCKED is deprecated and the locks which protect the
> atomic operations have no dependency on other locks and the code is
> well tested so the conversion to a raw lock is safe.
> 
> Make the lock array static while at it.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Applied to sparc-next-2.6, thanks!
