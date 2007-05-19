Return-Path: <linux-kernel-owner+w=401wt.eu-S1762051AbXESF7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762051AbXESF7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbXESF72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:59:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47046
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbXESF72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:59:28 -0400
Date: Fri, 18 May 2007 22:59:30 -0700 (PDT)
Message-Id: <20070518.225930.80030089.davem@davemloft.net>
To: eteo@redhat.com
Cc: linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [2.6 patch] net/llc/llc_conn.c: fix possible NULL dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <464E8763.3010609@redhat.com>
References: <464E8763.3010609@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eugene Teo <eteo@redhat.com>
Date: Sat, 19 May 2007 13:13:07 +0800

> skb_peek() might return an empty list. skb should be checked before calling
> llc_pdu_sn_hdr() with it.
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Eugene Teo <eteo@redhat.com>

The code checks skb_queue_len() for zero first, therefore NULL is
impossible.

Can you check this kind of stuff before submitting patches like this?

Thank you.
