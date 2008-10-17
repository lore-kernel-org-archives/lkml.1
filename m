Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbYJQVEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbYJQVEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYJQVEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:04:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:37032 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbYJQVEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:04:15 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.2.00.0810170852010.3438@nehalem.linux-foundation.org>
References: <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>
	 <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
	 <20081016.210404.151891223.davem@davemloft.net>
	 <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
	 <1224220339.7654.84.camel@pasglop>
	 <alpine.LFD.2.00.0810170852010.3438@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 18 Oct 2008 08:03:33 +1100
Message-Id: <1224277413.7654.95.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Do you think alpha wants to see its PIO resources shown as
> 
> 	[00000000000001f0-00000000000001f7]
> 
> or
> 
> 	[01f0-01f7]
> 
> and which do you think is more readable?
> 
> And even on sparc, with the full 64 bits in use, it's not like we'd be 
> *truncating* to 4 hex digits with %04x.

I said archs could add themselves to the list who wants smaller
resources. I don't know which arch wants what here, I just provided
some defaults. Maybe we could move those define to asm/*.h tho.

Cheers,
Ben.


