Return-Path: <linux-kernel-owner+w=401wt.eu-S934126AbYDQPr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126AbYDQPr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762471AbYDQPru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:47:50 -0400
Received: from webmail1.posta.tim.it ([213.230.128.226]:43541 "EHLO
	fep08-svc.tim.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761258AbYDQPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:47:50 -0400
Message-ID: <48077120.8030007@unimore.it>
Date: Thu, 17 Apr 2008 17:47:44 +0200
From: Paolo Valente <paolo.valente@unimore.it>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <20080417083047.GV12774@kernel.dk> <48076A97.9060003@qumranet.com>
In-Reply-To: <48076A97.9060003@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity ha scritto:
> Jumping in at random, does "process" here mean task or mms_struct?  If 
> the former, doesn't that mean that a 100-thread process can starve out 
> a single-threaded process?
>
> Perhaps we need hierarchical io scheduling, like cfs has for the cpu.
>
Hierarchical would simplify isolating groups of threads or processes.
However, some simple solution is already available with bfq. For 
example, if you have to fairly share the disk bandwidth between the 
above 100 threads and another important thread, you get it by just 
assigning weight 1 to each of these 100 threads, and weight 100 to the 
important one.

Paolo

-- 
-----------------------------------------------------------
| Paolo Valente              |                            |
| Algogroup                  |                            |
| Dip. Ing. Informazione     | tel:   +39 059 2056318     |
| Via Vignolese 905/b	     | fax:   +39 059 2056199     |
| 41100 Modena               | 				  |
|     home:  http://algo.ing.unimo.it/people/paolo/       |
-----------------------------------------------------------

