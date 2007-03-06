Return-Path: <linux-kernel-owner+w=401wt.eu-S1751245AbXCFUGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbXCFUGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXCFUGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:06:54 -0500
Received: from mail21.syd.optusnet.com.au ([211.29.133.158]:35536 "EHLO
	mail21.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbXCFUGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:06:53 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu   scheduler
Date: Wed, 7 Mar 2007 07:06:41 +1100
User-Agent: KMail/1.9.5
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org> <200703050453.08154.gene.heskett@gmail.com> <45EDA9DF.6030305@tmr.com>
In-Reply-To: <45EDA9DF.6030305@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703070706.41676.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2007 04:50, Bill Davidsen wrote:
> Gene Heskett wrote:
> > On Monday 05 March 2007, Nicolas Mailhot wrote:
> >> This looks like -mm stuff if you want it in 2.6.22
> >
> > This needs to get to 2.6.21, it really is that big an improvement.
>
> As Con pointed out, for some workloads and desired behavour this is not
> as good as the existing scheduler. Therefore it should go in -mm and
> hopefully give the user an option to select which is appropriate.

Actually I wasn't saying that for some workloads mainline will be better. What 
I was saying was there will be some bizarre scenarios where the intrinsic 
unfairness in mainline towards certain interactive tasks will make them 
appear to run better. After fiddling with scheduler code for the last few 
years I've come to believe that that may _appear to look better_, but is 
worse since that behaviour can be exploited and leads to scheduling delays 
elsewhere.

> With luck I'll get to shake out that patch in combination with kvm later
> today.

Great thanks!. I've appreciated all the feedback so far.

-- 
-ck
