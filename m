Return-Path: <linux-kernel-owner+w=401wt.eu-S933086AbXHJIg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbXHJIg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbXHJIgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:36:47 -0400
Received: from mx10.go2.pl ([193.17.41.74]:45730 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753673AbXHJIgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:36:45 -0400
Date: Fri, 10 Aug 2007 10:37:21 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Jean-Baptiste Vignaud <vignaud@xandmail.fr>
Cc: "marcin\.slusarz" <marcin.slusarz@gmail.com>, mingo <mingo@elte.hu>,
       tglx <tglx@linutronix.de>, torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch (testing)] Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070810083720.GE1764@ff.dom.local>
References: <JMJTMH$F1699B57C9B0E170ED337488612E649B@xandmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <JMJTMH$F1699B57C9B0E170ED337488612E649B@xandmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 10:15:53AM +0200, Jean-Baptiste Vignaud wrote:
...
> I was still testing on -rc2:
> Subject: [patch] genirq: temporary fix for level-triggered IRQ resend
> Date: Wed, 8 Aug 2007 13:00:37 +0200
> 
> For me after 1day 20hours, the network is still up, with more than 1To
> of network traffic. HZ was 1000, i restart with HZ=100.

For me it's enough too but Thomas seems to doubt.

You've written earlier that you've 2.6.23-rc1 with HARDIRQS_SW_RESEND
prepared too. So, if this is not a great problem maybe you could try
this first. Tomorrow Thomas may send something, so this 100HZ could
wait yet, I hope?

Many thanks,
Jarek P.
