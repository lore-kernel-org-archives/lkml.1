Return-Path: <linux-kernel-owner+w=401wt.eu-S935687AbXHJLhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935687AbXHJLhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 07:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762832AbXHJLhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 07:37:40 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:35330 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935294AbXHJLhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 07:37:39 -0400
Message-ID: <46BC4CE0.4030908@linux.vnet.ibm.com>
Date: Fri, 10 Aug 2007 17:02:48 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Softlockup detected with 2.6.23-rc2-mm1
References: <46BC02B9.1000307@linux.vnet.ibm.com> <20070809232504.c28a3c93.akpm@linux-foundation.org>
In-Reply-To: <20070809232504.c28a3c93.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 10 Aug 2007 11:46:25 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>
>   
>> I get call trace, when the file system stress is run on the
>> 2.6.23-rc2-mm1 kernel on a Dual Core AMD Opteron
>> (processor 270)
>>
>> ============================================\BUG: spinlock bad magic on 
>> CPU#1, fsx-linux/19721
>>     
>
> Yes, sorry, mm-dirty-balancing-for-tasks.patch had a bug.  Those patches were
> removed from 2.6.23-rc2-mm2 - please test that instead.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
The Call trace is not reproducible in the 2.6.23-rc2-mm2.

