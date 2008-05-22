Return-Path: <linux-kernel-owner+w=401wt.eu-S937810AbYEVAfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937810AbYEVAfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763783AbYEVAf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:35:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49676
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933081AbYEVAf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:35:28 -0400
Date: Wed, 21 May 2008 17:35:21 -0700 (PDT)
Message-Id: <20080521.173521.265981118.davem@davemloft.net>
To: crquan@gmail.com
Cc: harvey.harrison@gmail.com, herbert@gondor.apana.org.au,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv4/arp.c: Use the exported hex_asc from
 lib/hexdump.c instead
From: David Miller <davem@davemloft.net>
In-Reply-To: <91b13c310805201927k4fccf8dcwa3fabe61777b2eda@mail.gmail.com>
References: <1211323212.5915.220.camel@brick>
	<20080520.154551.54365414.davem@davemloft.net>
	<91b13c310805201927k4fccf8dcwa3fabe61777b2eda@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "rae l" <crquan@gmail.com>
Date: Wed, 21 May 2008 10:27:41 +0800

> net/ipv4/arp.c: Use common hex_asc helpers
> 
> Here the local hexbuf is a duplicate of global const char hex_asc from
> lib/hexdump.c, except the hex letters' cases:
> 
> 	const char hexbuf[] = "0123456789ABCDEF";
> 
> 	const char hex_asc[] = "0123456789abcdef";
> 
> and here to print HW addresses, the hex cases are not significant.
> 
> Thanks to Harvey Harrison to introduce the hex_asc_hi/hex_asc_lo helpers.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Applied, thanks.

Harvey I know you posted a nearly identical patch, I had
to choose one and he did credit you with the idea for the
updated patch, so I hope this is OK.

Thanks.
