Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0BLXiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:38:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46614
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816Ab0BLXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:38:53 -0500
Date: Fri, 12 Feb 2010 15:39:07 -0800 (PST)
Message-Id: <20100212.153907.71316958.davem@davemloft.net>
To: caoco2002@yahoo.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bug and question in tcp stack
From: David Miller <davem@davemloft.net>
In-Reply-To: <157135.69931.qm@web63405.mail.re1.yahoo.com>
References: <157135.69931.qm@web63405.mail.re1.yahoo.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Cao <caoco2002@yahoo.com>
Date: Fri, 12 Feb 2010 15:22:16 -0800 (PST)

> if (tcp_retransmit_skb(sk, tcp_write_queue_head(sk)) > 0) {
> 
> checks the return value as a positive number, which will never be true.

It can, recheck the code paths.

The upcall to send an SKB out through the packet schedular and onwards
to the actual device can return congestion notification values, which
are positive.
