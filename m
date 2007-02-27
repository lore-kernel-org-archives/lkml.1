Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827AbXB0QzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbXB0QzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbXB0QzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:55:09 -0500
Received: from dsl.myri.com ([64.172.73.26]:1929 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751827AbXB0QzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:55:08 -0500
X-Greylist: delayed 1338 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Feb 2007 11:55:08 EST
Message-ID: <45E45C6E.3000504@myri.com>
Date: Tue, 27 Feb 2007 17:29:34 +0100
From: Brice Goglin <brice@myri.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>
CC: Steve Wise <swise@opengridcomputing.com>, divy@chelsio.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] cxgb3 - Add SW LRO support
References: <20070225004423.20903.17036.stgit@localhost.localdomain>	 <20070226051304.GA13626@infradead.org>	 <1172585835.11870.13.camel@stevo-desktop>  <45E445D2.2090900@garzik.org> <1172588246.11870.24.camel@stevo-desktop>
In-Reply-To: <1172588246.11870.24.camel@stevo-desktop>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> You're right.  But cxgb3 has it now in the driver (tested and working).
> Shouldn't it be pulled in?  When the network stack design gets done
> (which could take a few releases to finalize), all the drivers can be
> updated to use it.  It doesn't seem reasonable to allow some drivers to
> support LRO and others to not support it...
>   

I have to agree with Steve here. We have been requesting the inclusion
of myri10ge LRO for 5 months now (before 2.6.19). I could understand
that duplicating LRO code between s2io and myri10ge was not a good idea
at this point. But, I now see that Netxen got merged way later (in
2.6.20) but it got its LRO merged immediately. I guess the LRO is
already duplicated between s2io and netxen then. It does not look fair
to me at all.

Thank you for understanding our concerns.
Brice

