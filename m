Return-Path: <linux-kernel-owner+w=401wt.eu-S1763606AbXESGBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763606AbXESGBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 02:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbXESGBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 02:01:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38138
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756131AbXESGBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 02:01:24 -0400
Date: Fri, 18 May 2007 23:01:26 -0700 (PDT)
Message-Id: <20070518.230126.102616481.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: eteo@redhat.com, linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [2.6 patch] net/llc/llc_conn.c: fix possible NULL dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070518223005.91236c38.randy.dunlap@oracle.com>
References: <464E8763.3010609@redhat.com>
	<20070518223005.91236c38.randy.dunlap@oracle.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 18 May 2007 22:30:05 -0700

> Networking patches need to be sent to the netdev@vger.kernel.org
> mailing list  (and lkml can be omitted IMHO).
> 
> But... instead of doing the assignment and test in one swoop,
> we prefer:

In any event the patch is totally bogus because the
code checks to make sure skb_queue_len() != 0 first
so NULL cannot occur.
