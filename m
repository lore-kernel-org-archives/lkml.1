Return-Path: <linux-kernel-owner+w=401wt.eu-S934810AbXHGPn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810AbXHGPn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbXHGPns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:43:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49605 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbXHGPnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:43:47 -0400
Message-ID: <46B89331.5020305@garzik.org>
Date: Tue, 07 Aug 2007 11:43:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
References: <1186248703.3439.20.camel@localhost.localdomain>	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>	 <1186458941.6637.44.camel@localhost.localdomain>	 <20070807001429.f8cb3b22.akpm@linux-foundation.org>	 <1186496712.3414.17.camel@localhost.localdomain>	 <46B88B91.4050703@garzik.org> <1186501124.3414.32.camel@localhost.localdomain>
In-Reply-To: <1186501124.3414.32.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> It followed the rule of trying to stabilise outside mainline ... it just
> didn't get sufficient integration testing.

IMO it's self-evident that pushing to a git tree few ever see or test is 
not following the spirit of the rule.

In practice, stabilize outside mainline implies -mm integration, in 
addition to whatever else a maintainer does specific to their subsystem.


>>> I wouldn't call bsg half baked ... it was very carefully matured.  There
>>> were just a few integration issues.
>> I wouldn't call bsg carefully matured, if in addition to not really 
>> gracing -mm with its presence, the userland API structure is still 
>> getting changes on July 29, 2007 (0c6a89ba640d28e1dcd7fd1a217d2cfb92ae4953).
> 
> This would be the ABI change I talked about in the previous emails.
> 
> So would this problem have been fixed simply by adding the missing block
> tree to -mm?

IMO 70% of the problem would be solved by that.

It wouldn't have solved the late ABI change though (which was first 
posted in earlier form on April 4th, and so, had time for integration).

	Jeff


