Return-Path: <linux-kernel-owner+w=401wt.eu-S937799AbXGTWjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937799AbXGTWjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbXGTWjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:39:32 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:56335 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbXGTWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:39:31 -0400
Message-ID: <46A1399C.8010405@nortel.com>
Date: Fri, 20 Jul 2007 16:39:24 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Lee Revell <rlrevell@joe-job.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: posible latency issues in seq_read
References: <46A125F4.3030504@nortel.com> <75b66ecd0707201518j45ef8bb7q7e48462ffbbc9c58@mail.gmail.com>
In-Reply-To: <75b66ecd0707201518j45ef8bb7q7e48462ffbbc9c58@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jul 2007 22:39:27.0614 (UTC) FILETIME=[D46429E0:01C7CB1E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Revell wrote:
> On 7/20/07, Chris Friesen <cfriesen@nortel.com> wrote:

>> We've run into an issue (on 2.6.10) where calling "lsof" triggers lost
>> packets on our server.  Preempt is disabled, and NAPI is enabled.

> Can you reproduce with a recent kernel?  Lots of latency issues have
> been fixed since then.

Unfortunately I have to fix it on this version (the bug was found on 
shipped product), so if there was a difference I'd have to isolate the 
changes and backport them.  Also, I can't run the software that triggers 
the problem on a newer kernel as it has dependencies on various patches 
that are not in mainline.

Basically what I'd like to know is whether calling schedule() in 
seq_read() is safe or whether it would break assumptions made by 
seq_file users.

Chris
