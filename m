Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbXJXOdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbXJXOdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbXJXOc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:32:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59103 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804AbXJXOcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:32:53 -0400
Message-ID: <471F5792.1030000@garzik.org>
Date: Wed, 24 Oct 2007 10:32:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: dougg@torque.net
CC: James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] final SCSI pieces for the merge window
References: <1193173128.3434.1.camel@localhost.localdomain>	 <471E6313.1040704@garzik.org> <1193174424.3434.3.camel@localhost.localdomain> <471E707B.1020505@garzik.org> <471F104C.5040005@torque.net>
In-Reply-To: <471F104C.5040005@torque.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Douglas Gilbert wrote:
> Jeff Garzik wrote:
>> James Bottomley wrote:
>>> On Tue, 2007-10-23 at 17:09 -0400, Jeff Garzik wrote:
>>>> James Bottomley wrote:
>>>>> This should be the final SCSI updates; it's mainly just a few accessor
>>>>> completion updates and two driver merges (sym2 and qla2xxx) we also
>>>>> secured DaveM's agreement to remove fcal/fc4, which explains the high
>>>>> removal line count.
>>>>>
>>>>> The patch is available here:
>>>>>
>>>>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
>>>> I guess I have the go-ahead to merge the end-CDROM-polling async
>>>> notification work you've been repeatedly ignoring?
>>> I haven't been ignoring it ... it just needs quite a bit of work; the
>>> best way to accelerate it seems to be simply to do it (add the
>>> supported/trigger event bitmasks and expand the infrastructure).  I just
>>> haven't had the time within the merge window.
>> James, things cannot get bottlenecked like this.  You have had MONTHS to
>> say something like this.  The code was ready BEFORE the merge window.
>>
>> I really think you have the knowledge to be SCSI maintainer, but not the
>> time.
> 
> Jeff,
> If only I had a dollar (Canadian unit please) for
> each day some of my libata patches were queued
> up to you before you accepted them.
> 
> Remember MODE SELECT ...

You're darned right, I've screwed up in the past.  Sat on stuff "until I 
get time to rewrite it" and that sort of thing.  My colleagues give me 
lumps for it too :)

We talked about this issue at the Kernel Summit -- collectively we need 
to stop holding on to useful, working stuff for months on end.  It 
serves nobody.

We have to rediscover our roots:  "release early, release often"

	Jeff



