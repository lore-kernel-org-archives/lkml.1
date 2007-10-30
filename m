Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbXJ3MgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbXJ3MgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 08:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXJ3MgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 08:36:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35379 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbXJ3MgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 08:36:15 -0400
Message-ID: <4727253D.7000206@garzik.org>
Date: Tue, 30 Oct 2007 08:36:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/17] drivers/input/serio/i8042.c: irq handler clean
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org> <20071021075237.EC51B19041D@havoc.gtf.org> <200710211357.16794.dmitry.torokhov@gmail.com>
In-Reply-To: <200710211357.16794.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Hi Jeff,
> 
> On Sunday 21 October 2007, Jeff Garzik wrote:
>> commit bdf311215ef8dbae0254c092deaed1d5928b013e
>> Author: Jeff Garzik <jeff@garzik.org>
>> Date:   Fri Oct 19 19:28:54 2007 -0400
>>
>>     drivers/input/serio/i8042.c: irq handler clean
>>     
>>     * remove unnecessary prototype
>>     
>>     * distinguish between polled and irq-driven event handling
>>     
>>     * don't bother worrying about 'irq' function arg
> 
> I don't like these 2 changes. When I ask for debug data I really
> want to know what interrupt (1 or 12) was raised in response to
> a command. Your changes remove this visibility.

So noted...


>>     * dev_id passed to irq handlers is unused, to change the request_irq()
>>       argument to NULL
>>     
> 
> Does this really matter?

Does it has any effect on the computer?  No.

Does it has any effect on the human reviewer?  IMO yes :)

But it is a trivial matter.

	Jeff



