Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbZFAREj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbZFAREj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZFAREb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:04:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40239 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbZFAREa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:04:30 -0400
Message-ID: <4A240A1D.8020906@redhat.com>
Date: Mon, 01 Jun 2009 20:04:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: J Louis <handstogether8@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux scheduler capabilities for batch jobs.
References: <6f41bd4b0906010641n1b360dffs6eaed72eb24f60f5@mail.gmail.com> <4A240479.9040907@redhat.com>
In-Reply-To: <4A240479.9040907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> J Louis wrote:
>
>> If it was possible to tell
>> the scheduler that it was OK not to be fair when scheduling these
>> processes, I think the total runtime could be reduced if it put some
>> of the processes to sleep while others completed.  Is there a way to
>> tell the scheduler it is allowed to do this?  Should there be?
>
> There is no way to do this currently, but I suspect that it
> would not be too difficult to add.
>
> Of course, if you have two tasks that are each a little larger
> than memory, your idea could lead to one of the processes being
> starved forever.  This is probably not acceptable :)
>
> In fact, one single batch process that is swapping could trigger
> the algorithm you described, halting itself.  Your idea would
> need very carefuly implementation to avoid these kinds of issues,
> but I believe it could definately be done.

Some king of interaction between the swap token and the scheduler, 
perhaps, for SCHED_BATCH processes.


-- 
error compiling committee.c: too many arguments to function

