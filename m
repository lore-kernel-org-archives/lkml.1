Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYIVPLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYIVPLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYIVPLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:11:16 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.10.160]:55205 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYIVPLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:11:16 -0400
Message-ID: <48D7B591.8000408@cmu.edu>
Date: Mon, 22 Sep 2008 11:11:13 -0400
From: George Nychis <gnychis@cmu.edu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: printing current system time from kernel space
References: <48D72AAD.3000805@cmu.edu> <48D74431.8050805@yahoo.com>
In-Reply-To: <48D74431.8050805@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sitsofe Wheeler wrote:
> George Nychis wrote:
>> I spent some time googling, but could not find out how or if it is 
>> possible to read the current system time in kernel space.  I could 
>> insert a printk() somewhere in usbdev_read() then.
> 
> If that's what you want to do could you not turn on timestamps on printk 
> (CONFIG_PRINTK_TIME in the kernel hacking menu)?
> 

Thanks for the response!

You might be misunderstanding my goal.  I need a common clock between 
kernel and user space, so that I can say:

Event1 happened at time X in the kernel
Event2 happened at time X+Y in user space
The time between Event1 and Event2 was Y-X

So, turning off timestamps does not help anything here :)

What might be useful is if user space can read the current timestamp 
value that printk uses, that way I can just do a printk in the kernel 
and then read the value and print in user space.

Is this possible?

Thanks!
George
