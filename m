Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZDUItq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZDUItq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbZDUItd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:49:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43153
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753475AbZDUItc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:49:32 -0400
Date: Tue, 21 Apr 2009 01:49:23 -0700 (PDT)
Message-Id: <20090421.014923.169153421.davem@davemloft.net>
To: laijs@cn.fujitsu.com
Cc: zbr@ioremap.net, shemminger@vyatta.com, dada1@cosmosbay.com,
       paulus@samba.org, paulmck@linux.vnet.ibm.com, kaber@trash.net,
       torvalds@linux-foundation.org, jeff.chua.linux@gmail.com, mingo@elte.hu,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
From: David Miller <davem@davemloft.net>
In-Reply-To: <49ED8700.3010603@cn.fujitsu.com>
References: <49ED6D2E.5060808@cn.fujitsu.com>
	<20090421081649.GA16782@ioremap.net>
	<49ED8700.3010603@cn.fujitsu.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Tue, 21 Apr 2009 16:42:40 +0800

> softirq is always not nesting. Why we need recursive lock?

Netfilter itself, is nesting.

When using bridging netfilter, iptables can be entered twice
in the same call chain.
