Return-Path: <linux-kernel-owner+w=401wt.eu-S1760364AbZFIMWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364AbZFIMWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZFIMVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:21:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41150
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758895AbZFIMVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:21:48 -0400
Date: Tue, 09 Jun 2009 05:21:50 -0700 (PDT)
Message-Id: <20090609.052150.253563947.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: mingo@elte.hu, vegard.nossum@gmail.com, john.dykstra1@gmail.com,
       netdev@vger.kernel.org, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, jpirko@redhat.com
Subject: Re: [PATCH net-next-2.6] net: dev_addr_init() fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A2D16E4.3030702@gmail.com>
References: <4A2D006C.70302@cosmosbay.com>
	<20090608130653.GB3272@elte.hu>
	<4A2D16E4.3030702@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 08 Jun 2009 15:49:24 +0200

> [PATCH net-next-2.6] net: dev_addr_init() fix
> 
> commit f001fde5eadd915f4858d22ed70d7040f48767cf 
> (net: introduce a list of device addresses dev_addr_list (v6))
> added one regression Vegard Nossum found in its testings.
> 
> With kmemcheck help, Vegard found some uninitialized memory
> was read and reported to user, potentialy leaking kernel data.
> ( thread can be found on http://lkml.org/lkml/2009/5/30/177 )
> 
> dev_addr_init() incorrectly uses sizeof() operator. We were
> initializing one byte instead of MAX_ADDR_LEN bytes.
> 
> Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Acked-by: Jiri Pirko <jpirko@redhat.com>

Applied, thanks.
