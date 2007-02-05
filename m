Return-Path: <linux-kernel-owner+w=401wt.eu-S1750979AbXBEQhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbXBEQhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbXBEQhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:37:43 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:45785 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbXBEQhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:37:43 -0500
Message-ID: <45C75D2D.9010506@free.fr>
Date: Mon, 05 Feb 2007 17:37:01 +0100
From: John <shill@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tglx@timesys.com, mingo@elte.hu, johnstul@us.ibm.com, akpm@osdl.org,
       shill@free.fr
Subject: Re: One-shot high-resolution POSIX timer periodically late
References: <fa.4zD54Ie6Ozt0P4YqQSicS+XzXGw@ifi.uio.no> <fa.G+/T32f2o1M3+YGLca/O8NaAQyY@ifi.uio.no> <fa.6Ua8xjNfLKQEZZgDsoJgPMyww4g@ifi.uio.no> <fa.yQlV+WU0TgrJTVqjopa01tgCnT0@ifi.uio.no> <fa.ucVrLJ1Lh6FjdBHRglsIUc8/evk@ifi.uio.no> <fa.Id9oufyELrVbe5Wb8SRakwC0V50@ifi.uio.no>
In-Reply-To: <fa.Id9oufyELrVbe5Wb8SRakwC0V50@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> John wrote:
> 
>> John Stultz wrote:
>> 
>>> Also do check the -rt tree as Ingo suggested. I mis-read your earlier
>>> email and thought you were running it.
>> 
>> I've been pulling my hair over a related issue for the past two days.
>> 
>> (I think I may be tickling a -hrt bug...)
>> 
>> I'm working with 2.6.18.6 + patch-2.6.18-rt7
> 
> 2.6.18-rt7 is pretty old, do you see the problem in 2.6.20-rc6-rt5 too?

Ingo, Thomas,

As far as I can tell, the -rt patch set is only updated for the latest 
kernel version available. Is that correct?

http://people.redhat.com/mingo/realtime-preempt/older/?M=D

In other words, once 2.6.20 is released, and work starts on 2.6.21, if a 
bug is discovered in -rt, the fix will not be back-ported to the 
2.6.20.x (and 2.6.19.x, and 2.6.18.x, etc) patch set?

