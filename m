Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbXIHIWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbXIHIWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 04:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXIHIWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 04:22:23 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:58570
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbXIHIWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 04:22:23 -0400
Date: Sat, 08 Sep 2007 01:22:14 -0700 (PDT)
Message-Id: <20070908.012214.41650322.davem@davemloft.net>
To: dwalker@mvista.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: myri10ge: force select inet_lro
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070907202625.702755508@mvista.com>
References: <20070907202625.702755508@mvista.com>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@mvista.com>
Date: Fri, 07 Sep 2007 13:26:25 -0700

> This driver uses the inet_lro facilities , but it doesn't force it
> to be enabled .. Someone would have to know to enable inet_lro if
> they select the driver .. 
> 
> Instead, just force INET_LRO if this driver is selected..
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>

I put this exact fix into the net-2.6.24 tree several days ago
already, it's not nice that you didn't even bother checking.

When I saw the response to the help@ address, I could almost predict
that the myri10ge developers would not even check if net-2.6.24 had
the issue cured already.

Therefore, your patch doesn't even apply to the tree where it is
relevant.  That sucks.
