Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYGYIXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYGYIXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYGYIXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:23:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33230
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbYGYIXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:23:22 -0400
Date: Fri, 25 Jul 2008 01:23:21 -0700 (PDT)
Message-Id: <20080725.012321.19139111.davem@davemloft.net>
To: mingo@elte.hu
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ecashin@coraid.com,
       axboe@suse.de, mike.miller@hp.com, a.p.zijlstra@chello.nl, rjw@sisk.pl
Subject: Re: [lockdep warning] AOE / networking: aoenet_xmit:
 noop_qdisc.q.lock, INFO: inconsistent lock state at 0000000000000370
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080725072624.GA21824@elte.hu>
References: <20080725062009.GA6476@elte.hu>
	<20080724.232521.193699299.davem@davemloft.net>
	<20080725072624.GA21824@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 25 Jul 2008 09:26:24 +0200

> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Fri, 25 Jul 2008 08:20:09 +0200
> > 
> > > not sure whether it got reported already, but -tip testing triggered 
> > > this new ATA over Ethernet lockdep warning on latest -git:
> > 
> > Thanks for the report, does this fix it?
> 
> i've tested it and the warning went away - thanks David!
> 
> Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks for testing.
