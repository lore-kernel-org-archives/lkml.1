Return-Path: <linux-kernel-owner+w=401wt.eu-S1423482AbXEANlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423482AbXEANlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423500AbXEANlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:41:50 -0400
Received: from rtr.ca ([64.26.128.89]:4399 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423449AbXEANlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:41:49 -0400
Message-ID: <46374399.8030602@rtr.ca>
Date: Tue, 01 May 2007 09:41:45 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, William Thompson <wt@electro-mechanical.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: 2.6.20 libata cdrom
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com> <4636C2C7.8090206@gmail.com> <46373873.6060704@rtr.ca> <463738BD.2090308@rtr.ca> <46374161.3020801@gmail.com>
In-Reply-To: <46374161.3020801@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Mark Lord wrote:
>> And this is the second one today where it would be very useful
>> to see a tf dump.  It's time to add one to that code patch, methinks.
> 
> Yeah, we have all these fancy ata_msg_() thingies which can be used to
> provide a lot of debugging info without affecting hot path.  We're just
> too lazy to actually use it. :-( Putting it on my ever growing to-do list.

The thing about failures is, we're lucky enough to ever see even a single
end-user error log.  So when we do get the *one* error log from grandma,
it had better contain sufficient info for us to at least guess at the
solution, because grandma has gone back to OS/X in the meanwhile.  ;)

It's a good thing that failure paths are not normally "hot".
We can load those up with a little extra info, so long as they
cannot normally be trigged from userspace to generate a Denial-Of-Service
style of attack.

I think libata drive probing is a pretty safe area to show lots
of information (by default) when something goes wrong.

Cheers!
