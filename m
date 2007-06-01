Return-Path: <linux-kernel-owner+w=401wt.eu-S1763664AbXFAUiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763664AbXFAUiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762503AbXFAUiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:38:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55709 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762365AbXFAUiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:38:03 -0400
Message-ID: <466083A5.2080404@garzik.org>
Date: Fri, 01 Jun 2007 16:37:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Brice Goglin <brice@myri.com>
CC: Christoph Hellwig <hch@infradead.org>,
       Steve Wise <swise@opengridcomputing.com>, divy@chelsio.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] cxgb3 - Add SW LRO support
References: <20070225004423.20903.17036.stgit@localhost.localdomain>	 <20070226051304.GA13626@infradead.org>	 <1172585835.11870.13.camel@stevo-desktop>  <45E445D2.2090900@garzik.org> <1172588246.11870.24.camel@stevo-desktop> <45E45C6E.3000504@myri.com>
In-Reply-To: <45E45C6E.3000504@myri.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Goglin wrote:
> Steve Wise wrote:
>> You're right.  But cxgb3 has it now in the driver (tested and working).
>> Shouldn't it be pulled in?  When the network stack design gets done
>> (which could take a few releases to finalize), all the drivers can be
>> updated to use it.  It doesn't seem reasonable to allow some drivers to
>> support LRO and others to not support it...
>>   
> 
> I have to agree with Steve here. We have been requesting the inclusion
> of myri10ge LRO for 5 months now (before 2.6.19). I could understand
> that duplicating LRO code between s2io and myri10ge was not a good idea
> at this point. But, I now see that Netxen got merged way later (in
> 2.6.20) but it got its LRO merged immediately. I guess the LRO is
> already duplicated between s2io and netxen then. It does not look fair
> to me at all.

It was an error on my part, that should not be compounded.  Three wrongs 
don't make a right, etc., etc.

The normal way this stuff works in Linux is that people work together to 
create common code that everybody uses.  I would gladly accept patches 
to rip out the code from NetXen.

	Jeff



