Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbXFNStI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbXFNStI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbXFNSsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:48:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48264 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbXFNSsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:48:55 -0400
Message-ID: <46718D81.9080402@garzik.org>
Date: Thu, 14 Jun 2007 14:48:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, dcbw@redhat.com,
       hs4233@mail.mn-solutions.de, linux-kernel@vger.kernel.org
Subject: Re: libertas (private) ioctls vs. nl80211
References: <1181757483.29767.99.camel@johannes.berg> <20070614170901.GA13384@infradead.org> <20070614103836.23b07a72.akpm@linux-foundation.org> <20070614181307.GA16856@infradead.org> <alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 14 Jun 2007, Christoph Hellwig wrote:
>>> I suspect that the probability of your proposal succeeding would be increased
>>> if you could prepare a patch...
>> Here we go:
> 
> I don't mind ripping them out, but it makes sense only if people are 
> actually signed up to implementing this on a higher layer. As such, I'd 
> need to get a sign-off from somebody actually involved in wireless mesh 
> stuff etc.

Correct me if I'm wrong, linux-wireless, but AFAIK there has never been 
a single post or line of code written for a generic wireless _mesh_ 
interface.

My general sentiment is -- remove the pointless and iw-duplicated 
ioctls, but leave the mesh ones that won't see generic counterparts for 
years.

	Jeff


