Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbYKNDaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbYKNDaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYKNDaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:30:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:44214 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYKNDaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:30:08 -0500
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, cloos@jhcloos.com, paul@burly.ondioline.org,
       torvalds@linux-foundation.org
In-Reply-To: <20081113.190447.252605555.davem@davemloft.net>
References: <20081113.151116.139760511.davem@davemloft.net>
	 <1226624060.7178.100.camel@pasglop>
	 <20081113.185059.154690040.davem@davemloft.net>
	 <20081113.190447.252605555.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 14:29:11 +1100
Message-Id: <1226633351.7178.107.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It makes a huge difference, with the acceleration patch:
> 
> commit b1ee26bab14886350ba12a5c10cbc0696ac679bf
> Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date:   Wed Oct 15 22:03:46 2008 -0700
> 
>     radeonfb: accelerate imageblit and other improvements
> 
> reverted, the test case takes 25 seconds or more instead of
> the 7 or 8 seconds we're seeing now.

Ok, thanks a lot for those tests !

So I consider the loss of perfs due to the workaround to be minor enough
here. I'll submit the patch for inclusion.

I might look at not doing the clipping in cases things are already
aligned later but I doubt it's going to be worth the pain,

Cheers,
Ben.


