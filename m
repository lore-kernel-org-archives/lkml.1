Return-Path: <linux-kernel-owner+w=401wt.eu-S2992702AbXCBWuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992702AbXCBWuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992706AbXCBWuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:50:07 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54362 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992702AbXCBWuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:50:04 -0500
Message-ID: <45E8AA1B.6000803@garzik.org>
Date: Fri, 02 Mar 2007 17:50:03 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, torvalds@osdl.org
Subject: Re: [PATCH] libata: Cable detection fixes
References: <20070301173003.5d5ab4a6@lxorguk.ukuu.org.uk>	<45E77D60.0@garzik.org> <20070302124534.5fcfec9f@lxorguk.ukuu.org.uk>
In-Reply-To: <20070302124534.5fcfec9f@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> However, given that we are in -rc cycle, and the wide impact of this 
>> change, this patch wants splitting.  The ->cable_detect stuff should be 
>> in a separate patch from the IDENTIFY DEVICE ordering stuff.  This 
>> ensures sanity when git-bisecting changes, and allows fast-tracking of 
>> the identify-ordering change.
> 
> Fine by me - I carefully sent Linus the hook but no changes using it and
> sent those changes just to the list/you.

The implication was that you should revise, sign-off, and resend, like 
all the other kernel developers do when they receive feedback during 
engineering review...

Nonetheless, I extracted and applied the patch I mention above, and will 
send it upstream today.

	Jeff



