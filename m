Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZKFI6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZKFI6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbZKFI6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:58:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47208
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186AbZKFI6R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:58:17 -0500
Date: Fri, 06 Nov 2009 00:58:42 -0800 (PST)
Message-Id: <20091106.005842.231236256.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: francis.moro@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AF3E2A9.2020601@gmail.com>
References: <4AEB0059.1050400@gmail.com>
	<38b2ab8a0911060045hb6ebab8p43bf8aa838eabfd3@mail.gmail.com>
	<4AF3E2A9.2020601@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 06 Nov 2009 09:47:37 +0100

> Francis Moreau a écrit :
>> On Fri, Oct 30, 2009 at 4:03 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> 
>> [...]
>> 
>>> [PATCH take2] net: fix sk_forward_alloc corruption
>>>
>> 
>> With this patch applied 4 days ago, I haven't got any oops so far.
>
> Thanks a lot for testing and report Francis, I believe David will
> push it for stable (if not already done)

I'm pretty sure it's already in Greg's current batch, but if it
doesn't show up in his next -stable release I'll make sure to
submit it.
