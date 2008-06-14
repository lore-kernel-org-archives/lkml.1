Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYFNXYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYFNXYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 19:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbYFNXYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 19:24:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37455
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755092AbYFNXYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 19:24:30 -0400
Date: Sat, 14 Jun 2008 16:24:30 -0700 (PDT)
Message-Id: <20080614.162430.193006643.davem@davemloft.net>
To: arjan@infradead.org
Cc: mingo@elte.hu, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080614023916.431a868d@infradead.org>
References: <20080614.001428.26649070.davem@davemloft.net>
	<20080614081656.GA27820@elte.hu>
	<20080614023916.431a868d@infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Sat, 14 Jun 2008 02:39:16 -0700

> the interesting thing is that there is a clear bias on which drivers
> are tripping this (r8169 is top when I counted yesterday, with sis900
> second and then a long tail of nothing) that I think the WARN_ON() is
> useful in addition to the always-there printk. Eg it does help in seeing
> which driver is most likely to trigger this.
> (Andrew also thought this would trigger a *LOT*, so far it's only a
> rather modest amount, but it's waiting for Fedora or others to ship a
> kernel with this in to be sure)

I agree that it's useful and should stay.

One thing I noticed is that you can't tell which driver is
to blame just from the warning and backtrace.  Somehow getting
a driver name in that warning message would be useful and help
diagnose problems as well as make it easier for you to compute
those statistics.
