Return-Path: <linux-kernel-owner+w=401wt.eu-S932742AbXBTJa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbXBTJa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 04:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbXBTJaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 04:30:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57706
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932508AbXBTJaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 04:30:55 -0500
Date: Tue, 20 Feb 2007 01:30:53 -0800 (PST)
Message-Id: <20070220.013053.78711208.davem@davemloft.net>
To: joe.jin@oracle.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [ipv6]: adjust inet6_exit() cleanup sequence against
 inet6_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070209093424.GA7078@joejin-pc.cn.oracle.com>
References: <20070209093424.GA7078@joejin-pc.cn.oracle.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Jin <joe.jin@oracle.com>
Date: Fri, 9 Feb 2007 17:34:24 +0800

> This patch for adjust inet6_exit() to inverse sequence to inet6_init().
> 
> At ipv6_init, it first create proc_root/net/dev_snmp6 entry by call
> ipv6_misc_proc_init(), then call addrconf_init() to create the corresponding
> device entry at this directory, but at inet6_exit, ipv6_misc_proc_exit()
> called first, then call addrconf_init().
> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>

Good thing ipv6 can never be unloaded :-)

Nevertheless, if the unload exit function exists, it ought
to be correct.

Patch applied, thank you.
