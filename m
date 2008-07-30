Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYG3G4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYG3G4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 02:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYG3G41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 02:56:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55817
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbYG3G40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 02:56:26 -0400
Date: Tue, 29 Jul 2008 23:56:23 -0700 (PDT)
Message-Id: <20080729.235623.211977761.davem@davemloft.net>
To: mingo@elte.hu
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: combinatorial explosion in lockdep
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080729.214503.126934382.davem@davemloft.net>
References: <20080728235133.GA7956@elte.hu>
	<20080728.174415.154327359.davem@davemloft.net>
	<20080729.214503.126934382.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 29 Jul 2008 21:45:03 -0700 (PDT)

> If we can agree on this as a fix, it should definitely be backported
> and submitted for -stable :-)
> 
> ----------------------------------------
> 
> lockdep: Fix combinatorial explosion in lock subgraph traversal.

So the next problem I run into is that 8192 is not a large
enough MAX_LOCKDEP_ENTRIES for this larger cpu count boxes.
8192 isn't even big enough for my 64 cpu box.

It needs to be scaled by NR_CPUS, or something like that.
