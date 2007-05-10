Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbXEJQk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbXEJQk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbXEJQkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:40:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57594 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbXEJQkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:40:10 -0400
Message-ID: <46434AE5.8060605@garzik.org>
Date: Thu, 10 May 2007 12:40:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Tejun Heo <htejun@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] libata: add human-readable error value decoding
References: <46428103.3040003@shaw.ca> <4642E92D.5010509@gmail.com> <46431D19.1070308@rtr.ca>
In-Reply-To: <46431D19.1070308@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Same here, but I would like to see it in there under a CONFIG_DEBUG_LIBATA
> kernel build option or something.  Kind of like the "FANCY_STATUS_DUMPS" 
> flag
> that drivers/ide used to have for this kind of stuff.


The long term goal is to enable verbose output with a module option 
and/or sysfs knob, rather than a compile-time switch.

That's what ata_msg_xxx is for.  We just don't have the knob yet. 
Patches welcome...

	Jeff



