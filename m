Return-Path: <linux-kernel-owner+w=401wt.eu-S966107AbZLHUvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966107AbZLHUvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966079AbZLHUvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:51:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966033AbZLHUvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:51:19 -0500
Date: Tue, 8 Dec 2009 12:51:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
In-Reply-To: <20091208194530.GA24530@elte.hu>
Message-ID: <alpine.LFD.2.00.0912081249060.3560@localhost.localdomain>
References: <20091205.193505.193701079.davem@davemloft.net> <20091208194530.GA24530@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Dec 2009, Ingo Molnar wrote:

> 
> hi Dave,
> 
> i just switched to today's -git tree and there's this new build failure 
> on x86:
> 
>  net/sctp/sysctl.c:251: error: unknown field 'strategy' specified in initializer
>  net/sctp/sysctl.c:251: error: 'sysctl_intvec' undeclared here (not in a function)
> 
> havent looked into it yet - config attached.

That's my mismerge. I should have removed the strategy field too, not just 
the ctr_name. My bad, will fix up,

		Linus
