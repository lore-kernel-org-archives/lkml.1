Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbZDDMqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbZDDMqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 08:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZDDMqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 08:46:43 -0400
Received: from rtr.ca ([76.10.145.34]:33767 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbZDDMqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 08:46:43 -0400
Message-ID: <49D756B0.6030609@rtr.ca>
Date: Sat, 04 Apr 2009 08:46:40 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <1238758370.32764.5.camel@think.oraclecorp.com> <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain> <49D66C0E.5090301@garzik.org> <alpine.LFD.2.00.0904031309500.4015@localhost.localdomain> <49D68431.30703@garzik.org> <alpine.LFD.2.00.0904031452290.7007@localhost.localdomain> <49D6A04B.2080104@garzik.org>
In-Reply-To: <49D6A04B.2080104@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Linus Torvalds wrote:
>> "fio" does well:
>>
>>     http://git.kernel.dk/?p=fio.git;a=summary
> 
> Neat tool, Jens...
> 
> 
>> and I think it comes with a few example files. Here's the random write 
>> file that Jens suggested, and that works pretty well..
>>
>> It first creates a 2GB file to do the IO on, then does random 4k 
>> writes to it with O_DIRECT.
>>
>> If your SSD does badly at it, you'll just want to kill it, but it 
>> shows you how many MB/s it's doing (or, in the sucky case, how many 
>> kB/s).
> 
> 
> heh, so far, the SSD is poking along...
> 
> Jobs: 1 (f=1): [w] [2.5% done] [     0/   282 kb/s] [eta 02h:24m:59s]
..

Try turning on the drive write cache?   hdparm -W1

