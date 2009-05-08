Return-Path: <linux-kernel-owner+w=401wt.eu-S1762879AbZEHXqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762879AbZEHXqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZEHXqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:46:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:57497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbZEHXqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:46:37 -0400
Message-ID: <4A04C3B9.6090801@kernel.org>
Date: Sat, 09 May 2009 08:43:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, sfr@canb.auug.org.au, bzolnier@gmail.com,
       petkovbb@googlemail.com, sshtylyov@ru.mvista.com, oakad@yahoo.com,
       drzeus@drzeus.cx, dwmw2@infradead.org, Markus.Lidel@shadowconnect.com,
       wein@de.ibm.com, schwidefsky@de.ibm.com, zaitcev@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
Subject: Re: [PATCH 16/18] gdrom: dequeue in-flight request
References: <1241751256-17435-1-git-send-email-tj@kernel.org>	 <1241751256-17435-17-git-send-email-tj@kernel.org> <1241812425.18200.0.camel@localhost.localdomain>
In-Reply-To: <1241812425.18200.0.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 23:44:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian McMenamin wrote:
> On Fri, 2009-05-08 at 11:54 +0900, Tejun Heo wrote:
>> gdrom already dequeues and fully completes requests on normal path and
>> the error paths can be easily converted to do so too.  Clean it up and
>> dequeue requests on error paths too.
>>
>> While at it remove superflous blk_fs_request() && !blk_rq_sectors()
>> condition check.
>>
>> [ Impact: dequeue in-flight request, cleanup ]
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
>> ---
> 
> Tested-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

Thanks.

-- 
tejun
