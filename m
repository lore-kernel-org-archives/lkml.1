Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYDQXqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYDQXqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 19:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYDQXqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 19:46:11 -0400
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:53762 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbYDQXqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 19:46:10 -0400
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
To: Avi Kivity <avi@qumranet.com>
Date: Fri, 18 Apr 2008 09:44:21 +1000
Message-ID: <4807E0D5.2060600@cse.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080316)
MIME-Version: 1.0
CC: Jens Axboe <jens.axboe@oracle.com>,
       Paolo Valente <paolo.valente@unimore.it>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <20080417083047.GV12774@kernel.dk> <48076A97.9060003@qumranet.com>
In-Reply-To: <48076A97.9060003@qumranet.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Jens Axboe wrote:
>> I was thinking about that too. Generally I've been opposed to doing
>> scheduling decisions on anything but time, since that is always
>> relevant. When to hand out slices and to what process, that algorithm is
>> really basic in CFQ and could do with an improvement.
>>   
> 
> Jumping in at random, does "process" here mean task or mms_struct?  If 
> the former, doesn't that mean that a 100-thread process can starve out a 
> single-threaded process?

task_struct.  It would also be nice to do per-user I/O scheduling..

 -- Aaron
