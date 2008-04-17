Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYDQGOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYDQGOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 02:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYDQGOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 02:14:44 -0400
Received: from webmail1.posta.tim.it ([213.230.128.226]:14605 "EHLO
	fep05-svc.tim.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751619AbYDQGOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 02:14:43 -0400
Message-ID: <4806EACB.7040408@unimore.it>
Date: Thu, 17 Apr 2008 08:14:35 +0200
From: Paolo Valente <paolo.valente@unimore.it>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz>
In-Reply-To: <20080416184441.GA3923@ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek ha scritto:
>
>> In the first type of tests, to achieve a higher throughput than CFQ
>> (with the default 100 ms time slice), the maximum budget for BFQ
>> had to be set to at least 4k sectors.  Using the same value for the
>>     
>
> Hmm, 4k sectors is ~40 seconds worst case, no? That's quite long...
>   
Actually, in the worst case among our tests, the aggregate throughput 
with 4k sectors was ~ 20 MB/s, hence the time for 4k sectors ~ 4k * 512 
/ 20M = 100 ms.
About these test cases we repeated several measures of the aggregate 
throughput with simultaneous file reads from 2 to 5 (and other varying 
parameters). The lowest aggregate throughput for 4k sectors (~ 20 MB/s) 
was achieved in case of 2, 128 MB long, files, lying on two slices at 
the maximum distance from each other (more details on the experiments, 
testbed and so on at http://algo.ing.unimo.it/people/paolo/disk_sched/).
I hope I didn't misunderstand your point.

