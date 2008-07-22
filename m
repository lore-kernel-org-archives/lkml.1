Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbYGVRUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbYGVRUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYGVRUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:20:07 -0400
Received: from stinky.trash.net ([213.144.137.162]:37478 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYGVRUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:20:06 -0400
Message-ID: <488616C0.8070505@trash.net>
Date: Tue, 22 Jul 2008 19:20:00 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Kernel WARNING: at net/core/dev.c:1330 __netif_schedule+0x2c/0x98()
References: <4885104A.2070201@lwfinger.net>	<20080721.161517.27161039.davem@davemloft.net>	<48857F74.2040406@lwfinger.net> <20080722.043220.247312412.davem@davemloft.net> <4885DA49.50703@lwfinger.net> <48860D4B.8070003@lwfinger.net>
In-Reply-To: <48860D4B.8070003@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> I pulled from Linus's tree this morning and now have git-05752-g93ded9b. 
> The kernel WARNING from __netif_schedule and the lockdep warning are 
> present with or without the patches from yesterday.
> 
> As I stated earlier, the kernel WARNING (it was a BUG then) was 
> introduced in commit 37437bb2 when the BUG statement was entered.
> 
> The lockdep warning started with the next commit (16361127).
> 
> The lockdep warning is:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.26-Linus-git-05752-g93ded9b #49

                    ^^^^^^^^^^^^^^ dirty?

This kernel is not using the patches we sent.
