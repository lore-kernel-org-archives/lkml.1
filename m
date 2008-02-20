Return-Path: <linux-kernel-owner+w=401wt.eu-S1764451AbYBTW5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764451AbYBTW5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYBTW5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:57:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42326
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbYBTW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:57:19 -0500
Date: Wed, 20 Feb 2008 14:57:56 -0800 (PST)
Message-Id: <20080220.145756.63719432.davem@davemloft.net>
To: bfields@fieldses.org
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080220222530.GK30160@fieldses.org>
References: <20080220212302.GJ30160@fieldses.org>
	<20080220.134257.41491836.davem@davemloft.net>
	<20080220222530.GK30160@fieldses.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@fieldses.org>
Date: Wed, 20 Feb 2008 17:25:30 -0500

> The advantages include earlier warning of merge problems, and avoidance
> of duplicate commits--if Jeff's done work that depends on patches that
> already upstream, then he either does that work against upstream, or
> includes backported patches in the branch he asks you to pull, and you
> end up with both the original and the backported patch.  Which isn't the
> end of the world, but the resulting history seems messier than
> necessary.
> 
> Or I guess you could both wait to do this merge until you're ready to
> pull in Linus's latest?

I do a test pull and build of net-2.6 into Linus's current tree
before I send Linus a pull request.

If any non-trivial merges are necessary, which hasn't happened yet at
all, I would then do a merge into my net-2.6 tree and resolve the
conflicts.

There is no reason for someone downstream of net-2.6 to do this.

