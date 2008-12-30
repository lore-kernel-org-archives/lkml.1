Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbYL3HEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbYL3HEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYL3HEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:04:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53171
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbYL3HEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:04:36 -0500
Date: Mon, 29 Dec 2008 23:04:38 -0800 (PST)
Message-Id: <20081229.230438.90548187.davem@davemloft.net>
To: mingo@elte.hu
Cc: herbert@gondor.apana.org.au, a.p.zijlstra@chello.nl,
       emil.s.tantilov@intel.com, jeffrey.t.kirsher@intel.com,
       netdev@vger.kernel.org, peter.p.waskiewicz.jr@intel.com,
       alexander.h.duyck@intel.com, dada1@cosmosbay.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] locking, percpu counters: introduce separate lock
 classes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081230065650.GD30975@elte.hu>
References: <20081230060536.GG11037@elte.hu>
	<20081229.223945.149941966.davem@davemloft.net>
	<20081230065650.GD30975@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 30 Dec 2008 07:56:50 +0100

> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Tue, 30 Dec 2008 07:05:36 +0100
> > 
> > > One small nit: could you please add the Reported-by line for Jeff Kirscher 
> > > who reported the problem originally:
> > > 
> > >  Reported-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > 
> > I'll make sure to add that to the commit message after
> > you successfully test Herbert's patch.
> > 
> > Thanks.
> 
> early indications are good: after about 15 random bootup tests the lockdep 
> warning has not triggered. (it would trigger on every 2nd kernel before 
> that - there's a 66% chance for lockdep to be enabled in my randconfig 
> tests)

Sounds good.  I'll toss this into my net-2.6 tree, with Jeff's
reported-by and your Tested-by, and send this off to Linus
tonight.

Thanks everyone.
