Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbYLaWOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbYLaWOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYLaWOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:14:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46628
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbYLaWOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:14:06 -0500
Date: Wed, 31 Dec 2008 14:14:08 -0800 (PST)
Message-Id: <20081231.141408.60544902.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, rdreier@cisco.com, mingo@elte.hu,
       ian.campbell@citrix.com, jeremy.fitzhardinge@citrix.com, deller@gmx.de,
       rusty@rustcorp.com.au, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca, randolph@tausq.org,
       sam@ravnborg.org, dave@hiauly1.hia.nrc.ca
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel
 modules (take 4)
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain>
	<20081231105425.9ccac21d.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0812311318420.5086@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 31 Dec 2008 13:22:53 -0800 (PST)

> On Wed, 31 Dec 2008, Andrew Morton wrote:
> > 
> > Adrian claimed that it was gcc-4.1.0 and 4.1.1 only.  He proposed
> > banning them: http://lkml.org/lkml/2008/8/5/444
> 
> If it really is just those releases, then yes, considering the number of 
> cases we apparently have, and considering how ugly it is in some cases to 
> move the weak function anywhere else, maybe banning those versions is the 
> proper thing to do.
> 
> It probably won't hurt very many people - yeah, some people will be forced 
> to upgrade, but I have this memory of early 4.1 having had other bugs 
> anyway, so it's probably a good idea.

I think this is probably the best way to handle this.
