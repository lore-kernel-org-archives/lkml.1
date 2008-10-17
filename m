Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbYJQFVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbYJQFVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 01:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYJQFVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 01:21:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49257
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbYJQFVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 01:21:31 -0400
Date: Thu, 16 Oct 2008 22:21:08 -0700 (PDT)
Message-Id: <20081016.222108.13382080.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: benh@kernel.crashing.org, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
	<20081016.210404.151891223.davem@davemloft.net>
	<alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Oct 2008 21:18:08 -0700 (PDT)

> I dunno. I'd certainly be perfectly happy with having the flags and 
> field_width be specified by the resource flags. eg
> 
> 	flags = ZEROPAD | SMALL;
> 	fieldwidth = (res->flags & IORESOURCE_IO) ? 4 : 8;
> 
> or something like that. But would it be acceptable to everybody?

I personally appreciate seeing the full 64-bit address on sparc64,
even for IORESOURCE_IO, and that's helped me debug resource
calculation bugs on more than one occasion in the past.

But that's just me :)
