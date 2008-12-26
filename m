Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbYLZBUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbYLZBUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 20:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYLZBUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 20:20:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60920
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbYLZBUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 20:20:36 -0500
Date: Thu, 25 Dec 2008 17:20:38 -0800 (PST)
Message-Id: <20081225.172038.123581783.davem@davemloft.net>
To: vegard.nossum@gmail.com
Cc: tgraf@suug.ch, eugeneteo@kernel.sg, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: fix (theoretical) overrun in message iteration
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081221134218.GA7959@localhost.localdomain>
References: <20081221134218.GA7959@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sun, 21 Dec 2008 14:42:18 +0100

> netlink: fix (theoretical) overrun in message iteration

I'll apply this but we should also consider getting rid
of unused interfaces such as nlmsg_for_each_msg().

