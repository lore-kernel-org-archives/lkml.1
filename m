Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbYCEXC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbYCEXC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765609AbYCEWzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:55:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44618
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1765308AbYCEWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:55:21 -0500
Date: Wed, 05 Mar 2008 14:55:20 -0800 (PST)
Message-Id: <20080305.145520.241264097.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for March 5
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080305204708.6834c627.sfr@canb.auug.org.au>
References: <20080305204708.6834c627.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 5 Mar 2008 20:47:08 +1100

> We are up to 42 trees, more are welcome (even if they are currently
> empty).  The influx of new trees has been underwhelming.  Thanks to those
> who have contributed, and to those who haven't, please do.

Feel free to start pulling in:

git://git.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.26.git#master

I just did a test pull into the current linux-next.

There was one conflict, net/tipc/socket.c, which has been converted
from semaphores to mutexes.  It conflicts with the generic semaphores
change, and essentially you can simply remove the generic semaphore
modifications to this file when you build the next tree since the
net-2.6.26 tree changes these TIPC bits to not use semaphores any
more.

The result builds cleanly allmodconfig on sparc64.
