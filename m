Return-Path: <linux-kernel-owner+w=401wt.eu-S1761815AbYDQPUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815AbYDQPUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYDQPTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:19:54 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:35029
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbYDQPTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:19:53 -0400
Message-ID: <48076A97.9060003@qumranet.com>
Date: Thu, 17 Apr 2008 18:19:51 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Paolo Valente <paolo.valente@unimore.it>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <20080417083047.GV12774@kernel.dk>
In-Reply-To: <20080417083047.GV12774@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> I was thinking about that too. Generally I've been opposed to doing
> scheduling decisions on anything but time, since that is always
> relevant. When to hand out slices and to what process, that algorithm is
> really basic in CFQ and could do with an improvement.
>   

Jumping in at random, does "process" here mean task or mms_struct?  If 
the former, doesn't that mean that a 100-thread process can starve out a 
single-threaded process?

Perhaps we need hierarchical io scheduling, like cfs has for the cpu.

-- 
error compiling committee.c: too many arguments to function

