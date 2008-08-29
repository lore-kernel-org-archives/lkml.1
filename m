Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbYH2P2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbYH2P2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbYH2P15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:27:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40740 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbYH2P14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:27:56 -0400
Date: Fri, 29 Aug 2008 17:30:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joe Malicki <jmalicki@metacarta.com>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       johnpol@2ka.mipt.ru, dada1@cosmosbay.com, denys@visp.net.lb,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       juhlenko@akamai.com, sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Message-ID: <20080829153036.GV26610@one.firstfloor.org>
References: <20080828072218.GI26610@one.firstfloor.org> <32566205.1357331220023286187.JavaMail.root@ouachita>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32566205.1357331220023286187.JavaMail.root@ouachita>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That adds variance, and packets aren't comparable because they may
> suffer different kernel/hardware delays.

And there are no "different kernel/hardware delays" in the network?

If your RTT measurement method cannot handle some variance (using
standard sampling and data smoothing techniques similar to TCP) then it 
just needs to be fixed.

Besides measuring in the interrupt handler doesn't protect you
against local variances anyways because the interrupt timing has variability
(e.g due to irq off regions or due to interrupt mitigation or
higher priority interrupts) too

> > Yes, but why ignore local scheduling delays? 
> 
> Because one would want to ignore even network scheduling delays
> if possible... unfortunately in some instances it's not.

The local delays add to the user experience too.
It's unclear why you want to ignore those.

-Andi

-- 
ak@linux.intel.com

