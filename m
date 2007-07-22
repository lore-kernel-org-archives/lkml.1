Return-Path: <linux-kernel-owner+w=401wt.eu-S1763400AbXGVKKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763400AbXGVKKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 06:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbXGVKKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 06:10:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49941 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXGVKKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 06:10:39 -0400
Date: Sun, 22 Jul 2007 12:10:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Miller <davem@davemloft.net>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] CONFIG_NET=n - lots of link time errors
In-Reply-To: <20070721.191223.15264470.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0707221206280.15705@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707211817490.21737@fbirervta.pbzchgretzou.qr>
 <20070721.191223.15264470.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 21 2007 19:12, David Miller wrote:
>> Enabling drivers from "Devices > Networking" (in menuconfig), for 
>> example SLIP and/or PLIP, throws link time errors when CONFIG_NET itself 
>> is =n. Have CONFIG_NETDEVICES depend on CONFIG_NET.
>> 
>> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>
>This is the second time I've seen this change in the past few
>days, and people seem to hit it quite readily with randconfig.
>
>It seems reasonable and I'll apply it, thanks Jan.

While randconfig is nice and good, this error actually came by manually
tuning the .config for a specific goal (namely: make a small kernel for an
ancient i386 without modifying any code). Turning off CONFIG_NET
was then just an idea away, because I knew that TCP was quite big.


	Jan
-- 
