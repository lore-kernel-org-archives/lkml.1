Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbXJXOa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbXJXOa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbXJXOat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:30:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59078 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbXJXOas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:30:48 -0400
Message-ID: <471F5712.9090909@garzik.org>
Date: Wed, 24 Oct 2007 10:30:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] final SCSI pieces for the merge window
References: <1193173128.3434.1.camel@localhost.localdomain>	 <471E6313.1040704@garzik.org>	 <1193174424.3434.3.camel@localhost.localdomain>	 <471E707B.1020505@garzik.org> <1193232259.3396.6.camel@localhost.localdomain>
In-Reply-To: <1193232259.3396.6.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-10-23 at 18:06 -0400, Jeff Garzik wrote:
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
> 
> The patch in question is an interface to user space.  The problem with
> those is that you can't put them in and refine them because the user
> visible interface changes when you do that.

Post August, this user space interface patch has received (a) silence or 
(b) this vague general worry about changing user space interfaces.  All 
the while it is working and was revised according to comment at the time.

At some point you gotta stop waiting for perfection or that mythical 
"when I get a round tuit" and actually DO something.

When I see the new patch to end CD-ROM polling grow moldy for two months 
while rewrites to ancient SCSI drivers go in, I throw up my hands in 
wonderment.  Poor Andrew is constantly resending -mm patches to you -- 
some stick, some vanish into the ether without comment.  For months.


>> I really think you have the knowledge to be SCSI maintainer, but not the 
>> time.
> 
> The pot is calling the kettle black here, since libata was supposed to
> have moved out of SCSI about three years ago by helping us move the
> shared elements up to block.  As far as I can tell, the only progress
> we've made in this area is me adding the odd API shift.

You're talking about long term directions, I'm talking about actually 
getting day-to-day work accomplished.

	Jeff


