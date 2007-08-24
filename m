Return-Path: <linux-kernel-owner+w=401wt.eu-S1762658AbXHXI00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762658AbXHXI00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 04:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbXHXI0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 04:26:19 -0400
Received: from mx12.go2.pl ([193.17.41.142]:56613 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756963AbXHXI0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 04:26:18 -0400
Date: Fri, 24 Aug 2007 10:27:25 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: irq lock inversion dependency detected
Message-ID: <20070824082725.GA2203@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708100906.07111.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-08-2007 09:06, Mariusz Kozlowski wrote:
> Hello,
> 
> 	And the winner of today is ...
> 
> 
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.23-rc2-mm1 #7
> ---------------------------------------------------------
> runscript.sh/5843 just changed the state of lock:
>  (_xmit_ETHER){-+..}, at: [<c03cbe79>] dev_watchdog+0x17/0xcc
> but this lock took another, soft-irq-unsafe lock in the past:
>  (&tp->lock){--..}
> 
> and interrupts could create inverse lock ordering between them.
...
> Really no idea who to CC here ;)

IMHO, this should be fixed by last changes to free_irq & request_irq.
(Seems to be possible only with CONFIG_DEBUG_SHIRQ?) Otherwise I can
be CC-ed - my pleasure!

Cheers,
Jarek P.
