Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYH0HLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYH0HLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYH0HLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:11:01 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:49874 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320AbYH0HLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:11:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=IlId18x2zGxY37AXVizqY7gIYAwfks5DlyKJE/4pjisl3eK/nw5VJndq7gRIphEx;
  h=Received:Cc:Message-Id:From:To:In-Reply-To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:References:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Cc: David Woodhouse <dwmw2@infradead.org>, Tim Anderson <tanderson@mvista.com>,
       "linux-mtd-bounces@lists.infradead.org" 
	<linux-mtd-bounces@lists.infradead.org>,
       "Bruce_Leonard@selinc.com" <Bruce_Leonard@selinc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
Message-Id: <65B57CA3-D423-42B8-B795-3D304DD05AFD@earthlink.net>
From: Bruce Leonard <brucle@earthlink.net>
To: Ricard Wanderlof <ricard.wanderlof@axis.com>
In-Reply-To: <Pine.LNX.4.64.0808270847350.17432@lnxricardw.se.axis.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
Date: Wed, 27 Aug 2008 00:10:44 -0700
References: <000201c9080d$0bce0d20$6b01a8c0@mvista.com> <1219818923.7107.106.camel@pmac.infradead.org> <Pine.LNX.4.64.0808270847350.17432@lnxricardw.se.axis.com>
X-Mailer: Apple Mail (2.926)
X-ELNK-Trace: 481fc18f0ae4055094f5150ab1c16ac08868399773331e30d602b1c2741c66c479583a0582fa3b49350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 70.110.34.130
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 26, 2008, at 11:49 PM, Ricard Wanderlof wrote:
>
> If the (lack of) sysfs stuff is standing between us and a nice >4GiB  
> mtd I for one would think that a set of 64-bit ioctls would be a  
> reasonable halfway house.
>

Having started this mess, I'll throw my half euros worth in :).  While  
I agree that sysfs is the right way to go, I'm not going to be able to  
pull it off.  Not withstanding my total lack of knowledge about sysfs,  
I've been very fortunate in that I've been doing all of this work on  
company time.  Due to project constraints, that company time is coming  
to an end.  I could eek out another week or two and get a set of 64- 
bit ioctls, but I will not be able to spend a couple more months of  
company time learning sysfs and implementing it.  And I just don't  
have any personal time to spare right now.  I'm sorry, if it's  
anything other than ioctl I just can't do it.

That being said, if a set of ioctls is acceptable, I'm more than happy  
to take that on as soon as we reach a consensus.

Bruce
