Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbXEIWh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbXEIWh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXEIWhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:37:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49491 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265AbXEIWhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:37:21 -0400
Message-ID: <46424D1E.8000602@garzik.org>
Date: Wed, 09 May 2007 18:37:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, suparna@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: aio is unlikely
References: <200705092101.l49L1CF1023363@hera.kernel.org>	<46424602.3090404@garzik.org> <20070509151831.f5956b66.akpm@linux-foundation.org>
In-Reply-To: <20070509151831.f5956b66.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> a) disagree with the above
> 
> b) if in_aio() ever returns true we do
> 
> 	printk(KERN_ERR "%s(%s:%d) called in async context!\n",
> 		__FUNCTION__, __FILE__, __LINE__);
> 
>    so I sure hope it's unlikely for all workloads.


hrm, indeed.  Ignore me.

	Jeff


