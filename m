Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbYCTV1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbYCTV1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 17:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbYCTV0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 17:26:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38035
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755793AbYCTV0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 17:26:51 -0400
Date: Thu, 20 Mar 2008 14:27:07 -0700 (PDT)
Message-Id: <20080320.142707.170694458.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: sam@ravnborg.org, dsd@gentoo.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH/RFC v2] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig
 symbol
From: David Miller <davem@davemloft.net>
In-Reply-To: <1206048106.16475.161.camel@johannes.berg>
References: <1206038373.16475.150.camel@johannes.berg>
	<20080320.141307.173590705.davem@davemloft.net>
	<1206048106.16475.161.camel@johannes.berg>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 20 Mar 2008 22:21:46 +0100

> Yeah, good point. Should I rename it to HAVE_EFFICIENT_UNALIGNED_ACCESS
> or similar? Or have it defined as some sort of number so you can make
> actually make tradeoffs? Like Dave Woodhouse suggested at some point to
> have get_unaligned() take an argument that indicates the probability...

Yes, that name and something with a "score" of some sort would
be nice.

