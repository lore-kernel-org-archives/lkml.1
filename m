Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbZAEEvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbZAEEvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 23:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZAEEvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 23:51:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43774 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbZAEEvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 23:51:39 -0500
Date: Mon, 5 Jan 2009 06:05:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
       snakebyte@gmx.de, akpm@linux-foundation.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, manfred@colorfullife.com, laijs@cn.fujitsu.com
Subject: Re: [PATCH] Fix rcutree grace-period-latency bug on small systems
Message-ID: <20090105050529.GH496@one.firstfloor.org>
References: <20090105043006.GA22049@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105043006.GA22049@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The following patch properly updates the ->signaled field for the
> "small"-system case (no more than 32 CPUs for 32-bit kernels and no more
> than 64 CPUs for 64-bit kernels).
> 
> I believe that this patch should be included for 2.6.29.

Yes, it's really needed. One of my test system takes forever to boot
without it when tree rcu is enabled.

Thanks Paul for the debugging work.

-Andi

