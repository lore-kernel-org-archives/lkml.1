Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbXCEVGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbXCEVGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbXCEVGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:06:00 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:56085 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbXCEVF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:05:59 -0500
Date: Mon, 05 Mar 2007 16:05:48 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] [RSDL 5/6] sched: implement rsdl cpu scheduler
In-reply-to: <20070305203857.GQ16722@waste.org>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>
Message-id: <200703051605.49298.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703041806.22965.kernel@kolivas.org>
 <20070305203857.GQ16722@waste.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007, Matt Mackall wrote:
>On Sun, Mar 04, 2007 at 06:06:22PM +1100, Con Kolivas wrote:
>> + * This is the time all tasks within the same priority round robin.
>> + * Set to a minimum of 6ms.
>>   */
>> +#define RR_INTERVAL		((6 * HZ / 1001) + 1)
>
>What happens with small HZ? Like 100? I suppose 10ms is a reasonable
>number here. But in general, how well does this scheduler do without a
>time source other than jiffies?

I don't personally know, but another poster I recall did say he was using 
a slow clock and it worked great so you might backtrack in this thread.  
I'm using the 1k clock here.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
