Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbXIOEI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbXIOEI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 00:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750723AbXIOEIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 00:08:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42270 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbXIOEIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 00:08:44 -0400
Message-ID: <46EB5ACA.5000207@garzik.org>
Date: Sat, 15 Sep 2007 00:08:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage. Move away from char device ioctls.
References: <20070914185429.GA9439@2ka.mipt.ru> <46EADC02.9070409@garzik.org> <20070914211210.GB12444@fieldses.org> <46EAF9CD.1090808@garzik.org> <20070914211828.GC12444@fieldses.org> <46EB0BEB.2090808@garzik.org> <20070914224212.GJ12444@fieldses.org>
In-Reply-To: <20070914224212.GJ12444@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Fri, Sep 14, 2007 at 06:32:11PM -0400, Jeff Garzik wrote:
>> J. Bruce Fields wrote:
>>> On Fri, Sep 14, 2007 at 05:14:53PM -0400, Jeff Garzik wrote:
>>>> NFSv4.1 adds to the fun, by throwing interoperability completely out the 
>>>> window.

>>> What parts are you worried about in particular?

>> I'm not worried; I'm stating facts as they exist today (draft 13):
>>
>> NFS v4.1 does something completely without precedent in the history of NFS: 
>>  the specification is defined such that interoperability is -impossible- to 
>> guarantee.
>>
>> pNFS permits private and unspecified layout types.  This means it is 
>> impossible to guarantee that one NFSv4.1 implementation will be able to 
>> talk another NFSv4.1 implementation.

> No, servers are required to support ordinary nfs operations to the
> metadata server.
> 
> At least, that's the way it was last I heard, which was a while ago.  I
> agree that it'd stink (for any number of reasons) if you ever *had* to
> get a layout to access some file.
> 
> Was that your main concern?

I just sorta assumed you could fall back to the NFSv4.0 mode of 
operation, going through the metadata server for all data accesses.

But look at that choice in practice:  you can either ditch pNFS 
completely, or use a proprietary solution.  The market incentives are 
CLEARLY tilted in favor of makers of proprietary solutions.  But it's a 
poor choice (really little choice at all).

Overall, my main concern is that NFSv4.1 is no longer an open 
architecture solution.  The "no-pNFS or proprietary platform" choice 
merely illustrate one of many negative aspects of this architecture.

One of NFS's biggest value propositions is its interoperability.  To 
quote some Wall Street guys, "NFS is like crack.  It Just Works.  We 
love it."

Now, for the first time in NFS's history (AFAIK), the protocol is no 
longer completely specified, completely known.  No longer a "closed 
loop."  Private layout types mean that it is _highly_ unlikely that any 
OS or appliance or implementation will be able to claim "full NFS 
compatibility."

And when the proprietary portion of the spec involves something as basic 
as accessing one's own data, I consider that a fundamental flaw.  NFS is 
no longer completely open.

	Jeff



