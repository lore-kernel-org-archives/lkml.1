Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbZHRAD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbZHRAD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 20:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZHRAD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 20:03:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36563
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837AbZHRAD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 20:03:26 -0400
Date: Mon, 17 Aug 2009 17:03:37 -0700 (PDT)
Message-Id: <20090817.170337.139340805.davem@davemloft.net>
To: mingo@elte.hu
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, akpm@linux-foundation.org,
       nhorman@tuxdriver.com, rostedt@goodmis.org
Subject: Re: [PATCH -next] trace_skb: fix build when CONFIG_NET is not
 enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090817230654.GC16222@elte.hu>
References: <4A89BF90.5070202@oracle.com>
	<20090817.160041.40869355.davem@davemloft.net>
	<20090817230654.GC16222@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 18 Aug 2009 01:06:54 +0200

> ... but these are the wrong patches, they should be removed or 
> reverted and redone properly.

Given the number of users of net-next-2.6, removal via rebasing is
simply not an option.  The other two posibilities, sure...

> It's not just about keeping kernel/trace/* changes in the tracing 
> tree (which we can relax on-demand given agreement), it's that 
> these patches are also _wrong_ and we cannot relax anything about 
> that.

Why don't we give Neil a chance to review the situation and fix things
up?

If revert is the final decision, that's fine, I'll revert everything.

But in the mean time at least give Neil a chance to read all of your
feedback and coordinate a way to fix things with everyone.
