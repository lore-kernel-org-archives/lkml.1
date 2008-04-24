Return-Path: <linux-kernel-owner+w=401wt.eu-S1763349AbYDXPj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763349AbYDXPj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbYDXPjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:39:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41511
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757844AbYDXPjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:39:08 -0400
Date: Thu, 24 Apr 2008 08:39:08 -0700 (PDT)
Message-Id: <20080424.083908.147395158.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, drepper@redhat.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0804240828100.2779@woody.linux-foundation.org>
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
	<20080424112514.055d8071@the-village.bc.nu>
	<alpine.LFD.1.10.0804240828100.2779@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Apr 2008 08:29:14 -0700 (PDT)

> 
> 
> On Thu, 24 Apr 2008, Alan Cox wrote:
> > 
> > Given we will never have 2^32 socket types, and in a sense this is part
> > of the type why not just use
> > 
> > 	socket(PF_INET, SOCK_STREAM|SOCK_CLOEXEC, ...)
> 
> Ok, I have to admit that I find this very appealing. It looks much 
> cleaner, but perhaps more importantly, it also looks both readable _and_ 
> easier to use for the user-space programmer.

Me too.
