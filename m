Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZGFTer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZGFTer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZGFTei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:34:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49325
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184AbZGFTeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:34:37 -0400
Date: Mon, 06 Jul 2009 12:34:41 -0700 (PDT)
Message-Id: <20090706.123441.246532764.davem@davemloft.net>
To: chunkeey@web.de
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p54: Fix regression in 2.6.31-rcX since commit a1091aa
 - sleeping function called from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <200907062119.25642.chunkeey@web.de>
References: <4a524b55.wIWqgs5uHs2CpdJy%Larry.Finger@lwfinger.net>
	<20090706.121429.36217952.davem@davemloft.net>
	<200907062119.25642.chunkeey@web.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Lamparter <chunkeey@web.de>
Date: Mon, 6 Jul 2009 21:19:25 +0200

> On Monday 06 July 2009 21:14:29 David Miller wrote:
>> If I can't figure it out quickly I'll just simply revert.
> hmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
> [2.6.31] p54: band-aid to restore driver functionality
> http://patchwork.ozlabs.org/patch/28918/
> 
> in case someone missed it.

It is so much cleaner to not do multiple things in one patch.

It's also better to completely revert the SKB list handling
changes first, then add whatever other fixes you want make
on top.

Partial revert really makes no sense here and is only asking
for even more potential regressions.

So, like I said, I'm reverting this wholesale unless I can figure
out a fix quickly.
