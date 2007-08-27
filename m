Return-Path: <linux-kernel-owner+w=401wt.eu-S1763326AbXH0Uht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763326AbXH0Uht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759654AbXH0UhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:37:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39978
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758100AbXH0UhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:37:23 -0400
Date: Mon, 27 Aug 2007 13:37:21 -0700 (PDT)
Message-Id: <20070827.133721.59473971.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: jchapman@katalix.com, shemminger@linux-foundation.org, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <200708271147.01890.ossthema@de.ibm.com>
References: <46D1D634.7060007@katalix.com>
	<20070826.185815.93042514.davem@davemloft.net>
	<200708271147.01890.ossthema@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Bernd Themann <ossthema@de.ibm.com>
Date: Mon, 27 Aug 2007 11:47:01 +0200

> So the question is simply: Do we want drivers that need (benefit
> from) a timer based polling support to implement their own timers
> each, or should there be a generic support?

I'm trying to figure out how an hrtimer implementation would
even work.

Would you start the timer from the chip interrupt handler?  If so,
that's taking two steps backwards as you've already taken all of the
overhead of running the interrupt handler.
