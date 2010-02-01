Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab0BAKGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:06:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38689
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910Ab0BAKGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:06:09 -0500
Date: Mon, 01 Feb 2010 02:06:22 -0800 (PST)
Message-Id: <20100201.020622.91421099.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       eric.dumazet@gmail.com
Subject: Re: [Patch v2] net: export TCP send buffer size via netlink
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100201.020055.57470143.davem@davemloft.net>
References: <20100201092153.4194.91507.sendpatchset@localhost.localdomain>
	<20100201.020055.57470143.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Before you spend the next couple hours trying to figure out what to
do...

We already provide the information you're trying to export via
linux/inet_diag.h:inet_diag_meminfo

I hope the light goes on now :-)



