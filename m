Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYDSI3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYDSI3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 04:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYDSI2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 04:28:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46575 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbYDSI2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 04:28:53 -0400
Message-ID: <4809AD38.6090505@garzik.org>
Date: Sat, 19 Apr 2008 04:28:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: linux-arm-kernel@lists.arm.linux.org.uk, kernel@wantstofly.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/15] ARM minor irq handler cleanups
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <20080419081712.GA8523@flint.arm.linux.org.uk>
In-Reply-To: <20080419081712.GA8523@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Fri, Apr 18, 2008 at 07:22:45PM -0400, Jeff Garzik wrote:
>> Avoid confusion by /not/ passing an unused pointer to
>> arm_rtc_interrupt()
>>
>> This change's main purpose is to prepare for the patchset in
>> jgarzik/misc-2.6.git#irq-remove, that explores removal of the
>> never-used 'irq' argument in each interrupt handler.
> 
> I don't see how these two things are connected.  Yes, it's true that
> this RTC driver doesn't use 'dev_id' but that's an entirely separate
> issue to removing the 'int irq' argument.
> 
> As I see it, this change is just unnecessarily adding to your workload
> for this patch set.

The added workload came from confusion created when I reviewed the code :)

Therefore I considered it better to have to less confusing version of 
the code in my tree for future reviews, and ideally have the less 
confusing version of the code in upstream as well.

I can remove the boilerplate paragraph from the patch description, if 
that's your main complaint.

	Jeff



