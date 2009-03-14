Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbZCNHqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbZCNHqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 03:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZCNHqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 03:46:39 -0400
Received: from www.tglx.de ([62.245.132.106]:38431 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbZCNHqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 03:46:38 -0400
Date: Sat, 14 Mar 2009 08:46:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] 2.6.29-rc7-rt1
In-Reply-To: <1236984825.10748.17.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain>
References: <1235437021.4462.25.camel@localhost.localdomain>  <alpine.LFD.2.00.0902241120320.3523@localhost.localdomain>  <alpine.LFD.2.00.0902241729590.3523@localhost.localdomain>  <1235513895.3816.11.camel@localhost.localdomain>  <1235595160.9252.49.camel@localhost.localdomain>
  <1235619922.31774.17.camel@localhost.localdomain> <1236984825.10748.17.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009, Fernando Lopez-Lezcano wrote:
> After a quick test some BUG's on boot (on a quad core intel machine),
> I'm just attaching the whole dmesg output as that might provide more
> clues...
> 
> In short, two types, one BUG and another WARNING:
> 
> BUG: sleeping function called from invalid context at
> kernel/rtmutex.c:683
> WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x3e/0xa8()

Yep. I got another report already. Looking into it.
 
> Thanks again for all the hard work!
> (and looking forward to the next rt patch!)

Thansk for testing !

       tglx
