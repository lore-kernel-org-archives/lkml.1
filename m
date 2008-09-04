Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbYIDHeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbYIDHeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbYIDHeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:34:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41037 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960AbYIDHeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:34:08 -0400
Message-ID: <48BF8F6A.7050106@garzik.org>
Date: Thu, 04 Sep 2008 03:34:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
References: <20080903.161341.239039051.davem@davemloft.net> <alpine.LFD.1.10.0809031615450.3515@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809031621160.3515@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809031621160.3515@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 3 Sep 2008, Linus Torvalds wrote:
>> What's so hard to understand about this?
> 
> Here's a simple rule of thumb:
>  - if it's not on the regression list
>  - if it's not a reported security hole
>  - if it's not on the reported oopses list
> then why are people sending it to me?

FWIW, I also upstream fixes for problems that look bad, or are really 
annoying for users, as long as the fixes are short and sweet, e.g.

David Brownell (1):
       net/usb/pegasus: avoid hundreds of diagnostics
Dhananjay Phadke (1):
       netxen: Remove workaround for chipset quirk
Komuro (1):
       pcnet-cs, axnet_cs: add new IDs, remove dup ID with less info

The ixgbe fix was a regression fix, and falls into your category list.

	Jeff


