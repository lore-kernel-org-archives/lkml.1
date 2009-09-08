Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbZIHMiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbZIHMiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 08:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZIHMiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 08:38:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38416
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510AbZIHMiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 08:38:12 -0400
Date: Tue, 08 Sep 2009 05:38:28 -0700 (PDT)
Message-Id: <20090908.053828.161377056.davem@davemloft.net>
To: mingo@elte.hu
Cc: fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, jens.axboe@oracle.com
Subject: Re: [PATCH 0/2]: Get perf counters working on D-cache aliasing
 cpus.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090908123610.GA3515@elte.hu>
References: <20090908.051045.26522683.davem@davemloft.net>
	<20090908123610.GA3515@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 8 Sep 2009 14:36:10 +0200

> The only (small) worry would be that this uses vmalloc space on 
> 32-bit platforms which is generally a scarce resource.

Yes, I considered this too.

But as you said there are things that mitigate how much of
a real issue this actually is.
