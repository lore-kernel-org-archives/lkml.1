Return-Path: <linux-kernel-owner+w=401wt.eu-S934312AbXC2Svx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312AbXC2Svx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 14:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934325AbXC2Svx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 14:51:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55525 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934311AbXC2Svw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 14:51:52 -0400
Message-ID: <460C0AB6.9020709@garzik.org>
Date: Thu, 29 Mar 2007 14:51:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux@horizon.com,
       htejun@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
References: <20070327161616.31448.qmail@science.horizon.com> <Pine.LNX.4.64.0703271224400.5965@p34.internal.lan> <460A7EE7.5070101@cfl.rr.com> <460A8053.3040209@garzik.org> <460BF73C.5070707@cfl.rr.com>
In-Reply-To: <460BF73C.5070707@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Jeff Garzik wrote:
>> NCQ provides for a more asynchronous flow.  It helps greatly with 
>> reads (of which most are, by nature, synchronous at the app level) 
>> from multiple threads or apps.  It helps with writes, even with write 
>> cache on, by allowing multiple commands to be submitted and/or retired 
>> at the same time.
> 
> But when writing, what is the difference between queuing multiple tagged 
> writes, and sending down multiple untagged cached writes that complete 
> immediately and actually hit the disk later?  Either way the host keeps 
> sending writes to the disk until it's buffers are full, and the disk is 
> constantly trying to commit those buffers to the media in the most 
> optimal order.

Less overhead to starting commands, and all the other benefits of making 
operations fully async.

	Jeff



