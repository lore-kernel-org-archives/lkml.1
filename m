Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZIIAhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZIIAhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbZIIAhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:37:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58810
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354AbZIIAhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:37:35 -0400
Date: Tue, 08 Sep 2009 17:37:50 -0700 (PDT)
Message-Id: <20090908.173750.152790322.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: nbd@openwrt.org, mingo@elte.hu, mb@bu3sch.de, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: David Miller <davem@davemloft.net>
In-Reply-To: <1252456102.26522.22.camel@pasglop>
References: <1252403400.4950.81.camel@pasglop>
	<4AA6579C.2080607@openwrt.org>
	<1252456102.26522.22.camel@pasglop>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 09 Sep 2009 10:28:22 +1000

>> The TLB is SW loaded, yes. However it should not do any misses on kernel
>> space, since the whole segment is in a wired TLB entry.
> 
> Including vmalloc space ?

No, MIPS does take SW tlb misses on vmalloc space. :-)

