Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0CEHUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:20:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52956 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab0CEHUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:20:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: figo zhang <figo1802@gmail.com>
Subject: Re: sched_fair: vruntime and min_vruntime will be overflow?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <c6ed1ac51003042312k103aafddpda82d2d64bd5f73d@mail.gmail.com>
References: <c6ed1ac51003042312k103aafddpda82d2d64bd5f73d@mail.gmail.com>
Message-Id: <20100305161458.3A8D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  5 Mar 2010 16:20:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hi,
> 
> when enqueue or dequeue the task, the se->vruntime and cfs_rq->min_vruntime will
> increased, i want to know it is will be overflow in future time?

Let's quick calculation.

type of vruntime is u64.
 
1 year =   365 x 24 x 60 x 60 x 1000 x 1000 x 1000 nanosec
           ~= 3 x 10^16
           ~= 2^55
2^64 / 2^55 = 2^9 ~= 500 year.

then, 500 years after you can see overflow if you still live. :)



