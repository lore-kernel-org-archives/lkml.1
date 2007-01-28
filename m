Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbXA1Vlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbXA1Vlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932914AbXA1Vlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:41:47 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:40767 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932911AbXA1Vlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:41:47 -0500
Date: Sun, 28 Jan 2007 22:40:07 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Bill Davidsen <davidsen@tmr.com>, Marc Perkel <mperkel@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Raid 10 question/problem [ot]
In-Reply-To: <45BCFE33.3000600@tls.msk.ru>
Message-ID: <Pine.LNX.4.61.0701282238570.22295@yvahk01.tjqt.qr>
References: <478459.76045.qm@web52503.mail.yahoo.com> <45BCDFAE.5090602@tmr.com>
 <45BCFE33.3000600@tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 28 2007 22:49, Michael Tokarev wrote:
>Bill Davidsen wrote:
>[]
>> RAID-10 is not the same as RAID 0+1.
>
>It is.  Yes, there's separate module for raid10, but what it - basically -
>does is the same as raid0 module over two raid1 modules will do.  It's
>just a bit more efficient (less levels, more room for optimisations),
>easy to use (you'll have single array instead of at least 3), and a bit
>more flexible;  at the same way it's less widely tested...

And most importantly, raid10 allows you to spread the array data over an odd
number of devices while still having [at least] 2 copies of each block.

Hm, I really wished resizing was implemented for raid0 and raid10 too... ;)


	-`J'
-- 
