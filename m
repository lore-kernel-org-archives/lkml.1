Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbZK1G6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbZK1G6K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 01:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZK1G6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 01:58:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54936
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbZK1G6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 01:58:08 -0500
Date: Fri, 27 Nov 2009 22:58:21 -0800 (PST)
Message-Id: <20091127.225821.38680951.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: arnd@arndb.de, pmullaney@novell.com, kaber@trash.net,
       netdev@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] macvlan: support for guest vm direct rx/tx
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091127213824.53c5a23a@nehalam>
References: <200911280043.58784.arnd@arndb.de>
	<20091127.161957.243886653.davem@davemloft.net>
	<20091127213824.53c5a23a@nehalam>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 27 Nov 2009 21:38:24 -0800

> Maybe we should figure out a way for protocols to return new skb in netif_receive_skb
> to avoid extra softirq, but avoid stack overflow?

Eric Dumazet and I tried to find ways to handle this, please see the
archives.  It's not an easy problem to solve and none of the patches
we came up with avoided crashes under high stress scenarios.
