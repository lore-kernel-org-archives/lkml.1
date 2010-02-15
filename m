Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab0BOGV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:21:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46096
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334Ab0BOGV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:21:57 -0500
Date: Sun, 14 Feb 2010 22:22:11 -0800 (PST)
Message-Id: <20100214.222211.91409708.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, peter.p.waskiewicz.jr@intel.com,
       jeffrey.t.kirsher@intel.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100215152009.c8f9949c.sfr@canb.auug.org.au>
References: <20100215152009.c8f9949c.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 15 Feb 2010 15:20:09 +1100

> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> usr/include/linux/ethtool.h:17: included file 'linux/rculist.h' is not exported
> 
> Caused by commit 15682bc488d4af8c9bb998844a94281025e0a333 ("ethtool:
> Introduce n-tuple filter programming support").
> 
> I have used the version of the net tree from next-20100212 for today.

I have a fix for that in my queue, thanks for reporting.
