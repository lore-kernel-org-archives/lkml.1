Return-Path: <linux-kernel-owner+w=401wt.eu-S1762688AbXJZCHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762688AbXJZCHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbXJZCHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:07:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33579 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823AbXJZCHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:07:19 -0400
Message-ID: <47214BD5.4020106@garzik.org>
Date: Thu, 25 Oct 2007 22:07:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Remove #warnings for longstanding conditions.
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org> <03231528cf69b4194111178db23a7a387a573cb7.1193299380.git.jeff@garzik.org> <20071025112231.GL27248@parisc-linux.org>
In-Reply-To: <20071025112231.GL27248@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:

>> drivers/scsi/advansys.c:71:2: warning: #warning this driver is still
>> not properly converted to the DMA API

> I'll be removing this #warning from advansys when I get rid of the
> last bus_to_virt.  Which I've already done ... it's just that the
> resulting driver works on i386, but crashes parisc, so there's clearly a
> bug.  I haven't had time to track it down yet.  So NACK this patch.

Well, two main questions...

Is this warning of value to anybody but you?
Is this information worth printing out on everyone else's kernel build?

If yes, great!  But it sounds like this warning is analagous to

   #warning willy's TODO list: get milk, buy groceries, read email, ...

which doesn't add much value to others' kernel builds :)

	Jeff


