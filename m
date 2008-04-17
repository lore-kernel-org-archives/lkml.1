Return-Path: <linux-kernel-owner+w=401wt.eu-S1765559AbYDQK3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765559AbYDQK3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbYDQK33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:29:29 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:32969 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbYDQK32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:29:28 -0400
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
To: Paolo Valente <paolo.valente@unimore.it>
Date: Thu, 17 Apr 2008 20:24:09 +1000
Message-ID: <48072549.7040104@cse.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080316)
MIME-Version: 1.0
CC: Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it>
In-Reply-To: <480709A2.7040606@unimore.it>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Valente wrote:
> In my opinion, the time-slice approach of cfq is definitely better 
> suited than the (sector) budget approach for this type of workloads. On 
> the opposite end, the price of time-slices is unfairness towards, e.g., 
> threads doing sequential accesses. In bfq we were mainly thinking about 

How do you figure that?  This is a situation where time-slices work nicely,
because they implicitly account for the performance penalty of poor access
patterns.  The sequential-accessing processes (and the system overall) ends
up with higher throughput.
 
 -- Aaron

