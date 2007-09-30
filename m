Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbXI3Pnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbXI3Pnv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbXI3Pnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:43:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52339 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbXI3Pnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:43:42 -0400
Message-ID: <46FFC42A.9080300@garzik.org>
Date: Sun, 30 Sep 2007 11:43:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Paolo Ornati <ornati@fastwebnet.it>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
References: <20070930160548.235be972@localhost>	<20070930152908.1f58d39d@the-village.bc.nu>	<20070930164610.20818867@localhost>	<46FFBB2D.6060004@garzik.org> <20070930172859.7fd44eab@localhost>
In-Reply-To: <20070930172859.7fd44eab@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ornati wrote:
> On Sun, 30 Sep 2007 11:05:17 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>>> I have this problem only with XFS, and even with XFS it goes away
>>> mounting with "nobarrier"...  
>> This last is an interesting datapoint.
>>
>> I wonder if libata has a generic problem with NCQ + FLUSH CACHE.
>>
>> What happens if you enable the 'fua' module parameter?  (libata.fua on 
>> kernel command line, if built in)
> 
> it isn't supported here:
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Did you actually try my suggestion?

That message is normal, because libata defaults to FUA==off.

	Jeff



