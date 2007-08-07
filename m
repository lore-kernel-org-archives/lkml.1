Return-Path: <linux-kernel-owner+w=401wt.eu-S965213AbXHGVnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965213AbXHGVnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937011AbXHGVTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:19:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45884 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936995AbXHGVTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:19:10 -0400
Message-ID: <46B8E1C1.8040903@garzik.org>
Date: Tue, 07 Aug 2007 17:18:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: mingo@elte.hu, csnook@redhat.com, atl1-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       nando@ccrma.Stanford.EDU, tglx@linutronix.de, brbrofsvl@gmail.com
Subject: Re: [PATCH] atl1: use spin_trylock_irqsave()
References: <11859268222715-git-send-email-jacliburn@bellsouth.net>
In-Reply-To: <11859268222715-git-send-email-jacliburn@bellsouth.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> From: Ingo Molnar <mingo@elte.hu>
> 
> use the simpler spin_trylock_irqsave() API to get the adapter lock.
> 
> [ this is also a fix for -rt where adapter->lock is a sleeping lock. ]
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> ---
>  drivers/net/atl1/atl1_main.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)

applied to #upstream-fixes


