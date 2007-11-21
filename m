Return-Path: <linux-kernel-owner+w=401wt.eu-S1765574AbXKUBiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765574AbXKUBiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758854AbXKUBiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:38:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51726
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758622AbXKUBiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:38:05 -0500
Date: Tue, 20 Nov 2007 17:38:04 -0800 (PST)
Message-Id: <20071120.173804.34897945.davem@davemloft.net>
To: the.sator@gmail.com
Cc: linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH][v2] net/ipv4/arp.c: Fix arp reply when sender ip 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <cac0ab7d0711200828n3548fadn48cce2837ed6a7c6@mail.gmail.com>
References: <cac0ab7d0711200828n3548fadn48cce2837ed6a7c6@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jonas Danielsson" <the.sator@gmail.com>
Date: Tue, 20 Nov 2007 17:28:22 +0100

> Fix arp reply when received arp probe with sender ip 0.
> 
> Send arp reply with target ip address 0.0.0.0 and target hardware address
> set to hardware address of requester. Previously sent reply with target
> ip address and target hardware address set to same as source fields.
> 
> 
> Signed-off-by: Jonas Danielsson <the.sator@gmail.com>
> Acked-by: Alexey Kuznetov <kuznet@ms2.inr.ac.ru>

I'm applying this but you gmail folks really have to get your
act together when submitting patches.  The patches from gmail
accounts come out corrupted 9 times out of 10.

This time line breaks were added and all tab characters were
turned into spaces.

Please correct this before any future patch submissions.
