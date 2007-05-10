Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbXEJVds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbXEJVds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbXEJVdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:33:41 -0400
Received: from rtr.ca ([64.26.128.89]:4561 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354AbXEJVdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:33:40 -0400
Message-ID: <46438FAC.1030702@rtr.ca>
Date: Thu, 10 May 2007 17:33:32 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] libata: add human-readable error value decoding
References: <46428103.3040003@shaw.ca> <4642E92D.5010509@gmail.com> <46431D19.1070308@rtr.ca> <46434AE5.8060605@garzik.org>
In-Reply-To: <46434AE5.8060605@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Mark Lord wrote:
>> Same here, but I would like to see it in there under a 
>> CONFIG_DEBUG_LIBATA
>> kernel build option or something.  Kind of like the 
>> "FANCY_STATUS_DUMPS" flag
>> that drivers/ide used to have for this kind of stuff.
> 
> 
> The long term goal is to enable verbose output with a module option 
> and/or sysfs knob, rather than a compile-time switch.

If we're compiling the messages into the kernel regardless,
then it doesn't really make much sense to NOT show all of them
on the error paths.

This stuff (fancy status dumps) is mostly just for the error paths,
where more information is always a good thing.

Controlling the rest of the ata_msg_xxx stuff from sysctl is fine
for non-error paths.

Cheers
