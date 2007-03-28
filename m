Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbXC1Ot2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbXC1Ot2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbXC1Ot2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:49:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45301 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbXC1Ot1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:49:27 -0400
Message-ID: <460A8053.3040209@garzik.org>
Date: Wed, 28 Mar 2007 10:48:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux@horizon.com,
       htejun@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
References: <20070327161616.31448.qmail@science.horizon.com> <Pine.LNX.4.64.0703271224400.5965@p34.internal.lan> <460A7EE7.5070101@cfl.rr.com>
In-Reply-To: <460A7EE7.5070101@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Justin Piszcz wrote:
>> I would try with write-caching enabled.
>> Also, the RAID5/RAID10 you mention seems like each volume is on part of
>> the platter, a strange setup you got there :)
> 
> Shouldn't NCQ only help write performance if write caching is 
> _disabled_?  Since write cache essentially is just non tagged command 
> queuing?

NCQ provides for a more asynchronous flow.  It helps greatly with reads 
(of which most are, by nature, synchronous at the app level) from 
multiple threads or apps.  It helps with writes, even with write cache 
on, by allowing multiple commands to be submitted and/or retired at the 
same time.

	Jeff



