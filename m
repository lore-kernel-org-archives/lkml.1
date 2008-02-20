Return-Path: <linux-kernel-owner+w=401wt.eu-S1764118AbYBTA3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764118AbYBTA3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758863AbYBTA31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:29:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57918
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758093AbYBTA30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:29:26 -0500
Date: Tue, 19 Feb 2008 16:30:03 -0800 (PST)
Message-Id: <20080219.163003.152862383.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH v2][POWERPC] Fix initial lmb add region with a non-zero
 base
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0802191350590.10089@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0802191350590.10089@blarg.am.freescale.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Tue, 19 Feb 2008 13:51:37 -0600 (CST)

> If we add to an empty lmb region with a non-zero base we will not coalesce
> the number of regions down to one.  This causes problems on ppc32 for the
> memory region as its assumed to only have one region.
> 
> We can fix this easily by causing the initial add to replace the dummy
> region.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> 
> Fix a bug the initial patch introduced if we have a region that gets added
> at the beginning of the list we wouldn't actually add it.
> 
> Dave can you replace the patch in you tree with this one.

I think my tree has already or will soon be pulled in so
I don't want to rebase it.

Why don't you simply send me the relative bug fix instead?

Thanks!
