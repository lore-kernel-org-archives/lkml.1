Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbXKSLKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbXKSLKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 06:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbXKSLKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 06:10:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34882
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbXKSLKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 06:10:06 -0500
Date: Mon, 19 Nov 2007 03:10:05 -0800 (PST)
Message-Id: <20071119.031005.127194576.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, gregkh@suse.de,
       akpm@linux-foundation.org
Subject: Re: regression from softlockup fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071119094338.GA19271@elte.hu>
References: <20071119.012119.118043374.davem@davemloft.net>
	<20071119094338.GA19271@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 19 Nov 2007 10:43:38 +0100

> * David Miller <davem@davemloft.net> wrote:
> 
> > I suspect that what is happening is that the NOHZ period is longer 
> > than the softlockup timeout (10 seconds) and we get an interrupt 
> > before the watchdog thread gets onto the cpu.
> 
> indeed! Does the patch below do the trick?

I'm sure it works but it partly defeats the purpose of NOHZ.

I really like it that my cpus sleep completely for hours at a time
when not in use. :)

Anyways, I'll give your patch a test.
