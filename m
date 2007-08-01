Return-Path: <linux-kernel-owner+w=401wt.eu-S1759725AbXHABlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725AbXHABlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761321AbXHABlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:41:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48838
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760998AbXHABlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:41:18 -0400
Date: Tue, 31 Jul 2007 18:41:19 -0700 (PDT)
Message-Id: <20070731.184119.41636411.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       rostedt@goodmis.org, sripathik@in.ibm.com
Subject: Re: [RESEND] [BUG] futex_unlock_pi() hurts my brain and may cause
 application deadlock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1185926019.8850.198.camel@localhost>
References: <1180572567.6126.44.camel@localhost.localdomain>
	<1185926019.8850.198.camel@localhost>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>
Date: Tue, 31 Jul 2007 16:53:39 -0700

> 	I sent this fix for this back in the 2.6.21-rt9 era, and I thought to
> picked it up, but I think it arrived amid some futex churn and
> apparently has been dropped or was just lost.
> 
> Some of our testers have been reporting futex deadlocks and this fix
> resolves it, so I believe it to still be needed.

This bug seems to exist in mainline too.

Sparc users have been seeing something that smells like this
bug, I will ask them to test this fix out.
