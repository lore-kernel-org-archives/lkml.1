Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbXCEEiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbXCEEiE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXCEEiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:38:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36997
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752097AbXCEEiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:38:02 -0500
Date: Sun, 04 Mar 2007 20:38:00 -0800 (PST)
Message-Id: <20070304.203800.36941074.davem@davemloft.net>
To: npiggin@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070305042724.GB19783@wotan.suse.de>
References: <20070223153743.GA26141@wotan.suse.de>
	<20070304.201142.41654149.davem@davemloft.net>
	<20070305042724.GB19783@wotan.suse.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Mon, 5 Mar 2007 05:27:24 +0100

> Sounds great, I would be happy to help review it. If we can create a
> bit of common infrastructure, the dcache conversion might become a bit
> more palatable and we could look at other things like the inode hash
> as well.

Absolutely, I'll run my patch by you once I have it ready.

> The other thing you'll have to be careful of when looking at doing
> an implementation, is that I think I forgot to use the RCU accessors
> (rcu_assign_pointer, rcu_dereference) when assigning and loading
> the new/old hash table pointers.

Thanks for the heads-up.

