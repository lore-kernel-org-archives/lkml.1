Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbXEUIap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbXEUIap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbXEUIai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:30:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41235
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754375AbXEUIah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:30:37 -0400
Date: Mon, 21 May 2007 01:30:39 -0700 (PDT)
Message-Id: <20070521.013039.95059901.davem@davemloft.net>
To: mingo@elte.hu
Cc: kernel@prachanda.info, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: bad networking related lag in v2.6.22-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070521082805.GA17740@elte.hu>
References: <20070521075824.GA11198@elte.hu>
	<20070521.012541.112621369.davem@davemloft.net>
	<20070521082805.GA17740@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 21 May 2007 10:28:05 +0200

> the problem first showed up in v2.6.22-rc1 and he didnt have it in 
> v2.6.21 - does that still qualify his box for the 3c59x problem?

If the latency is showing up in /proc/net/tcp dumping, it's not the
3c59x problem.

Please just discard any latency trace that shows symbols from that
code, really.
