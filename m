Return-Path: <linux-kernel-owner+w=401wt.eu-S1764867AbYDQMPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764867AbYDQMPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 08:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYDQMPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 08:15:40 -0400
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:58016 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbYDQMPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 08:15:40 -0400
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
To: Fabio Checconi <fchecconi@gmail.com>
Date: Thu, 17 Apr 2008 22:14:13 +1000
Message-ID: <48073F15.7070502@cse.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080316)
MIME-Version: 1.0
CC: Paolo Valente <paolo.valente@unimore.it>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <48072549.7040104@cse.unsw.edu.au> <20080417111407.GS62286@gandalf.sssup.it>
In-Reply-To: <20080417111407.GS62286@gandalf.sssup.it>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Checconi wrote:
>> From: Aaron Carroll <aaronc@cse.unsw.edu.au>
>> How do you figure that?  This is a situation where time-slices work nicely,
>> because they implicitly account for the performance penalty of poor access
>> patterns.  The sequential-accessing processes (and the system overall) ends
>> up with higher throughput.
>>
> 
> The unfairness is not WRT tasks generating poor access patterns.
> If you have two tasks doing sequential accesses on two different
> regions of the disk the exact amount of service they receive in the
> same amount of time depends on the transfer rate of the disk on
> that regions, and, depending on the media, it is not always the same.

Ok... you're talking about ZBR.

I'm not convinced this should be treated differently to, say, random vs.
sequential workloads.  You still end up with reduced global throughput as
you've shown in the ``Short-term time guarantees'' table.  It is an
interesting case though... since the lower performance is not though fault
of the process it doesn't seem fair to ``punish'' it.

 -- Aaron

