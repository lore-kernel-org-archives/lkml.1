Return-Path: <linux-kernel-owner+w=401wt.eu-S1761053AbZEGSgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761053AbZEGSgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbZEGSgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:36:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44076
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbZEGSgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:36:37 -0400
Date: Thu, 07 May 2009 11:36:32 -0700 (PDT)
Message-Id: <20090507.113632.210373283.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
From: David Miller <davem@davemloft.net>
In-Reply-To: <1241691721.3531.73.camel@macbook.infradead.org>
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
	<20090507100114.GF4059@amd.com>
	<1241691721.3531.73.camel@macbook.infradead.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Thu, 07 May 2009 11:22:01 +0100

> On Thu, 2009-05-07 at 12:01 +0200, Joerg Roedel wrote:
>> > Looks like the DRM code uses the DMA API.
>> 
>> The proprietary drivers make problems so far. For the ATI one I am in
>> contact with the developers to try to fix it. But I can't do anything
>> about the other proprietary driver I am aware of :-(
> 
> I see no harm in "breaking" code which was already broken. If that's the
> only reason we're enabling the graphics workaround, let's turn it off.

Seriously, this is an enormous price to pay just for one bad apple
proprietary driver.

I can't believe the level of concessions some people are suggesting.

Let's not make IOMMU's basically useless by working around one broken
driver.

Proper interfaces for what this driver is trying to do have existed in
the kernel for 10+ years.  There are no excuses, and it's time for
Nvidia to get with the game plan.
