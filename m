Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab0CDIkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:40:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36170
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417Ab0CDIkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:40:45 -0500
Date: Thu, 04 Mar 2010 00:41:04 -0800 (PST)
Message-Id: <20100304.004104.24320938.davem@davemloft.net>
To: efault@gmx.de
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [rfc/rft][patch] should use scheduler sync hint in
 tcp_prequeue()?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267627610.6264.21.camel@marge.simson.net>
References: <1267529273.2964.111.camel@edumazet-laptop>
	<20100303.060529.195713861.davem@davemloft.net>
	<1267627610.6264.21.camel@marge.simson.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>
Date: Wed, 03 Mar 2010 15:46:50 +0100

> On Wed, 2010-03-03 at 06:05 -0800, David Miller wrote:
> 
>> It definitely looks like an oversight to me and we should add
>> be using wake_up_interruptible_sync_poll() in tcp_prequeue()
>> as above.
>> 
>> Ingo?
> 
> Implied ack from network maintainer implies ship it to me.
> 
> net: add scheduler sync hint to tcp_prequeue().
> 
> Decreases the odds wakee will suffer from frequent cache misses.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>

Applied.
