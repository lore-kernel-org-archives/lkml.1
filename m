Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYDUKWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYDUKWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbYDUKV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:21:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32859
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753041AbYDUKV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:21:58 -0400
Date: Mon, 21 Apr 2008 03:22:00 -0700 (PDT)
Message-Id: <20080421.032200.209759978.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: mingo@elte.hu, dada1@cosmosbay.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: poor network loopback performance and scalability
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080421101908.GC9295@gondor.apana.org.au>
References: <20080421081103.GA31328@elte.hu>
	<20080421.011623.67335122.davem@davemloft.net>
	<20080421101908.GC9295@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 21 Apr 2008 18:19:08 +0800

> I belive the current value is a legacy from the days when we didn't
> support skb page frags so everything had to be physically contiguous.

It's legacy from when my top-of-the-line UltraSPARC-I 130Mhz cpus
got the best loopback results using that value :-)
