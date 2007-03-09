Return-Path: <linux-kernel-owner+w=401wt.eu-S2993062AbXCIHbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993062AbXCIHbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993065AbXCIHbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:31:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46276
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2993062AbXCIHbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:31:11 -0500
Date: Thu, 08 Mar 2007 23:31:10 -0800 (PST)
Message-Id: <20070308.233110.71091192.davem@davemloft.net>
To: amit2030@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/wanrouter/wanmain.c: check kmalloc() return value.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070308232654.d0334ccd.amit2030@gmail.com>
References: <20070308232654.d0334ccd.amit2030@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Choudhary <amit2030@gmail.com>
Date: Thu, 8 Mar 2007 23:26:54 -0800

> Description: Check the return value of kmalloc() in function dbg_kmalloc(), in file net/wanrouter/wanmain.c.
> 
> Signed-off-by: Amit Choudhary <amit2030@gmail.com>

There is no reason for any subsystem to implement it's
own debugging allocator when we have one that works
perfectly fine already in SLAB.

So to fix this we should simply remove all of the
allocation debugging code here.
