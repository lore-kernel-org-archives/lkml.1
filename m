Return-Path: <linux-kernel-owner+w=401wt.eu-S966086AbZLHUua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966086AbZLHUua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937890AbZLHUu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:50:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35864
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937868AbZLHUu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:50:26 -0500
Date: Tue, 08 Dec 2009 12:50:32 -0800 (PST)
Message-Id: <20091208.125032.70743046.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091208194530.GA24530@elte.hu>
References: <20091205.193505.193701079.davem@davemloft.net>
	<20091208194530.GA24530@elte.hu>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 8 Dec 2009 20:45:30 +0100

> i just switched to today's -git tree and there's this new build failure 
> on x86:
> 
>  net/sctp/sysctl.c:251: error: unknown field 'strategy' specified in initializer
>  net/sctp/sysctl.c:251: error: 'sysctl_intvec' undeclared here (not in a function)
> 
> havent looked into it yet - config attached.

It's probably a conflict with Eric Beiderman's sysctl cleanups that
got merged in at the same time.
