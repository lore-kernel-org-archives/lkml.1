Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbXESDuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbXESDuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 23:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbXESDus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 23:50:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53624 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbXESDus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 23:50:48 -0400
Message-ID: <464E7409.6020505@garzik.org>
Date: Fri, 18 May 2007 23:50:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>, Phillip Susi <psusi@cfl.rr.com>,
       Alex Volkov <avcp-lkmail@usa.net>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: aio is unlikely
References: <20070509151831.f5956b66.akpm@linux-foundation.org>	<058f01c7998e$1406e370$650df7cd@MUMBA>	<20070518140624.1a4db517.akpm@linux-foundation.org>	<464E2098.8020900@cfl.rr.com> <20070518151259.319e09da.akpm@linux-foundation.org> <464E2AA6.3080402@garzik.org> <464E7254.60406@yahoo.com.au>
In-Reply-To: <464E7254.60406@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Aside from using branch constructs or hints that help the predictor
> guess the right way... I think gcc will move unlikely paths right past
> the end of the "likely" fastpath, so it can increase code size and be
> somewhat suboptimal in terms of icache usage.

Thanks for the reminder.  GCC definitely does code movement.

ISTR the code movement might even be "extreme", once the unit-at-a-time 
support arrived, placing "cold" code at the end of the compiled module.

	Jeff


