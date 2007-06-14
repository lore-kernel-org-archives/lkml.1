Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbXFNS5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbXFNS5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXFNS5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:57:30 -0400
Received: from comtv.ru ([217.10.32.17]:37634 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbXFNS53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:57:29 -0400
X-Greylist: delayed 3596 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 14:57:29 EDT
X-UCL: actv
Date: Thu, 14 Jun 2007 21:56:51 +0400 (MSD)
From: Vassili Karpov <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: accurate user accounting
In-Reply-To: <20070328113743.GA5615@elte.hu>
Message-ID: <Pine.LNX.4.64.0706142149020.2991@linmac.oyster.ru>
References: <200703251159.03616.kernel@kolivas.org>
 <Pine.LNX.4.64.0703252107590.31900@linmac.oyster.ru> <200703260901.54943.kernel@kolivas.org>
 <200703260957.34798.kernel@kolivas.org> <Pine.LNX.4.64.0703261439270.2621@linmac.oyster.ru>
 <20070328113743.GA5615@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo and others,

After reading http://lwn.net/Articles/236485/ and noticing few refernces
to accounting i decided to give CFS a try. With sched-cfs-v2.6.21.4-16
i get pretty weird results, it seems like scheduler is dead set on trying
to move the processes to different CPUs/cores all the time. And with hog
(manually tweaking the amount iterations) i get fairly strange resuls,
first of all the process is split between two cores, secondly while
integral load provided by the kernel looks correct, it's off by good
20 percent on each idividial core.

(http://www.boblycat.org/~malc/apc/hog-cfs-v16.png)

Thought this information might be of some interest.

P.S. How come the /proc/stat information is much closer to reality now?
      Something like what Con Kolivas suggested was added to sched.c?

-- 
vale
