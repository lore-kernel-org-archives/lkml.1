Return-Path: <linux-kernel-owner+w=401wt.eu-S933189AbYDQPSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbYDQPSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759859AbYDQPSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:18:35 -0400
Received: from webmail1.posta.tim.it ([213.230.128.226]:56797 "EHLO
	fep07-svc.tim.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759776AbYDQPSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:18:34 -0400
Message-ID: <48076A41.5040806@unimore.it>
Date: Thu, 17 Apr 2008 17:18:25 +0200
From: Paolo Valente <paolo.valente@unimore.it>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
CC: Fabio Checconi <fchecconi@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <48072549.7040104@cse.unsw.edu.au> <20080417111407.GS62286@gandalf.sssup.it> <48073F15.7070502@cse.unsw.edu.au>
In-Reply-To: <48073F15.7070502@cse.unsw.edu.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron Carroll ha scritto:
> You still end up with reduced global throughput as
> you've shown in the ``Short-term time guarantees'' table.  It is an
> interesting case though... since the lower performance is not though 
> fault
> of the process it doesn't seem fair to ``punish'' it.
Just a note about that table. The lower aggregate throughput of bfq is 
due to the fact that, because of the higher number of movies being read, 
a higher percentage of not-that-profitable accesses is being performed 
under bfq wrt to cfq. As shown in the complete logs of the aggregate 
throughput in the raw results, the aggregate throughput with bfq and cfq 
is practically the same when the number of movies is the same.
The figure in the "Aggregate throughput" subsection is probably best 
suited for a comparison of the performance of the two schedulers with 
sequential accesses under the same conditions (the figure refers to the 
2, 128 MB long, files, but we got virtually the same results in all the 
other tests).
I do agree on that these experiments should be repeated with different 
(faster) devices.

Paolo
>
> -- Aaron
>
>


