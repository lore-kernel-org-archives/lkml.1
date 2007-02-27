Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbXB0Oxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbXB0Oxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbXB0Oxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:53:40 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52079 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbXB0Oxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:53:39 -0500
Message-ID: <45E445D2.2090900@garzik.org>
Date: Tue, 27 Feb 2007 09:53:06 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: Christoph Hellwig <hch@infradead.org>, divy@chelsio.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] cxgb3 - Add SW LRO support
References: <20070225004423.20903.17036.stgit@localhost.localdomain>	 <20070226051304.GA13626@infradead.org> <1172585835.11870.13.camel@stevo-desktop>
In-Reply-To: <1172585835.11870.13.camel@stevo-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> On Mon, 2007-02-26 at 05:13 +0000, Christoph Hellwig wrote:
>> On Sat, Feb 24, 2007 at 04:44:23PM -0800, divy@chelsio.com wrote:
>>> From: Divy Le Ray <divy@chelsio.com>
>>>
>>> Add all-in-sw lro support.
>> Doing this in a LLDD doesn't sound like a good idea.  Have you
>> tried doing this in the core networking code instead?
> 
> It looks like both Netxen and Neterion drivers already have this.  So I
> think for now the LLDD implements LRO.  The stack supports it by virtue

That's argument to further avoiding compounding the problem, by 
reinventing the wheel for each driver.

	Jeff



