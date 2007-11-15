Return-Path: <linux-kernel-owner+w=401wt.eu-S1763964AbXKOLFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763964AbXKOLFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbXKOLF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:05:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36524
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbXKOLF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:05:28 -0500
Date: Thu, 15 Nov 2007 03:05:28 -0800 (PST)
Message-Id: <20071115.030528.86455332.davem@davemloft.net>
To: mingo@elte.hu
Cc: mpm@selenic.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071115110325.GA15109@elte.hu>
References: <20071115104331.GA11390@elte.hu>
	<20071115.025158.254212538.davem@davemloft.net>
	<20071115110325.GA15109@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 15 Nov 2007 12:03:25 +0100

> now that it's reproducible again i'll try more direct debugging. 
> (Networking might not even be the cause of this - that was just a quick 
> first impression that i had.)
> 
> Btw., the .config is the result of automated "make randconfig" x86 
> bootup testing QA, so there might be weird combinations in the .config. 
> That's how SLOB got randomly enabled in the first place, i dont normally 
> use SLOB kernels.

Check out Nick Piggin's SLOB bug fix, I think it is a good
lead :-)
