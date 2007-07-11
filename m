Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbXGKBcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbXGKBcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 21:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbXGKBbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 21:31:52 -0400
Received: from trinity.phys.uwm.edu ([129.89.57.159]:42441 "EHLO
	trinity.phys.uwm.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbXGKBbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 21:31:51 -0400
Date: Tue, 10 Jul 2007 20:31:11 -0500 (CDT)
From: Bruce Allen <ballen@gravity.phys.uwm.edu>
X-X-Sender: ballen@trinity.phys.uwm.edu
To: Jeff Garzik <jeff@garzik.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>,
       Douglas Gilbert <dougg@torque.net>
cc: Mark Lord <liml@rtr.ca>, David Greaves <david@dgreaves.com>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Dvorak <fermentol@gmail.com>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>, Robert Hancock <hancockr@shaw.ca>
Subject: Re: SMART problems in 2.6.22
In-Reply-To: <469309FA.6040501@torque.net>
Message-ID: <Pine.LNX.4.63.0707102024300.4142@trinity.phys.uwm.edu>
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu>
 <Pine.LNX.4.64.0707092341280.4779@kai.makisara.local> <469309FA.6040501@torque.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Douglas Gilbert wrote:

> Kai Makisara wrote:

>> I have done some more debugging on this one. An easy way to reproduce 
>> the

<SNIP>

>> The log shows that the sense data returned by the commands differ: with 
>> 2.6.22 the bytes 4f and 2c (tf.lbam and tf.lbah) are not returned. Both 
>> of the status commands fail to return these bytes but the tests in 
>> smartctl are more strict for the second case. This is why the second 
>> status command seems to be failing.

<SNIP>

> Kai, Thanks for the analysis.

<SNIP>

> So when smartmontools sees 0 and 0 in those positions it pulls out the 
> red card for that device. My guess is that libata in lk 2.6.22 is 
> corrupting those FIS device to host register values.

Kai, Doug: thank you very much for tracking down the source of this 
problem.

Jeff: OK, from what I am reading here I think that this is a genuine 
libata/kernel bug.  But I'm out of my depth here, so the ball is in your 
court.  Hopefully you'll understand what's going on and how to fix it.

Cheers,
 	Bruce
