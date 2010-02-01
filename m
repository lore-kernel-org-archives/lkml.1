Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab0BAJ6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 04:58:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48365
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011Ab0BAJ6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 04:58:00 -0500
Date: Mon, 01 Feb 2010 01:58:12 -0800 (PST)
Message-Id: <20100201.015812.21220633.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Patch] net: export TCP send buffer size via netlink
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100201080256.4084.30962.sendpatchset@localhost.localdomain>
References: <20100201080256.4084.30962.sendpatchset@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Mon, 1 Feb 2010 02:59:32 -0500

> 
> Currently, we can only get TCP send buffer size by
> getsockopt (SO_SNDBUF or TCP_INFO), this is not enough
> for the tools like netstat or ss to read.
> 
> Show TCP send buffer size via netlink NETLINK_INET_DIAG.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: David Miller <davem@davemloft.net>

You can't change the layout of struct tcp_info, it's
hard coded into applications.
