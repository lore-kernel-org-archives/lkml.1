Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbXBWRzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbXBWRzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 12:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932479AbXBWRzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 12:55:33 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:60065 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472AbXBWRzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 12:55:32 -0500
X-Greylist: delayed 1803 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 12:55:32 EST
In-Reply-To: <20070223153743.GA26141@wotan.suse.de>
References: <20070223153743.GA26141@wotan.suse.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5FD7605C-E132-4893-86FA-F76DDFB16389@zabbo.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zab@zabbo.net>
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Date: Fri, 23 Feb 2007 09:25:28 -0800
To: Nick Piggin <npiggin@suse.de>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 23, 2007, at 7:37 AM, Nick Piggin wrote:

>
> The dentry hash uses up 8MB for 1 million entries on my 4GB system  
> is one
> of the biggest wasters of memory for me. Because I rarely have more  
> than one or
> two hundred thousand dentries. And that's with several kernel trees  
> worth of
> entries. Most desktop and probably even many types of servers will  
> only use a
> fraction of that.
>
> So I introduce a new method for resizing hash tables with RCU, and  
> apply
> that to the dentry hash.

Can you compare what you've done to the design that Paul and David  
talked about a year ago?

   http://lkml.org/lkml/2006/1/30/74

I'd love to see a generic implementation of RCU hashing that  
subsystems can then take advantage of.  It's long been on the fun  
side of my todo list.  The side I never get to :/.

- z

