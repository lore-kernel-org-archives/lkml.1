Return-Path: <linux-kernel-owner+w=401wt.eu-S933589AbZDCXsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbZDCXsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 19:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760253AbZDCXsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 19:48:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55292 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760167AbZDCXsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 19:48:36 -0400
Message-ID: <49D6A04B.2080104@garzik.org>
Date: Fri, 03 Apr 2009 19:48:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <1238758370.32764.5.camel@think.oraclecorp.com> <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain> <49D66C0E.5090301@garzik.org> <alpine.LFD.2.00.0904031309500.4015@localhost.localdomain> <49D68431.30703@garzik.org> <alpine.LFD.2.00.0904031452290.7007@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904031452290.7007@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> "fio" does well:
> 
> 	http://git.kernel.dk/?p=fio.git;a=summary

Neat tool, Jens...


> and I think it comes with a few example files. Here's the random write 
> file that Jens suggested, and that works pretty well..
> 
> It first creates a 2GB file to do the IO on, then does random 4k writes to 
> it with O_DIRECT.
> 
> If your SSD does badly at it, you'll just want to kill it, but it shows 
> you how many MB/s it's doing (or, in the sucky case, how many kB/s).


heh, so far, the SSD is poking along...

Jobs: 1 (f=1): [w] [2.5% done] [     0/   282 kb/s] [eta 02h:24m:59s]


Compared to the same job file, started at the same time, on the Seagate 
500GB SATA:

Jobs: 1 (f=1): [w] [9.9% done] [     0/  1204 kb/s] [eta 26m:28s]

Regards,

	Jeff



