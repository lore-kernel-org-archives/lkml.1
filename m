Return-Path: <linux-kernel-owner+w=401wt.eu-S1946805AbXBJAZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946805AbXBJAZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946809AbXBJAZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:25:45 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33578 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946806AbXBJAZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:25:44 -0500
Message-ID: <45CD10FE.3050506@garzik.org>
Date: Fri, 09 Feb 2007 19:25:34 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
CC: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
References: <1171058269.1484.64.camel@nigel.suspend2.net>	 <1171059433.8675.195.camel@laptopd505.fenrus.org> <1171059968.1484.90.camel@nigel.suspend2.net>
In-Reply-To: <1171059968.1484.90.camel@nigel.suspend2.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
> Hi.
> 
> On Fri, 2007-02-09 at 23:17 +0100, Arjan van de Ven wrote:
>> On Sat, 2007-02-10 at 08:57 +1100, Nigel Cunningham wrote:
>>> Hi.
>>>
>>> I don't think this is already done (feel free to correct me if I'm
>>> wrong)..
>>>
>>> Can we start to NAK new drivers that don't have proper power management
>>> implemented? There really is no excuse for writing a new driver and not
>>> putting .suspend and .resume methods in anymore, is there?
>>
>> to a large degree, a device driver that doesn't suspend is better than
>> no device driver at all, right?
> 
> I'm not sure it is. It only makes more work for everyone else: We have
> to help people figure out what causes their computer to fail to resume
> (which can take quite a while), then get them them complain to driver
> author, and the driver author has to submit patches to fix it.
> 
> All of this is avoided if they'll just do it right in the first place.

A lot of a lot of things could have been avoided, if they just did it 
right the first time.

I think it's more valuable to users to get a basic network driver that 
pings or a basic ATA driver that reads/writes, than peripheral issues 
like suspend/resume.

Certainly we should ask for it, but it shouldn't be a merge-stopper.

	Jeff



