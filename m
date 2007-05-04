Return-Path: <linux-kernel-owner+w=401wt.eu-S1767730AbXEDIQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767730AbXEDIQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767715AbXEDIQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:16:48 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:22772 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965744AbXEDIQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Vm7i6cd7MCG6lwciq2wlFwoUseP4w69/BqE5segeS9PeQFDrnc8pJx46ZEQOtyrB4b7DLlTuFB7nIiqI+aR7kVmiQv6O1JXA5s971iasIytd0RAezi5EpZVK6AfAuJ8NiW7eFkIS7rrmJSgrWWL7w556OMXPxXgEN/0+QsnJfP0=
Message-ID: <463AEBE0.7010506@gmail.com>
Date: Fri, 04 May 2007 10:16:32 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Mark Lord <lkml@rtr.ca>, Frank van Maarseveen <frankvm@frankvm.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: libata /dev/scd0 problem: mount after burn fails without eject
References: <20070501135951.GA17072@janus> <46374C11.1010702@rtr.ca> <6bffcb0e0705010731v44cfad1awf4342121245f7ab3@mail.gmail.com>
In-Reply-To: <6bffcb0e0705010731v44cfad1awf4342121245f7ab3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> On 01/05/07, Mark Lord <lkml@rtr.ca> wrote:
>> Forwarding to linux-scsi and linux-ide mailing lists.
>>
>> Frank van Maarseveen wrote:
>> > Tested on 2.6.20.6 and 2.6.21.1
>> >
>> > I decided to swich from the old IDE drivers to libata and now there
>> > seems to be a little but annoying problem: cannot mount an ISO image
>> > after burning it.
>> >
>> > May  1 14:32:55 kernel: attempt to access beyond end of device
>> > May  1 14:32:55 kernel: sr0: rw=0, want=68, limit=4
>> > May  1 14:32:55 kernel: isofs_fill_super: bread failed, dev=sr0,
>> iso_blknum=16, block=16
>> >
>> > an "eject" command seems to fix the state of the PATA DVD writer
>> > or driver. The problem occurs for burning a CD and for DVD too with
>> > identical error messages.

Right after burning, if you run 'fuser -v /dev/sr0', what does it say?

-- 
tejun
