Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0CBCji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 21:39:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33881
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771Ab0CBCjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 21:39:36 -0500
Date: Mon, 01 Mar 2010 18:39:55 -0800 (PST)
Message-Id: <20100301.183955.258219526.davem@davemloft.net>
To: stefanr@s5r6.in-berlin.de
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: sparse checking prevented by "net: fix kmemcheck annotations"
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B8BE8BE.9070505@s5r6.in-berlin.de>
References: <4B8BAE79.9000609@s5r6.in-berlin.de>
	<1267448966.3039.22.camel@edumazet-laptop>
	<4B8BE8BE.9070505@s5r6.in-berlin.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Mon, 01 Mar 2010 17:18:06 +0100

> Eric Dumazet wrote:
>> [PATCH] net: fix protocol sk_buff field
>> 
>> Commit e992cd9b72a18 (kmemcheck: make bitfield annotations truly no-ops
>> when disabled) allows us to revert a workaround we did in the past to
>> not add holes in sk_buff structure.
>> 
>> This patch partially reverts commit 14d18a81b5171
>> (net: fix kmemcheck annotations) so that sparse doesnt complain:
>> 
>> include/linux/skbuff.h:357:41: error: invalid bitfield specifier for
>> type restricted __be16.
> 
> Great, very appreciated.

Applied, thanks everyone.
