Return-Path: <linux-kernel-owner+w=401wt.eu-S1763750AbXGWRqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763750AbXGWRqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbXGWRq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:46:27 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:52569 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864AbXGWRq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:46:26 -0400
Message-ID: <46A4E94A.3030301@nortel.com>
Date: Mon, 23 Jul 2007 11:45:46 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org
Subject: Re: posible latency issues in seq_read
References: <46A125F4.3030504@nortel.com> <75b66ecd0707201518j45ef8bb7q7e48462ffbbc9c58@mail.gmail.com> <46A1399C.8010405@nortel.com> <46A181A5.5010203@cosmosbay.com>
In-Reply-To: <46A181A5.5010203@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2007 17:45:55.0729 (UTC) FILETIME=[52210810:01C7CD51]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

> The problem is in established_get_next() and established_get_first() not 
> allowing softirq processing, while scanning a possibly huge hash table, 
> even if few sockets are hashed in.
> 
> As cond_resched_softirq() was added in linux-2.6.11, you probably *need* 
> to check the diffs between linux-2.6.10 & linux-2.6.11

Thanks for the pointers to the likely culprits.

Chris
