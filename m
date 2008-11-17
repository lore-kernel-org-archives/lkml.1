Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYKQTvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYKQTvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYKQTvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:51:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46627
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbYKQTvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:51:08 -0500
Date: Mon, 17 Nov 2008 11:51:06 -0800 (PST)
Message-Id: <20081117.115106.195071813.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, dada1@cosmosbay.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0811171134480.18283@nehalem.linux-foundation.org>
References: <20081117161135.GE12081@elte.hu>
	<20081117.113158.200497613.davem@davemloft.net>
	<alpine.LFD.2.00.0811171134480.18283@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Nov 2008 11:47:24 -0800 (PST)

> For example, if I recall correctly, David had a big hit on the hrtimers. 

That got fixed, the HRTIMER bits are now disabled.

> The other possibility is that it's just a sparc suckiness issue, that 
> simply doesn't show up on x86. 

Could be and I intend to measure that to find out.
