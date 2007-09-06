Return-Path: <linux-kernel-owner+w=401wt.eu-S933013AbXIFUnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbXIFUnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXIFUkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:40:51 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:42338
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932749AbXIFUku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:40:50 -0400
Date: Thu, 06 Sep 2007 13:40:38 -0700 (PDT)
Message-Id: <20070906.134038.85411315.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, help@myri.com
Subject: Re: 2.6.23-rc4-mm1 myri10ge module link error on x86_64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070906193751.GA4518@Krystal>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	<20070906193751.GA4518@Krystal>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Thu, 6 Sep 2007 15:37:51 -0400

> I got a link error on myri10ge when building 2.6.23-rc4-mm1 on x86_64 :
> 
> ERROR: "lro_flush_all" [drivers/net/myri10ge/myri10ge.ko] undefined!
> ERROR: "lro_receive_frags" [drivers/net/myri10ge/myri10ge.ko] undefined!
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2
> make: *** [_all] Error 2

myri10ge needs some LRO ifdeffery.

