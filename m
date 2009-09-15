Return-Path: <linux-kernel-owner+w=401wt.eu-S1752428AbZIOJj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbZIOJj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZIOJjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:39:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43416
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbZIOJjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:39:22 -0400
Date: Tue, 15 Sep 2009 02:39:39 -0700 (PDT)
Message-Id: <20090915.023939.194852114.davem@davemloft.net>
To: mingo@elte.hu
Cc: eric.dumazet@gmail.com, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
 memory (bf438284)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090915093440.GA7921@elte.hu>
References: <20090915080953.GA24958@elte.hu>
	<4AAF5757.30500@gmail.com>
	<20090915093440.GA7921@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 15 Sep 2009 11:34:40 +0200

> 
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
>> Either we add kmemcheck annotations, or we switch sock->type from short
>> to int to avoid the hole, and possibly to speedup things...
>> 
>> [PATCH] net: kmemcheck annotation in struct socket
>> 
>> struct socket has a 16 bit hole that triggers kmemcheck warnings.
>> 
>> As suggested by Ingo, use kmemcheck annotations
>> 
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> ---
>>  include/linux/net.h |    5 +++++
>>  net/socket.c        |    1 +
>>  2 files changed, 6 insertions(+)
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Applied, thanks everyone.
