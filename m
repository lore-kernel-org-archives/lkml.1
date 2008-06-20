Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYFTVUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYFTVUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbYFTVUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:20:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50224
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbYFTVUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:20:35 -0400
Date: Fri, 20 Jun 2008 14:20:34 -0700 (PDT)
Message-Id: <20080620.142034.30884440.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806201707270.8990@engineering.redhat.com>
References: <Pine.LNX.4.64.0806201143110.8789@engineering.redhat.com>
	<20080620.102601.06998427.davem@davemloft.net>
	<Pine.LNX.4.64.0806201707270.8990@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 20 Jun 2008 17:14:41 -0400 (EDT)

> Are you sure? What about this:
> ide-io.c:ide_intr
>          if (drive->unmask)
>                  local_irq_enable_in_hardirq();
> 
> or this:
> kernel/irq/handle.c:handle_IRQ_event
>          if (!(action->flags & IRQF_DISABLED))
>                  local_irq_enable_in_hardirq();
> 
> 
> --- how is number of nested interrupts here supposed to be limited?
> 
> If these things are not limited, you get at most as many nested handlers 
> as there are hardware interrupts, which means crash.

It means i386 and every other platform potentially has the same exact
problem.

What point wrt. sparc64 are you trying to make here? :-)


