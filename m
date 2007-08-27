Return-Path: <linux-kernel-owner+w=401wt.eu-S965450AbXH0V5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965450AbXH0V5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764313AbXH0V4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:56:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46383
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756062AbXH0V4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:56:03 -0400
Date: Mon, 27 Aug 2007 14:56:00 -0700 (PDT)
Message-Id: <20070827.145600.102570576.davem@davemloft.net>
To: jchapman@katalix.com
Cc: shemminger@linux-foundation.org, ossthema@de.ibm.com, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <46D34517.4010505@katalix.com>
References: <46D2F301.7050105@katalix.com>
	<20070827.140251.95055210.davem@davemloft.net>
	<46D34517.4010505@katalix.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Chapman <jchapman@katalix.com>
Date: Mon, 27 Aug 2007 22:41:43 +0100

> I don't recall saying anything in previous posts about this. Are you 
> confusing my posts with Jan-Bernd's?

Yes, my bad.

> Jan-Bernd has been talking about using hrtimers to _reschedule_
> NAPI. My posts are suggesting an alternative mechanism that keeps
> NAPI active (with interrupts disabled) for a jiffy or two after it
> would otherwise have gone idle in order to avoid too many interrupts
> when the packet rate is such that NAPI thrashes between poll-on and
> poll-off.

So in this scheme what runs ->poll() to process incoming packets?
The hrtimer?
