Return-Path: <linux-kernel-owner+w=401wt.eu-S1030521AbXC2R2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030521AbXC2R2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030496AbXC2R2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:28:31 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:37927 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030360AbXC2R2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:28:30 -0400
Message-ID: <460BF73C.5070707@cfl.rr.com>
Date: Thu, 29 Mar 2007 13:28:28 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux@horizon.com,
       htejun@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
References: <20070327161616.31448.qmail@science.horizon.com> <Pine.LNX.4.64.0703271224400.5965@p34.internal.lan> <460A7EE7.5070101@cfl.rr.com> <460A8053.3040209@garzik.org>
In-Reply-To: <460A8053.3040209@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2007 17:28:41.0469 (UTC) FILETIME=[B1BE7AD0:01C77227]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15084.000
X-TM-AS-Result: No--5.934500-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> NCQ provides for a more asynchronous flow.  It helps greatly with reads 
> (of which most are, by nature, synchronous at the app level) from 
> multiple threads or apps.  It helps with writes, even with write cache 
> on, by allowing multiple commands to be submitted and/or retired at the 
> same time.

But when writing, what is the difference between queuing multiple tagged 
writes, and sending down multiple untagged cached writes that complete 
immediately and actually hit the disk later?  Either way the host keeps 
sending writes to the disk until it's buffers are full, and the disk is 
constantly trying to commit those buffers to the media in the most 
optimal order.


