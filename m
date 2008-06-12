Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYFLWIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYFLWIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYFLWIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:08:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58091 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbYFLWI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:08:29 -0400
Message-ID: <48519E57.3030906@garzik.org>
Date: Thu, 12 Jun 2008 18:08:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver updates for .27
References: <20080612023046.GA25958@havoc.gtf.org>	<20080612133842.0dc472bc.sfr@canb.auug.org.au> <20080611.212929.71729484.davem@davemloft.net>
In-Reply-To: <20080611.212929.71729484.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 12 Jun 2008 13:38:42 +1000
> 
>> Hi Jeff,
>>
>> On Wed, 11 Jun 2008 22:30:46 -0400 Jeff Garzik <jeff@garzik.org> wrote:
>>> Stephen Rothwell (1):
>>>       [netdrvr] Fix 8390 build breakage
>> That patch is actually from Tony Breeds ..
> 
> Jeff, there is still time to fix this.  If you want, just
> fix up that patch in your tree to get the attribution
> and author field correct, and send me a new pull request.

Did you actually read the commit description?  It's quite clear who 
originated the commit:


commit 0c1aa20fb87b796d904f4d89ad12e5a0c483127b
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Thu May 29 22:39:28 2008 +1000

     [netdrvr] Fix 8390 build breakage

     From: tony@bakeyournoodle.com (Tony Breeds)

     ...

     Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
     Signed-off-by: Jeff Garzik <jgarzik@redhat.com>


It's pretty hard to miss, and it accurately captures the entire audit trail:

1) who sent the patch?
2) who wrote the patch?
3) who committed the patch?

So, you want to eliminate part of that audit trail (#1), making the 
commit audit trail more hidden and opaque?

I respectfully disagree.  We should capture the _entire_ audit trail, 
not hide bits of it.

Full credit is given, as you can see from looking at the commit.

	Jeff



